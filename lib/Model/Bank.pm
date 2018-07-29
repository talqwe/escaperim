package Bank;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Moose::Role;

sub new{
    my $class = shift;
    my $USER_CONF = shift || {};
    my $bank_name = shift || 0;

    my $this = {
        CGI     => undef,
        DBC     => undef,
        ID      => 0,
    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    bless $this;

    $this->TableToFunc();
    $this->{$bank_name} = $this->{GET_BANK}->{$bank_name}->() if($bank_name);

    return $this;
}

sub TableToFunc{
    my $this = shift;

    $this->{GET_BANK} = {
      'User'       => sub { return { users => $this->GetTableData('user'), my_rooms => $this->GetUsersRooms() } },
      'Room'       => sub { $this->GetRoomsData(); },
      'Company'       => sub { $this->GetTableData('company'); },
    };
}

sub GetTableData{
    my $this = shift;
    my $table = shift;
    my $select = "select * from ".$table." where 1=1 ";
    my ($add, $arr) = $this->GetIDParams();
    return $this->{DBC}->GetDBData($select.$add, undef, undef, $arr);
}

sub GetRoomsData{
    my $this = shift;

    my $select = "SELECT r.*,c.name as company,y.name as city from room r, company c, city y where r.company_id = c.id and r.city_id = y.id";
    my ($add, $arr) = $this->GetIDParams('r');
    return $this->{DBC}->GetDBData($select.$add, undef, undef, $arr);
}

sub GetUsersRooms{
    my $this = shift;
    my $select = "SELECT r.*,r.id as room_id,c.name as company,y.name as city from room r, company c, city y, user_room ur where r.company_id = c.id and r.city_id = y.id and ur.room_id = r.id and ur.user_id = ?";
    return $this->{DBC}->GetDBData($select, undef, undef, [ $this->{ID} ]);
}

sub GetIDParams{
    my $this = shift;
    my $table = shift || "";
    $table .= "." if($table);

    my $addition = "";
    my $arr = [];

    if($this->{ID}){
        if(ref($this->{ID}) eq 'ARRAY'){
            $addition .= " and ".$table."id in(".join(',', map { "?" } @{$this->{ID}}).")";
            push @$arr, @{$this->{ID}};
        }else{
            $addition .= " and ".$table."id = ?";
            push @$arr, $this->{ID};
        }
    }

    return ($addition, $arr);
}

sub GetUserLogin{
    my $this = shift;
    my $user = shift;
    my $pass = shift;

    my $select = "select * from user where name = ? and password = SHA2(?, 256) and approved = 1";
    my $data = $this->{DBC}->GetDBData($select, undef, undef, [ $user, $pass ]);

    my $id = (keys %$data)[0] || return;

    return $data->{$id} || return;
}

sub GetUserByToken{
    my $this = shift;
    my $token = shift;

    my $select = "select * from user where token = ?";
    my $data = $this->{DBC}->GetDBData($select, undef, undef, [ $token ]);

    return $data;
}

1;
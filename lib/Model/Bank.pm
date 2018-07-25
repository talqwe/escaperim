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
      'User'       => sub { return { users => $this->GetData('user'), my_rooms => $this->GetUsersRooms() } },
      'Room'       => sub { $this->GetRoomsData(); },
      'Company'       => sub { $this->GetData('company'); },
    };
}

sub GetData{
    my $this = shift;
    my $table = shift;
    return $this->{DBC}->GetDBData("select * from ".$table);
}

sub GetRoomsData{
    my $this = shift;
    my $arr = [];

    my $select = "SELECT r.*,c.name as company,y.name as city from room r, company c, city y where r.company_id = c.id and r.city_id = y.id";
    if($this->{ID}){
        $select .= " and r.id = ?";
        push @$arr, $this->{ID};
    }
    return $this->{DBC}->GetDBData($select, undef, undef, $arr);
}

sub GetUsersRooms{
    my $this = shift;
    my $select = "SELECT r.*,c.name as company,y.name as city from room r, company c, city y, user_room ur where r.company_id = c.id and r.city_id = y.id and ur.room_id = r.id and ur.user_id = ?";
    return $this->{DBC}->GetDBData($select, undef, undef, [ $this->{ID} ]);
}


1;
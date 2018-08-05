package Friend;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Model::Generic;
use Model::Bank;
use Moose::Role;

with 'Generic';

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {
        CGI     => undef,
        DBC     => undef,
        TABLE   => __PACKAGE__,
        ID      => undef,
        search_friend   => undef,
        UNIQUE  => {
            id          => 1,
        },

        ORDER   => [
#            'id',
#            'user',
            'friend',
            'approved',
        ],

        vars    => {
            id              => 0,
            user_id         => 0,
            friend_id       => '',
        },

    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    map {$this->{vars}->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %{$this->{vars}};
    bless $this;

    $this->{BANK} = new Bank({ CGI => $this->{CGI}, DBC => $this->{DBC}, ID => $this->{ID} }, __PACKAGE__);

    return $this;
}

sub Add{
    my $this = shift;

}

sub Display{
    my $this = shift;

    $this->{BANK}->{Friend} = $this->GetFriendList();

    return Generic::Display($this);
}

sub Search{
    my $this = shift;
    my $error = 0;

    my $select = "SELECT * from user where name = ? or email = ? or facebook_url = ? or facebook_url = concat('https://',?)";

    my $data = $this->{DBC}->GetDBData($select, undef, undef, [ $this->{search_friend}, $this->{search_friend}, $this->{search_friend}, $this->{search_friend} ]);
    my $count = scalar keys %$data;

    if($count == 1){
        $this->{vars}->{friend_id} = (keys %$data)[0];
        my $exists = $this->GetFriendRelations($this->{vars}->{user_id}, $this->{vars}->{friend_id});

        $this->Create() if(!$exists);
    }

    return {
        ERROR => $error || ($count == 1)?(0):(1),
        FRIEND_NAME => $data->{$this->{vars}->{friend_id}}->{name} || "",
    };

}

sub GetFriendRelations{
    my $this = shift;
    my $user_id = shift;
    my $friend_id = shift;

    my $select = "select * from friend where (user_id = ? and friend_id = ?) or (friend_id = ? and user_id = ?)";
    my $data = $this->{DBC}->GetDBData($select, undef, undef, [ $user_id, $friend_id, $user_id, $friend_id ]);

    return (scalar keys %$data)?(1):(0);
}

sub GetFriendList{
    my $this = shift;
    my $fdata = {};

    my $data = $this->{BANK}->GetTableData('user');

    foreach my $id (keys %{$this->{BANK}->{Friend}}){
        my $friend_id = $this->{BANK}->{Friend}->{$id}->{friend_id};
        my $user_id = $this->{BANK}->{Friend}->{$id}->{user_id};
        my $friend_name = $data->{$friend_id}->{name};
        my $user_name = $data->{$user_id}->{name};

        $fdata->{$id}->{friend} = ($this->{vars}->{user_id} == $this->{BANK}->{Friend}->{$id}->{user_id})?($friend_name):($user_name);
        $fdata->{$id}->{approved} = ($this->{BANK}->{Friend}->{$id}->{approved})?('Yes'):('No');
        $fdata->{$id}->{friend_id} = ($this->{vars}->{user_id} == $this->{BANK}->{Friend}->{$id}->{user_id})?($friend_id):($user_id);
    }

    return $fdata;
}

1;
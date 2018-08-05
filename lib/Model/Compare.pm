package Compare;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Model::Generic;
use Model::Bank;
use Moose::Role;
use Model::Friend;

with 'Generic';

=pod

=cut

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {
        CGI  => undef,
        DBC  => undef,
        ID   => undef,

        vars => {
            user_id => undef,
        }
    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    map {$this->{vars}->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %{$this->{vars}};
    bless $this;

    $this->{BANK} = new Bank({ CGI => $this->{CGI}, DBC => $this->{DBC} });

    return $this;
}

sub Users{
    my $this = shift;
    my $users_rooms = {};
    my $total = {
        ALL_DID     => [],
        ALL_DIDNT  => [],
    };

    my $all_rooms = $this->{BANK}->GetRoomsData();

    foreach my $user_id (@{$this->{ID}}){
        $this->{BANK}->{ID} = $user_id;
        my $rooms = $this->{BANK}->GetUsersRooms();
        map { (push @{$users_rooms->{$_}}, $user_id) } keys %$rooms;
    }

    foreach my $unique_room_id (keys %$all_rooms){
        next if(! $users_rooms->{$unique_room_id});
        if(scalar @{$users_rooms->{$unique_room_id}} == scalar @{$this->{ID}}){
            push @{$total->{ALL_DID}}, $all_rooms->{$unique_room_id};
        }

        delete($all_rooms->{$unique_room_id});
    }

    map { push @{$total->{ALL_DIDNT}}, $all_rooms->{$_} } keys %$all_rooms;

    return $total;
}

sub Prepare{
    my $this = shift;

    my $F = new Friend({ DBC => $this->{DBC}, CGI => $this->{CGI}, user_id => $this->{vars}->{user_id} });
    my $data = $F->GetFriendList();

    return {
        ERROR   => '',
        FRIENDS => $data,
        MY_ID   => $this->{vars}->{user_id},
    }

}



1;
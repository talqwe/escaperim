package User;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Model::Generic;
use Model::Bank;
use Moose::Role;

with 'Generic';

=pod

id
name
email
password
facebook_url
comments

=cut

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {
        CGI     => undef,
        DBC     => undef,
        TABLE   => __PACKAGE__,
        ID      => 0,
        HEADER  => 'users',
        UNIQUE  => {
            id      => 1,
            name    => 1,
            email   => 1,
        },

        ORDER   => [
            'id',
            'name',
            'email',
            'password',
            'facebook_url',
            'comments',
        ],

        vars    => {
            id              => 0,
            name            => '',
            email           => '',
            password        => undef,
            facebook_url    => '',
            comments        => '',
        },

    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    map {$this->{vars}->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %{$this->{vars}};
    bless $this;

    $this->{BANK} = new Bank({ CGI => $this->{CGI}, DBC => $this->{DBC}, ID => $this->{ID} }, __PACKAGE__);

#    print '<pre>'.(Dumper $USER_CONF).'</pre>';
#    print '<pre>'.(Dumper $this).'</pre>';

    return $this;
}

sub Rooms{
    my $this = shift;

    my @temp = @{$this->{ORDER}};

    $this->{ORDER} = [
        'id',
        'name',
        'hebrew_name',
        'company',
        'city',
        'url',
    ];

    my $data = Generic::Display($this, 'my_rooms');

    $this->{ORDER} = \@temp;

#    warn Dumper $this;

    return $data;
}

sub ChangePassword{
    my $this = shift;

    $this->{DBC}->UpdateLine({
        TABLE   => $this->{TABLE},
        COLUMN  => 'password',
        VALUE   => $this->{password},
    });
}



1;
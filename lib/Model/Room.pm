package Room;

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
        TABLE   => 'users',
        UNIQUE  => {
            id            => 1,
            name          => 1,
            hebrew_name   => 1,
        },

        ORDER   => [
            'id',
            'name',
            'hebrew_name',
            'company_id',
            'city_id',
            'url',
        ],

        vars    => {
            id              => 0,
            name            => '',
            hebrew_name     => '',
            company_id      => 0,
            city_id         => 0,
            url             => '',
        },

    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    map {$this->{vars}->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %{$this->{vars}};
    bless $this;

    $this->{BANK} = new Bank({ CGI => $this->{CGI}, DBC => $this->{DBC}}, __PACKAGE__.'s');

#    print '<pre>'.(Dumper $USER_CONF).'</pre>';
#    print '<pre>'.(Dumper $this).'</pre>';

    return $this;
}



1;
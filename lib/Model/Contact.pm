package Contact;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Model::Generic;
use Model::Bank;
use Moose::Role;
use Model::Company;

with 'Generic';

=pod

id
name
hebrew_name
company_id
city_id
url

=cut

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {
        CGI     => undef,
        DBC     => undef,
        TABLE   => __PACKAGE__,
        ID      => undef,
        UNIQUE  => {
            id          => 1,
        },

        ORDER   => [
            'id',
            'user_id',
            'subject',
            'content',
        ],

        vars    => {
            id              => 0,
            user_id         => 0,
            subject         => '',
            content         => 0,
        },

    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    map {$this->{vars}->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %{$this->{vars}};
    bless $this;

    $this->{BANK} = new Bank({ CGI => $this->{CGI}, DBC => $this->{DBC}, ID => $this->{ID} });

    return $this;
}

sub Form{
    my $this = shift;


}



1;
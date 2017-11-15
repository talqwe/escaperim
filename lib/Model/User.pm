package User;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Model::User;

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {
        CGI     => undef,

    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    bless $this;

    return $this;
}

sub Display{
    print "tal";
}

1;
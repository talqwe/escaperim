package IndexView;

use strict;
use warnings;
use Data::Dumper;
use View::TableView;

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {

    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    bless $this;
    return $this;
}

sub Display{
    my $this = shift;
    my $data = shift;

    #    print Dumper $data;

    print "Index";
}

1;
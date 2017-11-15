package Controller;

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
    print "Content-type: text/html\n\n";

    $this->{MODELS} = BuildAllowedModels();

    return $this;

}

sub PrintDumper{
    my $object = shift;
    print '<pre>'.(Dumper $object).'</pre>';
}

sub BuildAllowedModels{
    my $hash = {};
    PrintDumper \%INC;
    map { if($_ =~ /^Model\/(.*)\.pm$/){ $hash->{$1} = 1 } } keys %INC;
    return $hash;
}

sub Run{
    my $this = shift;

    PrintDumper($this->{MODELS});
    my ($m, $a) = GetParametersFromURI($ENV{PATH_INFO});

    my $model = User->new($this);
    $model->$a();
}

sub GetParametersFromURI{
    my $string = shift;
    my $arr = [ split('\/', $string) ];

    return ($arr->[1], $arr->[2]);
}

1;
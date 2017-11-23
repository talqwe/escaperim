package Controller;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Model::User;
use View::UserView;
use View::GeneralView;
use Controller::DBController;

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {
        CGI     => undef,
        DBC     => new DBController(),
        GV      => new GeneralView(),
        id      => undef,
        name    => undef,
        email   => undef,

    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    bless $this;

    $this->{MODELS} = BuildAllowedModels();
    $this->{GV}->{CGI} = $this->{CGI};

    return $this;

}

sub PrintDumper{
    my $object = shift;
    print '<pre>'.(Dumper $object).'</pre>';
}

sub BuildAllowedModels{
    my $hash = {};
    map { if($_ =~ /^Model\/(.*)\.pm$/){ $hash->{$1} = 1 } } keys %INC;
    return $hash;
}

sub Run{
    my $this = shift;

    my ($m, $a) = GetParametersFromURI($ENV{PATH_INFO});

    my $model = $m->new($this);
    my $return = $model->$a();

    my $view_name = $m.'View';
    my $view = $view_name->new();

    $this->{GV}->Header();
    $view->$a($return);
    $this->{GV}->Footer();
}

sub GetParametersFromURI{
    my $string = shift;
    my $arr = [ split('\/', $string) ];

    return ($arr->[1], $arr->[2]);
}

1;
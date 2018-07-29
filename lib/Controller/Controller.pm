package Controller;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);

use Model::User;
use View::UserView;
use Model::Compare;
use View::CompareView;
use Model::Login;
use View::LoginView;
use Model::Index;
use View::IndexView;
use Model::Room;
use View::RoomView;
use Model::Company;
use View::CompanyView;

use View::GeneralView;
use Controller::DBController;

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {
        CGI      => undef,
        DBC      => new DBController(),
        GV       => new GeneralView(),
        id       => undef,
        name     => undef,
        email    => undef,
        username => undef,
        password => undef,
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

#    print "Content-Type: text/html charset=utf-8\n\n";
    my ($m, $action, $id) = GetParametersFromURI($ENV{PATH_INFO});
    $m = "Login" if(!$m);
    $action = "Display" if($m eq 'Login' && !$action);

    if(!($m eq "Login" && ($action eq "Display" || $action eq "Enter"))){
        $this->{GV}->PrintError('Login Error!') if(!(Login::CheckLogin($this)));
    }

    my @id_arr = split(',', $id) if($id);

    $this->{ID} = undef;

    if(scalar @id_arr){
        if(scalar @id_arr == 1){
            $this->{ID} = $id_arr[0] || undef;
        }else{
            $this->{ID} = \@id_arr;
        }
    }

    my $model = $m->new($this);
    my $return = $model->$action();

    my $view_name = $m.'View';
    my $view = $view_name->new();

    $this->{GV}->Header();
    $view->$action($return);
    $this->{GV}->Footer();
}

sub GetParametersFromURI{
    my $string = shift || "";
    my $arr = [ split('\/', $string) ];

    return ($arr->[1] || undef, $arr->[2] || undef, $arr->[3] || undef);
}

1;
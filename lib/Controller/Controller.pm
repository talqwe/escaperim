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
use Model::Contact;
use View::ContactView;

use View::GeneralView;
use Controller::DBController;

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {
        CGI             => undef,
        DBC             => new DBController(),
        GV              => new GeneralView(),
        id              => undef,
        name            => undef,
        email           => undef,
        username        => undef,
        password        => undef,
        facebook_url    => undef,
        company         => undef,
        hebrew_name     => undef,
        company_id      => undef,
        city_id         => undef,
        url             => undef,
        content         => undef,
        subject         => undef,
        user_id         => undef,
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

sub RaiseError{
    my $this = shift;
    my $msg = shift;

    $this->{GV}->Header();
    $this->{GV}->PrintError($msg);
    $this->{GV}->Footer();
    exit;
}

sub Run{
    my $this = shift;
    my $login = 0;

    #    print "Content-Type: text/html charset=utf-8\n\n";
    my ($m, $action, $id) = GetParametersFromURI($ENV{PATH_INFO});

    $login = Login::CheckLogin($this) if(!(($m eq 'Login') || ($m eq 'User' && $action eq 'Add')));
    RedirectIndex() if((!$m || $m eq 'Login') && $login && ($action ne 'Logout'));
    $m = "Login" if(!$m);
    $action = "Display" if(($m eq 'Login' && !$action) || $m eq 'Index');

    if(!($m eq "Login" || ($m eq 'User' && $action eq 'Add'))){
        if(!($login)){
            $this->RaiseError('Login Error!');
        }
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

    my $data = {};
    $data->{TOKEN} = Login::GetLoginToken();
    $data->{USER_DETAILS} = Login::GetUserDetails($this, $data->{TOKEN});
    $this->{ID} = (keys %{$data->{USER_DETAILS}})[0] if(!$this->{ID} && $m eq 'User');

    my $model = $m->new($this);
    $model->{vars}->{user_id} = (keys %{$data->{USER_DETAILS}})[0] if(exists $model->{vars}->{user_id} && !$model->{vars}->{user_id});

    my $return = $model->$action();
    $return = {} if(!$return);

    $action = $return->{NEW_ACTION} if(ref($return) eq 'HASH' && $return->{NEW_ACTION});

    my $view_name = $m.'View';
    my $view = $view_name->new();

    $this->{GV}->Header();
    $this->{GV}->Layout($data);
    $view->$action($return);
    $this->{GV}->Footer();
}

sub GetParametersFromURI{
    my $string = shift || "";
    my $arr = [ split('\/', $string) ];

    return ($arr->[1] || undef, $arr->[2] || undef, $arr->[3] || undef);
}

sub RedirectIndex{
    print "Content-Type: text/html charset=utf-8\n\n";
    print '<script type="text/javascript">window.location.href = "/escaperim/Index/Display";</script>';
}

1;
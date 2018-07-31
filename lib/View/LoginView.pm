package LoginView;

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

    print '
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
<link href="css/login_index.css" rel="stylesheet">
<link href="../../css/login_index.css" rel="stylesheet">

<div class="container">
    <form action="index.cgi/Login/Enter" method="post" autocomplete="off">
        <div class="row">
            <span class="col-md-offset-7 col-md-4">
                <h1>Compare Escaperim</h1>
            </span>
        </div>
        <div class="row">
            <div class="col-md-offset-7 col-md-4">
                <div class="form-login">
                    <h4>Welcome back.</h4>
                    <input type="text" name="username" autocomplete="off" id="userName" class="form-control input-sm chat-input" placeholder="Username or Email" />
                    </br>
                    <input type="password" name="password" autocomplete="off" id="userPassword" class="form-control input-sm chat-input" placeholder="Password" />
                    </br>
                    <div class="wrapper">
                        <span class="group-btn">
                            <input type="Submit" class="btn btn-primary btn-md">
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
'
}

sub Enter{
    my $this = shift;
    print "tal";
}

1;
package GeneralView;

use strict;
use warnings;

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

sub Header{

    my $this = shift;

    my $params = shift || {
        JS  => [ '/escaperim/js/jquery-2.1.1.js', '/escaperim/js/bootstrap.js' ],
        CSS => [ '/escaperim/css/bootstrap.css' ],
        TITLE => 'Escaprim'
    };

    my $skip_type = shift || 0; ####  optional only in session create ;

    unless(ref($params->{JS}) eq 'ARRAY')
    {push(@{$params->{JS}},$params->{JS});}

    unless(ref($params->{CSS}) eq 'ARRAY')
    {push(@{$params->{CSS}},$params->{CSS});}


    print "Content-Type: text/html charset=utf-8\n\n" unless ($skip_type);
    print '<!DOCTYPE html>

		<html>
    		<head>
        		<meta http-equiv="Content-Type" content="text/html charset=UTF-8;">';



    foreach my $key (@{$params->{CSS}}){
        print '<link href="'.$key.'" rel="stylesheet" type="text/css" />';
    }

    foreach my $key (@{$params->{JS}}){
        print '<script type="text/javascript" src="'.$key.'"></script>';
    }

    print '<title>'.$params->{TITLE}.'</title>
    		</head>

    <body>';

}

sub Footer{
    print '</body></html>';
}

sub Layout{
    my $this = shift;
    my $data = shift;

    #        print Dumper $data;

    my $user_id = (keys %{$data->{USER_DETAILS}})[0];
    my $user_name = $data->{USER_DETAILS}->{$user_id}->{name};

    print '

<link href="/escaperim/css/index_main.css" rel="stylesheet">

<div class="navbar-wrapper" style="margin-bottom= 10px;">
    <div class="container-fluid">
        <nav class="navbar navbar-fixed-top">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="#">Escaperim</a>
                </div>
                <div id="navbar" class="navbar-collapse collapse">
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="/escaperim/Index/Display" class="">Home</a></li>
                        <li><a href="/escaperim/User/Rooms">My Rooms</a></li>
                        <li class=" dropdown">
                            <a href="#" class="dropdown-toggle " data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Rooms<span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li class=" dropdown">
                                    <a href="/escaperim/Room/Display">View Rooms</a>
                                </li>
                                <li><a href="/escaperim/Room/Add">Add New Room</a></li>
                            </ul>
                        </li>
                        <li class=" dropdown"><a href="#" class="dropdown-toggle " data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Friends <span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="/escaperim/Friend/Display">View Friends</a></li>
                                <li><a href="/escaperim/Friend/Add">Add New Friend</a></li>
                            </ul>
                        </li>
                        <li><a href="/escaperim/Compare/Prepare">Compare</a></li>
                        <li><a href="/escaperim/Contact/Form">Contact Me :)</a></li>
                    </ul>
                    <ul class="nav navbar-nav pull-right">
                        <li class=" dropdown"><a href="/escaperim/Login/Profile" class="dropdown-toggle active" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Signed in as '.$user_name.'</a>
                        <li class=""><a href="/escaperim/Login/Logout">Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    </div>
</div>
';
}

sub PrintError{
    my $this = shift;
    my $msg = shift;

    print "Error:: ".$msg;
}

1;

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

sub PrintError{
    my $this = shift;
    my $msg = shift;

    print "Error:: ".$msg;
}

1;

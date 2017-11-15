#!/usr/bin/perl

=pod
	Author: Tal Mishaan
			Centerity R&D Nov 14, 2017
=cut

use lib './lib/';
use strict;
use warnings;
use CGI qw(:standard);
use Data::Dumper;
use Controller::Controller;

sub main{
    my $cgi = new CGI();

    my %vars = $cgi->Vars();
    $vars{CGI} = $cgi;

    my $EI = new Controller({%vars});

    $EI->Run();
}

main();

#!/usr/bin/perl
use strict;
use warnings;
use base qw/CGI::Application/;
use CGI::Application::Plugin::Routes;

my $object = new Routes();

setup($object);

sub setup {
    my $self = shift;

    # routes_root optionally is used to prepend a URI part to every route
    $self->routes_root('/thismod');
    $self->routes([
        '' => 'home' ,
        '/view/:name/:id/:email'  => 'view',
    ]);

    $self->start_mode('show');

    $self->tmpl_path('templates/');
}

sub view {
    my $self  = shift;
    my $q     = $self->query();
    my $name  = $q->param('name');
    my $id    = $q->param('id');
    my $email = $q->param('email');
    my $debug = $self->routes_dbg; #dumps all the C::A::P::Routes info
    my $params = $self->routes_params; #shows params found.
    return $self->dump_html();
}


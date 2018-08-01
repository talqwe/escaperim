package Company;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Model::Generic;
use Model::Bank;
use Moose::Role;

with 'Generic';

=pod

id
name

=cut

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {
        CGI     => undef,
        DBC     => undef,
        TABLE   => 'company',
        UNIQUE  => {
            id            => 1,
            name          => 1,
        },

        ORDER   => [
            'id',
            'name',
        ],

        vars    => {
            id              => 0,
            name            => '',
        },

    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    map {$this->{vars}->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %{$this->{vars}};
    bless $this;

    $this->{BANK} = new Bank({ CGI => $this->{CGI}, DBC => $this->{DBC}, ID => $this->{ID} }, __PACKAGE__);

    return $this;
}

sub GetFromName{
    my $this = shift;
    my $name = shift;

    foreach my $c_id (keys %{$this->{BANK}->{Company}}){
        if($this->{BANK}->{Company}->{$c_id}->{name} eq $name){
            return $c_id;
        }
    }

    return 0;
}

sub InsertNewCompany{
    my $this = shift;
    my $name = shift;

    $this->{vars}->{name} = $name;
    return $this->Create();
}

sub GetOrInsertFromName{
    my $this = shift;
    my $name = shift;

    my $id = $this->GetFromName($name);

    return ($id)?($id):($this->InsertNewCompany($name));
}


1;
package Generic;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Moose::Role;

sub new{
    my $class = shift;
    die "This is an abstract class (".__PACKAGE__.":".__LINE__.")!";
}

sub Display{
    my $this = shift;
    my $view_data = {};

    foreach my $unique (keys %{$this->{BANK}->{ucfirst($this->{TABLE})}}){
        $view_data->{$unique} = [];
        foreach my $p (@{$this->{ORDER}}){
            push @{$view_data->{$unique}}, {$p => $this->{BANK}->{ucfirst($this->{TABLE})}->{$unique}->{$p}};
        }
    }

    return $view_data;
}

sub Create{
    my $this = shift;

    print "Create";

    foreach my $object (keys %{$this->{BANK}->{ucfirst($this->{TABLE})}}){
        foreach my $u (keys %{$this->{UNIQUE}}){
                return if ($this->{BANK}->{ucfirst($this->{TABLE})}->{$object}->{$u} eq $this->{vars}->{$u});
            }
    }

    $this->{DBC}->InsertLine({
        TABLE   => $this->{TABLE},
        COLUMN  => [ sort { if($a ne 'id' && $b ne 'id') { $a cmp $b } } grep { defined $this->{vars}->{$_} } keys %{$this->{vars}} ],
        VALUE   => [ map{ if($_ ne 'id') { $this->{vars}->{$_} } } sort { $a cmp $b } grep { defined $this->{vars}->{$_} } keys %{$this->{vars}} ],
    });
}

sub Remove{
    my $this = shift;

    $this->{DBC}->DeleteByID({
        TABLE   => $this->{TABLE},
        COLUMN  => 'id',
        VALUE   => $this->{vars}->{id},
    });
}

1;
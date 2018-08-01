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
    my $BANK_HEAD = shift || $this->{HEADER} || 0;
    my $view_data = {};

    my $pointer = $this->{BANK}->{ucfirst($this->{TABLE})};
    $pointer = $pointer->{$BANK_HEAD} if($BANK_HEAD && exists $pointer->{$BANK_HEAD});

    foreach my $unique (keys %{$pointer}){
        $view_data->{$unique} = [];
        foreach my $p (@{$this->{ORDER}}){
            push @{$view_data->{$unique}}, {$p => $pointer->{$unique}->{$p}};
        }
    }

    return $view_data;
}

sub Create{
    my $this = shift;
    my $BANK_HEAD = shift || $this->{HEADER} || 0;

    my $module = $this->{TABLE}."View";


    my $pointer = $this->{BANK}->{ucfirst($this->{TABLE})};
    $pointer = $pointer->{$BANK_HEAD} if($BANK_HEAD && exists $pointer->{$BANK_HEAD});

    foreach my $object (keys %{$pointer}){
        foreach my $u (keys %{$this->{UNIQUE}}){
            if($pointer->{$object}->{$u} && $this->{vars}->{$u} && $pointer->{$object}->{$u} eq $this->{vars}->{$u}){
                return {
                    ERROR       => ucfirst($u)." is already in use!",
                    NEW_ACTION  => 'Add',
                };
#                $module->Add({ ERROR => ucfirst($u)." is already in use!" });
#                return;
            }
        }
    }

    my @values = map{ if($_ ne 'id') { $this->{vars}->{$_} } } sort { $a cmp $b } grep { defined $this->{vars}->{$_} } keys %{$this->{vars}};
    push @values, time();
    my @columns = sort { if($a ne 'id' && $b ne 'id') { $a cmp $b } } grep { defined $this->{vars}->{$_} } keys %{$this->{vars}};
    push @columns, 'created_time';

    return $this->{DBC}->InsertLine({
        TABLE   => lc($this->{TABLE}),
        COLUMN  => \@columns,
        VALUE   => \@values,
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
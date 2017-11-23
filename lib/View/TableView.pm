package TableView;

use strict;
use warnings;

sub PrintTable{
    my $hash = shift; # { unique_p => { unique_p => val, p2 => val } }

    print '<table class="table">';
    print '<tr>';

    my $first_key = (keys %{$hash})[0];

    foreach my $object (@{$hash->{$first_key}}){
        print '<th>'.(keys %$object)[0].'</th>';
    }

    print '</tr>';

    foreach my $unique_p (keys %{$hash}){
        print '<tr>';

        foreach my $object (@{$hash->{$unique_p}}){
            print '<td>' . ($object->{(keys %$object)[0]} || '') . '</td>';
        }

        print '</tr>';
    }
}

1;
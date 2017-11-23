package Bank;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Moose::Role;

sub new{
    my $class = shift;
    my $USER_CONF = shift || {};
    my $bank_name = shift || 0;

    my $this = {
        CGI     => undef,
        DBC     => undef,
    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    bless $this;

    $this->TableToFunc();
    $this->{$bank_name} = $this->{GET_BANK}->{$bank_name}->() if($bank_name);

    return $this;
}

sub TableToFunc{
    my $this = shift;

    $this->{GET_BANK} = {
      'Users'       => sub { $this->GetData('users'); },
      'Rooms'       => sub { $this->GetData('rooms'); },
    };
}

sub GetData{
    my $this = shift;
    my $table = shift;
    return $this->{DBC}->GetDBData("select * from ".$table);
}


1;
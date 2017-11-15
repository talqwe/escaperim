package User;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Model::User;

=pod

id
name
email
password
facebook_url
comments

=cut

use constant MODEL_TABLE => 'users';

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {
        CGI     => undef,
        DBC     => undef,

        vars    => {
            id              => 0,
            name            => '',
            email           => '',
            password        => undef,
            facebook_url    => '',
            comments        => '',
        },

    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this->{vars};
    bless $this;

    return $this;
}

sub Display{
    print "tal";
}

sub Create{
    my $this = shift;

    $this->{DBC}->InsertLine({
        TABLE   => MODEL_TABLE,
        COLUMN  => [ sort { $a <=> $b } keys %{$this->{vars}} ],
        VALUE   => [ map{ $this->{vars}->{$_} } sort { $a <=> $b } keys %{$this->{vars}} ],
    });
}

sub Remove{
    my $this = shift;

    $this->{DBC}->DeleteByID({
        TABLE   => MODEL_TABLE,
        COLUMN  => 'id',
        VALUE   => $this->{id},
    });
}

sub ChangePassword{
    my $this = shift;

    $this->{DBC}->UpdateLine({
        TABLE   => MODEL_TABLE,
        COLUMN  => 'password',
        VALUE   => $this->{password},
    });
}



1;
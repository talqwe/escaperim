package Login;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:standard);
use Model::Generic;
use Model::Bank;
use Moose::Role;
use Digest::SHA qw(sha256_hex);
use CGI::Cookie;

with 'Generic';

=pod

=cut

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {
        CGI      => undef,
        DBC      => undef,
        TOKEN    => undef,
        TABLE    => 'user',
        vars     => {
            password => undef,
            username => undef,
        },
    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    map {$this->{vars}->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %{$this->{vars}};
    bless $this;

    $this->{BANK} = new Bank({ CGI => $this->{CGI}, DBC => $this->{DBC} });

    return $this;
}

sub Enter{
    my $this = shift;

    my $user_object = $this->{BANK}->GetUserLogin($this->{vars}->{username}, $this->{vars}->{password});
    my $token = $this->GetCookieToken($user_object->{id}, $user_object->{name}, $user_object->{email});
    $this->{TOKEN} = $token;
    $this->CreateCookie($token);
    $this->UpdateLogin($user_object->{id}, $token);

    return {TOKEN => $token};
}

sub Logout{
    my $this = shift;
    $this->RemoveCookie('token');
}

sub Profile{
    my $this = shift;
}

sub UpdateLogin{
    my $this = shift;
    my $user_id = shift;
    my $token = shift;

    $this->{DBC}->InsertDBData("update user set last_login_time = ".time().", token = ? where id = ?", [ $token, $user_id ]);

}

sub GetCookieToken{
    my $this = shift;
    my $id = shift;
    my $name = shift;
    my $email = shift;

    my $token_string = ($id.$name.$email."".time());
    my $data = $this->{DBC}->GetDBData("SELECT sha1(?) as token", 'token', undef, [$token_string]);
    my $token = (keys %$data)[0];

    return $token;
}

sub CreateCookie{
    my $this = shift;
    my $token = shift;

    my $cookie = $this->{CGI}->cookie(-name => 'token',
        -value                              => $token,
        -expires                            => time()+60*60*24);

    # Set the cookie.
    print "Set-Cookie: $cookie\n";
}

sub RemoveCookie{
    my $this = shift;
    my $cookie_name = shift;

    my $c = $this->{CGI}->cookie(-name=>$cookie_name, -value=>0, -expires=>"-1M");
    print $this->{CGI}->header(-cookie=>[ $c ]);
}

sub CheckLogin{
    my $this = shift;
    my $token = shift;

    return 1 if(scalar keys %{GetUserDetails($this, $token)} == 1);
    return 0;
}

sub GetUserIDFromToken{
    my $this = shift;
    my $token = shift || 0;

    my $data = GetUserDetails($this, $token);

    return (keys %$data)[0];
}

sub GetUserDetails{
    my $this = shift;
    my $token = shift;

    my $cookie_token = $token || $this->{TOKEN} || GetLoginToken();
    my $user_object = Bank::GetUserByToken($this, $cookie_token);

    return $user_object;
}

sub GetLoginToken{
    my %cookies = fetch CGI::Cookie;
    return ($cookies{'token'})?($cookies{'token'}->value):(undef);
}

1;
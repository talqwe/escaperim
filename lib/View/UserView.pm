package UserView;

use strict;
use warnings;
use Data::Dumper;
use View::TableView;

sub new{

    my $class = shift;
    my $USER_CONF = shift || {};

    my $this = {

    };

    map {$this->{$_} = ($USER_CONF->{$_})?($USER_CONF->{$_}):($this->{$_});} keys %$this;
    bless $this;
    return $this;
}

sub Display{
    my $this = shift;
    my $data = shift;

#    print Dumper $data;

    TableView::PrintTable($data);
}

sub Rooms{
    my $this = shift;
    my $data = shift;

    #    print Dumper $data;

    TableView::PrintTable($data);
}

sub Add{
    my $this = shift;
    my $PARAM = shift || "";

    print '
<div class="container">
	<div class="row main">
		<div class="panel-heading">
           <div class="panel-title text-center">
           		<h1 class="title">Create User</h1>
           		<hr />
           	</div>
        </div>
        <div class="panel-heading">
           <div class="text-center">
           		<h5 class="title">'.($PARAM->{ERROR}||"").'</h5>
           	</div>
        </div>
		<div class="main-login main-center">
			<form class="form-horizontal" method="post" action="../../index.cgi/User/Create">

				<div class="form-group">
					<label for="name" class="cols-sm-2 control-label">Your Name</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-user fa" aria-hidden="true"></i></span>
							<input type="text" class="form-control" name="name" id="name"  placeholder="Enter your Name"/>
						</div>
					</div>
				</div>

				<div class="form-group">
					<label for="email" class="cols-sm-2 control-label">Your Email</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-envelope fa" aria-hidden="true"></i></span>
							<input type="text" class="form-control" name="email" id="email"  placeholder="Enter your Email"/>
						</div>
					</div>
				</div>

				<div class="form-group">
					<label for="username" class="cols-sm-2 control-label">Facebook URL</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-users fa" aria-hidden="true"></i></span>
							<input type="text" class="form-control" name="facebook_url" id="facebook_url"  placeholder="Enter your facebook URL"/>
						</div>
					</div>
				</div>

				<div class="form-group">
					<label for="password" class="cols-sm-2 control-label">Password</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-lock fa-lg" aria-hidden="true"></i></span>
							<input type="password" class="form-control" name="password" id="password"  placeholder="Enter your Password"/>
						</div>
					</div>
				</div>

				<div class="form-group ">
					<input type="submit" value="Register" class="btn btn-primary btn-lg btn-block login-button">
				</div>
				<div class="login-register text-center">
		            <a href="../../index.cgi/Login/Display">Login</a>
		        </div>
			</form>
		</div>
	</div>
</div>
';
}

sub Create{

}

1;
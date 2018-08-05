package FriendView;

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

sub Add{
    my $this = shift;
    my $PARAM = shift;

    print '
<div class="container container-content">
	<div class="row main">
		<div class="panel-heading">
           <div class="panel-title text-center">
           		<h1 class="title">Find a Friend! :D</h1>
           		<hr />
           	</div>
        </div>
        <div class="panel-heading">
           <div class="text-center">
           		<h5 class="title">'.($PARAM->{ERROR}||"").'</h5>
           	</div>
        </div>
		<div class="main-login main-center">
			<form class="form-horizontal" method="post" action="/escaperim/Friend/Search" autocomplete="off">

				<div class="form-group">
					<label for="search_friend" class="cols-sm-2 control-label">Some string to search by...</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-user fa" aria-hidden="true"></i></span>
							<input type="text" class="form-control" name="search_friend" id="search_friend" placeholder="Full name, email or facebook url"/>
						</div>
					</div>
				</div>

				<div class="form-group ">
					<input type="submit" value="Search!" class="btn btn-primary btn-lg btn-block login-button">
				</div>
			</form>
		</div>
	</div>
</div>
';
}

sub Create{

}

sub Display{
    my $this = shift;
    my $data = shift;

    #    print Dumper $data;

    TableView::PrintTable($data);
}

sub Search{
    my $this = shift;
    my $PARAM = shift;

    my $msg = "";

    if($PARAM->{ERROR}){
        $msg = "Invitation to ".$PARAM->{FRIEND_NAME}." was sent!";
    }else{
        $msg = "Invitation to '".$PARAM->{FRIEND_NAME}."' was sent!";
    }


    print '
<div class="container container-content">
	<div class="row main">
		<div class="panel-heading">
           <div class="panel-title text-center">
           		<h3 class="title">'.$msg.'</h3>
           		<hr />
           	</div>
        </div>
    </div>
</div>
';



}

1;
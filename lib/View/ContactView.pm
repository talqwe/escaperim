package ContactView;

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

sub Form{
    my $this = shift;
    my $PARAM = shift;

    print '
<div class="container container-content">
	<div class="row main">
		<div class="panel-heading">
           <div class="panel-title text-center">
           		<h1 class="title">Contact Me :)</h1>
           		<hr />
           	</div>
        </div>
        <div class="panel-heading">
           <div class="text-center">
           		<h5 class="title">'.($PARAM->{ERROR}||"").'</h5>
           	</div>
        </div>
		<div class="main-login main-center">
			<form class="form-horizontal" method="post" action="/escaperim/Contact/Create" autocomplete="off">

				<div class="form-group">
					<label for="subject" class="cols-sm-2 control-label">Subject</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-user fa" aria-hidden="true"></i></span>
							<input type="text" class="form-control" name="subject" id="subject" placeholder="Enter subject..."/>
						</div>
					</div>
				</div>

				<div class="form-group">
					<label for="content" class="cols-sm-2 control-label">Content</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-envelope fa" aria-hidden="true"></i></span>
							<textarea type="text" rows="8" class="form-control" name="content" id="content" placeholder="Enter content..."/></textarea>
						</div>
					</div>
				</div>

				<div class="form-group ">
					<input type="submit" value="Create" class="btn btn-primary btn-lg btn-block login-button">
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

}

1;
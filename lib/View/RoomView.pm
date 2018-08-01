package RoomView;

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

sub Add{
    my $this = shift;
    my $PARAM = shift;

    print '
<div class="container">
	<div class="row main">
		<div class="panel-heading">
           <div class="panel-title text-center">
           		<h1 class="title">Create Room</h1>
           		<hr />
           	</div>
        </div>
        <div class="panel-heading">
           <div class="text-center">
           		<h5 class="title">'.($PARAM->{ERROR}||"").'</h5>
           	</div>
        </div>
		<div class="main-login main-center">
			<form class="form-horizontal" method="post" action="../../index.cgi/Room/Create">

				<div class="form-group">
					<label for="name" class="cols-sm-2 control-label">Room English Name</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-user fa" aria-hidden="true"></i></span>
							<input type="text" class="form-control" name="name" id="name" placeholder="Enter room english name..."/>
						</div>
					</div>
				</div>

				<div class="form-group">
					<label for="hebrew_name" class="cols-sm-2 control-label">Room Hebrew Name</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-envelope fa" aria-hidden="true"></i></span>
							<input type="text" class="form-control" name="hebrew_name" id="hebrew_name" placeholder="Enter room hebrew name..."/>
						</div>
					</div>
				</div>

				<div class="form-group">
					<label for="company" class="cols-sm-2 control-label">Company Name</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-lock fa-lg" aria-hidden="true"></i></span>
							<input type="text" class="form-control" name="company" id="company" placeholder="Enter company name..."/>
						</div>
					</div>
				</div>

				<div class="form-group">
					<label for="city_id" class="cols-sm-2 control-label">City</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-lock fa-lg" aria-hidden="true"></i></span>
							<select name="city_id" class="form-control" id="city_id">';

    foreach my $city_id (keys %{$PARAM->{CITIES}}){
        print '<option value="'.$city_id.'">'.$PARAM->{CITIES}->{$city_id}->{name}.'</option>';
    }


print '
                            </select>
						</div>
					</div>
				</div>

				<div class="form-group">
					<label for="url" class="cols-sm-2 control-label">Room Page URL</label>
					<div class="cols-sm-10">
						<div class="input-group">
							<span class="input-group-addon"><i class="fa fa-lock fa-lg" aria-hidden="true"></i></span>
							<input type="text" class="form-control" name="url" id="url" placeholder="Enter room\'s page url..."/>
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

1;
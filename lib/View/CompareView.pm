package CompareView;

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

sub Users{
    my $this = shift;
    my $data = shift;

        print '<pre>'.(Dumper $data).'</pre>';

#    TableView::PrintTable($data);
}

sub Prepare{
    my $this = shift;
    my $PARAM = shift;

    print '
<div class="container container-content">
	<div class="row main">
		<div class="panel-heading">
           <div class="panel-title text-center">
           		<h1 class="title">Compare With Friends! :D</h1>
           		<hr />
           	</div>
        </div>
        <div class="panel-heading">
           <div class="text-center">
           		<h5 class="title">'.($PARAM->{ERROR}||"").'</h5>
           	</div>
        </div>
		<div class="main-login main-center">
			<form class="form-horizontal" method="post" action="/escaperim/Compare/Users" autocomplete="off">

				';
    print '<input type="hidden" value="'.$PARAM->{MY_ID}.'" name="id">';

    foreach my $friend (keys %{$PARAM->{FRIENDS}}){
        print '<div class="radio"><label><input name="id" type="radio" value="'.$PARAM->{FRIENDS}->{$friend}->{friend_id}.'">'.$PARAM->{FRIENDS}->{$friend}->{friend}.'</label></div>';
    }

    print'
				<div class="form-group ">
					<input type="submit" value="Compare!" class="btn btn-primary btn-lg btn-block login-button">
				</div>
			</form>
		</div>
	</div>
</div>
';

}

1;
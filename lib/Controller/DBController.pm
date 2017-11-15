package DBController;

use Data::Dumper;
use DBI;

use warnings;
use strict;

my $connector = sub {


        my $user     = shift;
        my $pass     = shift;
        my $database = shift;

        $user       = 'root' unless $user;
        $pass       = 'Rock5roll' unless $pass;
        $database   = 'escaprim' unless $database;

        my $db = DBI->connect( "DBI:mysql:$database", $user, $pass, { mysql_enable_utf8 => 1 }) or die "can't connect ==> $!";
        return $db;
        
           


};



############# PRIVATE ######################

sub new{
	
	my $class = shift;
	my $user = shift ||0;
	my $pass = shift ||0;
	my $database = shift ||0;
	
	my $this = {
	 DB                      => $connector->($user,$pass,$database),
	 STH                     => undef,
	};
	bless $this;
	return $this;

	
}

sub DESTROY{
	
	my $this = shift;
	$this->{DB}->disconnect() if($this->{DB});
	
}

sub DumpData{
	
	
	
	my $this = shift;
	my $data =shift;
	print "\n==========================\n";
	print Dumper($data);
	print "\n==========================\n";
	
}


sub SecureValues{
	
	my $this = shift;
	my $PARAM = shift || {};
	
	
}

sub SecureValues2{
 
#    DAAAA::SecureValues("ss",[]);
	
	my $this = shift;
	my $varRef = shift || {};
	
#	my $KEYWORDS = [ "create", "show" ,  "describe" , "drop", "OUTFILE", 
#	                 "delete", "SELECT", "grant" , "INSERT","alter","JOIN",
#	                 "TRUNCATE", "union", "update", "REVOKE", "FETCH","INNER" ];
	                 
	                 
	my $KEYWORDS = [ '"', "'", ";", '%', '=','\n' ,'(ASCII 0)','\r'  ];
	                 

	
#	foreach my $v(@{$arrayRef}){
#	 	 
#	  foreach my $key (@{$KEYWORDS}){
#	      
##	    sub { die("Exit: Assumed SQL Injection [$v]") }->() if($v =~/$key/i);
#            
#	       $v =~s///g
#	   	   
#	  }
#	  
#	}
	
	foreach my $v(keys %$varRef){
	    next if $v eq 'action';
	    foreach my $key (@{$KEYWORDS}){
	       
	       if($varRef->{$v} =~/$key/i){
	           
#	          print '<p> A'.$varRef->{$v}.'</p>';
	          $varRef->{$v} =~ s/$key/\\$key/g ;
#	          print '<p> F'.$varRef->{$v}.'</p>';
	             
	       }
	        
	    }

	}
	
	return $varRef;
	
}


sub SecureStatement{
	
	my $this = shift;
	my $sqlquery = shift;
	
	my @IN = $sqlquery=~m/\s+in\s*(\(\s*.*\s*\))\s*/g;
	
	$this->DumpData(\@IN);
	
	
	
	
}

############### GET ########################

#=================================
#  Adatpet for Yossi MyDB.pm
#=================================

sub getData{
	
	my $this     = shift;
	my $sqlquery = shift || 0;
	return $this->GetDBData($sqlquery , 'id' , 'ARRAY');
}

sub GetDBData{
    
    my $this = shift;
    
    my $sqlquery = shift;
    my $fetch_by = shift;
    my $type = shift || "";
    my $secureArray = shift || [];
    
    return unless $sqlquery;
   
#    $sqlquery = $this->SecureStatement($sqlquery);
    if(ref($secureArray) eq 'ARRAY'){
       my $total_args = grep{$_ eq "?"} split(//,$sqlquery);
       
       if($total_args != scalar @{$secureArray}){
         warn "prepared statement: number of argument not match in query\n";
         warn "$sqlquery => (",join(",",@{$secureArray}).")";
         
         
      }
     
    }
   
#    $this->DumpData($secureArray);
    $this->{STH} = $this->{DB}->prepare($sqlquery) || sub{ warn("WRONG QUERY: $sqlquery");  die($!)}->();
    $this->{STH}->execute(@{$secureArray}) || sub{ warn("\n CDBM::WRONG QUERY: $sqlquery\n");  die($!)}->();
    
#    print $this->{DB}->{Statement};
#    print $this->{STH}->{Statement};
    
#   unless($this->{STH}->rows)
#   {
#       my @cols = @{$this->{STH}->{NAME_lc}}; # or NAME if needed
#       my %empty =  map {$_ => ""} @cols ;
#       return \%empty;
#   }
    my $temp = 0 ;
    if(uc($type) eq 'ARRAY')
    {
      $temp = $this->{STH}->fetchall_arrayref({});
    }else{
      
      $fetch_by = 'id' unless $fetch_by;
      $temp = $this->{STH}->fetchall_hashref($fetch_by);
    
    }
    
    $this->{STH}->finish();
    return $temp;
    
}

sub GetDBDataArray{
	
	my $this = shift;
	my $sqlquery = shift;
	my $secureArray = shift || [];
	
	return unless $sqlquery;
	
	if(ref($secureArray) eq 'ARRAY'){
       my $total_args = grep{$_ eq "?"} split(//,$sqlquery);
       
       if($total_args != scalar @{$secureArray}){
         warn "prepared statement: number of argument not match in query\n";
         warn "$sqlquery => (",join(",",@{$secureArray}).")";
         
      }
     
    }
	
	$this->{STH} = $this->{DB}->prepare($sqlquery) || sub{ warn("WRONG QUERY: $sqlquery");  die($!)}->();
	$this->{STH}->execute(@{$secureArray})|| sub{ warn("WRONG QUERY: $sqlquery");  die($!)}->();

	my $temp = $this->{STH}->fetchall_arrayref();
	$this->{STH}->finish();
	return $temp;
	
}

sub GetExecDBHandler{
 
  my $this = shift;
  my $sqlquery = shift;
  return 0 unless $sqlquery;
  
  my $secureArray = shift || [];
  
  if(ref($secureArray) eq 'ARRAY'){
       my $total_args = grep{$_ eq "?"} split(//,$sqlquery);
       
       if($total_args != scalar @{$secureArray}){
         warn "prepared statement: number of argument not match in query\n";
         warn "$sqlquery => (",join(",",@{$secureArray}).")";
      }
    }
  
#  while(my $tmp = $d->fetchrow_hashref()){
  
  $this->{STH} = $this->{DB}->prepare($sqlquery) || sub{ warn("WRONG QUERY: $sqlquery");  die($!)}->();
  $this->{STH}->execute(@{$secureArray})|| sub{ warn("WRONG QUERY: $sqlquery");  die($!)}->();
  return  $this->{STH};
  
  
 
}

sub IsTableExists{
	my $this = shift;
	my $table_names = shift || return;
	my $db_tables = {};
	
	$this->{STH} = $this->{DB}->prepare("show tables");
    $this->{STH}->execute();	
	my $data = $this->{STH}->fetchall_arrayref();

	map {$db_tables->{$_->[0]} = 1} @$data;

	unless(ref($table_names) eq "ARRAY"){ $table_names = [$table_names]; }
	
	foreach my $table (@$table_names){
		unless($db_tables->{$table}){
			return 0;
		}
	}
	
	return 1;
}

sub IsDatabaseExists{
	my $this = shift;
	my $db_names = shift || return;
	my $db_tables = {};
	
	$this->{STH} = $this->{DB}->prepare("show databases");
    $this->{STH}->execute();	
	my $data = $this->{STH}->fetchall_arrayref();

	map {$db_tables->{$_->[0]} = 1} @$data;

	unless(ref($db_names) eq "ARRAY"){ $db_names = [$db_names]; }
	
	foreach my $table (@$db_names){
		unless($db_tables->{$table}){
			return 0;
		}
	}
	
	return 1;
}

############### SET ########################

sub InsertDBData{
 
 	my $this = shift;
	my $sqlquery = shift;
	my $secureArray = shift;
	my $insertid = 0;
	
	return unless $sqlquery;
	
	if(ref($secureArray) eq 'ARRAY'){
       my $total_args = grep{$_ eq "?"} split(//,$sqlquery);
       
       if($total_args != scalar @{$secureArray}){
         warn "prepared statement: number of argument not match in query\n";
         warn "$sqlquery => (",join(",",@{$secureArray}).")";
                 
      }
     
    }
	
	$this->{STH} = $this->{DB}->prepare($sqlquery) || sub{ warn("WRONG QUERY: $sqlquery");  die($!)}->();
	$this->{STH}->execute(@{$secureArray}) || sub{ warn("WRONG QUERY: $sqlquery");  die($!)}->();
	$insertid = $this->{STH}->{mysql_insertid};
	$this->{STH}->finish();
	return $insertid; 
 
}

############### READY ######################

sub DeleteByID{
    my $this = shift;
    my $PARAM = shift || {};

    return warn "__LINE__: __PACKAGE__ Table(".$this->{TABLE}.")|Column(".$this->{COLUMN}.")|Value(".$this->{VALUE}.")" if(!defined $PARAM->{TABLE} || !defined $PARAM->{COLUMN} || !defined $PARAM->{VALUE}});
    $this->InsertDBData("delete from ".$PARAM->{TABLE}." where ".$PARAM->{COLUMN}." = ?", [ $PARAM->{VALUE} ]);
}

sub InsertLine{
    my $this = shift;
    my $PARAM = shift || {};

    return warn "__LINE__: __PACKAGE__ Table(".$this->{TABLE}.")|Column(".$this->{COLUMN}.")|Value(".$this->{VALUE}.")" if(!defined $PARAM->{TABLE} || scalar @$PARAM->{COLUMN} == 0 || scalar @$PARAM->{VALUE} =! scalar @$PARAM->{COLUMN});

    $this->InsertDBData("insert into ".$PARAM->{TABLE}."(".join(',', @{$this->{COLUMN}}).") values(".join(',', map{ "?" } @{$this->{COLUMN}}).")", $this->{VALUE})
}

sub UpdateLine{
    my $this = shift;
    my $PARAM = shift || {};

    return warn "__LINE__: __PACKAGE__ Table(".$this->{TABLE}.")|Column(".$this->{COLUMN}.")|Value(".$this->{VALUE}.")" if(!defined $PARAM->{TABLE} || scalar @$PARAM->{COLUMN} == 0 || scalar @$PARAM->{VALUE} =! scalar @$PARAM->{COLUMN});

    $this->InsertDBData("update ".$PARAM->{TABLE}." set ".join(',', map{ $_."=?" } @{$this->{COLUMN}}).")", $this->{VALUE})
}


1;

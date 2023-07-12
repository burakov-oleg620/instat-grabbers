package work_mysql_agregator2;
use strict;
use warnings;
use MD5;
use url_to_file;
use work_mysql;
use Encode qw (encode decode);
use Data::Dumper;

sub new {
	my $class = shift;
	
	my $mysql_dbdriver = shift; 
	my $mysql_host = shift; 
	my $mysql_port = shift; 
	my $mysql_user = shift;  
	my $mysql_user_password = shift; 
	my $mysql_base = shift; 
	my $mysql_table = shift;
	
	my $work_mysql = work_mysql -> new (
		$mysql_dbdriver,
		$mysql_host,
		$mysql_port,
		$mysql_user,
		$mysql_user_password,
		$mysql_base
	); 	

	my $sql = 'SET NAMES UTF8';
	$work_mysql -> run_query ($sql) or die (print $!);
	
	my $self = {};
	$self -> {work_mysql} = $work_mysql;
	$self -> {table} = $mysql_table;

	return bless $self; 
}

sub create {
	my $self = shift;
	
	my $sql  = '
	create table if not exists '. $self -> {table}.' (
		`hash` char (32) PRIMARY KEY,
		`date` text, 
		`count_url_pass` text, 
		`count_url_fail` text, 
		`count_url_new` text, 
		`count_grab_matches` text, 
		`count_xml` text, 
		`id_xml` text, 
		`count_pars_matches` text, 
		`id_pars_matches` text, 
		`count_matches_where_not_players` text, 
		`json` text, 
		`time` int(11)
	) ENGINE=InnoDB  DEFAULT CHARSET=utf8;'; 
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
}


sub drop  {
	my $self = shift;
	my $sql = 'drop table if exists '.$self->{table}; 		
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
}

sub insert {
	my $self = shift;
	my $table = $self -> {table};
	my $insert = shift;
	
	my $sql = 'insert into '.$table.' (
		`hash`, 
		`date`,
		`count_url_pass`,
		`count_url_fail`,
		`count_url_new`,
		`count_grab_matches`,
		`count_xml`,
		`id_xml`,
		`count_pars_matches`,
		`id_pars_matches`,
		`count_matches_where_not_players`,
		`json`,
		`time`
	)	
	value (
		"'.quotemeta ($insert -> {hash}).'",
		"'.quotemeta ($insert -> {date}).'",
		"'.quotemeta ($insert -> {count_url_pass}).'",
		"'.quotemeta ($insert -> {count_url_fail}).'",
		"'.quotemeta ($insert -> {count_url_new}).'",
		
		"'.quotemeta ($insert -> {count_grab_matches}).'",
		"'.quotemeta ($insert -> {count_xml}).'",
		"'.quotemeta ($insert -> {id_xml}).'",
		
		"'.quotemeta ($insert -> {count_pars_matches}).'",
		"'.quotemeta ($insert -> {id_pars_matches}).'",
		"'.quotemeta ($insert -> {count_matches_where_not_players}).'",
		"'.quotemeta ($insert -> {json}).'",
		
		"'.quotemeta ($insert -> {time}).'"
	)'; 		
	
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
	return $sql;
}


sub update {
	my $self = shift;
	my $table = $self -> {table};
	my $insert = shift;
	my $sql = 'update '.$table.' set 
	`date` = "'.$insert -> {date}.'",
	`count_url_pass` = "'.$insert -> {count_url_pass}.'",
	`count_url_fail` = "'.$insert -> {count_url_fail}.'",
	`count_url_new` = "'.$insert -> {count_url_new}.'",
	`count_grab_matches` = "'.$insert -> {count_grab_matches}.'",
	`count_xml` = "'.$insert -> {count_xml}.'",
	`id_xml` = "'.$insert -> {id_xml}.'",
	`count_pars_matches` = "'.$insert -> {count_pars_matches}.'",
	`id_pars_matches` = "'.$insert -> {id_pars_matches}.'",
	`count_matches_where_not_players` = "'.$insert -> {count_matches_where_not_players}.'",
	`time` = "'.$insert -> {time}.'"
	
	where `hash` = "'.$insert -> {hash}.'"';
	
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
	return $sql;
	
}

sub select {
	my $self = shift;
	my $insert = shift;
	
	my $sql = 'select * from '.$self->{table}.' where `hash` = "'.$insert -> {hash}.'"'; 		
	$self -> {work_mysql} -> run_query ($sql);
	
	my $return = [];
	my @row = $self -> {work_mysql} -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			push (@$return, $_);
		}
	}
	return $return; 
}


sub select_all {
	my $self = shift;
	my $insert = shift;
	
	my $sql = 'select * from '.$self->{table}; 		
	$self -> {work_mysql} -> run_query ($sql);
	
	my $return = [];
	my @row = $self -> {work_mysql} -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			push (@$return, $_);
		}
	}
	return $return; 
}

sub  clear  {
	my $self = shift;
	my $clear_time = shift;
	
	my $time = time () - $clear_time * 24*3600;
	my $sql = 'select * from '.$self-> {table}.' where `time` BETWEEN "0" AND '.$time;
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
	
	my @row = $self -> {work_mysql} -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			my$sql = 'delete from '.$self->{table}.' where `hash` = "'.$_->{hash}.'"';
			$self -> {work_mysql} -> run_query ($sql) or die (print $!);
		}
	}
	return 1;

}		

1;

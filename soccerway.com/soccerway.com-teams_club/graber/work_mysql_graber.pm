package work_mysql_graber;
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

	my $self = {};
	$self -> {work_mysql} = $work_mysql;
	$self -> {table} = $mysql_table;

	return bless $self; 
}

sub insert_ignore {
	my $self = shift;
	
	my $method = shift;
	my $url = shift;
	my $referer = shift;
	my $type = shift;
	my $str_for_content = shift;
	
	my $md5 = MD5 -> new ();
	my $hash = $md5 -> hexhash ($url);
	$md5 = undef;
	
	# my $url_to_file = url_to_file -> new ($url); 
	# my $file = $url_to_file -> do ();
	# $url_to_file = undef;
	
	my $file = 'http_'.$hash .'.html';
	
	my $response = '';
	my $state = 'new';
	
	my $work_mysql = $self -> {work_mysql};
	my $table = $self -> {table};
	
	my $sql = 'insert ignore into '.$table.' (
		`hash`,
		`method`,
		`url`,
		`referer`,	
		`file`, 
		`state`,
		`type`,
		`str_for_content`
	)
	value (
		"'.$hash.'",
		"'.$method.'",
		"'.$url.'",
		"'.$referer.'",
		"'.$file.'",
		"'.$state.'",
		"'.$type.'",
		"'.$str_for_content.'"
	)'; 		
	
	$work_mysql -> run_query ($sql);
	return $sql;
}

sub insert_ignore_shift_file {
	my $self = shift;
	
	my $method = shift;
	my $url = shift;
	my $referer = shift;
	my $type = shift;
	my $str_for_content = shift;
	my $file = shift;
	
	my $md5 = MD5 -> new ();
	my $hash = $md5 -> hexhash ($url);
	$md5 = undef;
	
	
	my $response = '';
	my $state = 'new';
	
	my $work_mysql = $self -> {work_mysql};
	my $table = $self -> {table};
	
	my $sql = 'insert ignore into '.$table.' (
		`hash`,
		`method`,
		`url`,
		`referer`,	
		`file`, 
		`state`,
		`type`,
		`str_for_content`
	)
	value (
		"'.$hash.'",
		"'.$method.'",
		"'.$url.'",
		"'.$referer.'",
		"'.$file.'",
		"'.$state.'",
		"'.$type.'",
		"'.$str_for_content.'"
	)'; 		
	
	$work_mysql -> run_query ($sql);
	return $sql;
}



sub select_all_update_work {
	my $self = shift;
	my $limit = shift;
	
	my $work_mysql = $self -> {work_mysql};
	my $table = $self -> {table};
	my $state = 'new';
	
	my $sql = 'select * from '.$table.' where `state` = "'.$state.'" limit '.$limit; 		
	$work_mysql -> run_query ($sql);
	
	my $return = [];
	my @row = $work_mysql -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			my $sql = 'update '.$table.' set `state` = "work" where `hash` ="'.$_->{hash}.'"';
			$work_mysql -> run_query ($sql) or die (print $!);
			push (@$return, $_);
		}
	}
	return $return; 
}


sub update_set_pass {
	my $self = shift;
	my $url = shift;
	
	my $md5 = MD5 -> new ();
	my $hash = $md5 -> hexhash ($url);
	$md5 = undef;

	my $work_mysql = $self -> {work_mysql};
	my $table = $self -> {table};
	my $state = 'pass';
	
	my $sql = 'update '.$table.' set `state` = "'.$state.'" where `hash` = "'.$hash.'"';
	$work_mysql -> run_query ($sql);
	return $sql;
}

sub update_set_fail {
	my $self = shift;
	my $url = shift;
	
	my $md5 = MD5 -> new ();
	my $hash = $md5 -> hexhash ($url);
	$md5 = undef;
	
	my $work_mysql = $self -> {work_mysql};
	my $table = $self -> {table};
	my $state = 'fail';
	my $sql = 'update '.$table.' set state="'.$state.'" where `hash` = "'.$hash.'"';
	$work_mysql -> run_query ($sql);
	return $sql;
}

sub update_set_new {
	my $self = shift;
	my $url = shift;

	my $md5 = MD5 -> new ();
	my $hash = $md5 -> hexhash ($url);
	$md5 = undef;
	
	my $work_mysql = $self -> {work_mysql};
	my $table = $self -> {table};
	my $state = 'new';
	
	my $sql = 'update '.$table.' set state="'.$state.'" where `hash` = "'.$hash.'"';
	$work_mysql -> run_query ($sql);
	return $sql;
}


sub update_set_new_if_work {
	my $self = shift;

	my $work_mysql = $self -> {work_mysql};
	my $table = $self -> {table};
	my $state1 = 'new';
	my $state2 = 'work';
	my $sql = 'update '.$table.' set state= "'.$state1.'" where state="'.$state2.'"';
	$work_mysql -> run_query ($sql);
	return $sql;
}

sub free_sql {
	my $self = shift;	
	my $sql = shift;
	my $work_mysql = $self -> {work_mysql};
	my $table = $self -> {table};
	$work_mysql -> run_query ($sql);
	return $sql;
}

sub select_count {
	my $self = shift;	
	my $sql = shift;
	my $work_mysql = $self -> {work_mysql};
	my $table = $self -> {table};
	my $return  = $work_mysql -> run_query ($sql);
	my @row = $work_mysql -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			$return =  $_ -> {'COUNT(*)'};
		}
	}
	
	return $return;
}


sub update_set_str_for_content {
	
	my $self = shift;
	
	my $url = shift;
	my $str_for_content = shift;
	
	my $work_mysql = $self -> {work_mysql};
	my $table = $self -> {table};
	
	my $md5 = MD5 -> new ();
	my $hash = $md5 -> hexhash ($url);
	$md5 = undef;

		
	my $sql = 'update '.$table.' set `str_for_content` = "'.$str_for_content.'" where `hash` = "'.$hash.'"';
	$work_mysql -> run_query ($sql);
	
	return $sql;
}

1;

package work_mysql_agregator;
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
	# my $sql  = '
	# create table if not exists '. $self -> {table}.' (
		# `id` int(11) not null primary key auto_increment,
		# `name_eng` text,
		# `name_original` text,
		# `address` text, 
		# `country` text,
		# `email1` text,
		# `email2` text,
		# `email3` text,
		# `fax1` text,
		# `fax2` text,
		# `fax3` text,
		# `link1` text,
		# `link2` text,
		# `link3` text,
		# `phone1` text,
		# `phone2` text,
		# `phone3` text,
		# `tournament` text
		
	# ) ENGINE=InnoDB  DEFAULT CHARSET=UTF8;'; 
	# $self -> {work_mysql} -> run_query ($sql) or die (print $!);
	
	my $sql  = '
	create table if not exists '. $self -> {table}.' (
		`id` int(11) not null primary key,
		`name_eng` text,
		`name_original` text,
		`address` text, 
		`country` text,
		`email1` text,
		`email2` text,
		`email3` text,
		`fax1` text,
		`fax2` text,
		`fax3` text,
		`link1` text,
		`link2` text,
		`link3` text,
		`phone1` text,
		`phone2` text,
		`phone3` text,
		`tournament` text
		
	) ENGINE=InnoDB  DEFAULT CHARSET=UTF8;'; 
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
	
}


sub drop  {
	my $self = shift;
	my $sql = 'drop table if exists '.$self->{table}; 		
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
}

sub insert {
	my $self = shift;
	my $insert = shift;
	
	my $sql = 'insert into '.$self -> {table}.' (
		`id`,
		`name_eng`,
		`name_original`,
		`address`, 
		`country`,
		`email1`,
		`email2`,
		`email3`,
		`fax1`,
		`fax2`,
		`fax3`,
		`link1`,
		`link2`,
		`link3`,
		`phone1`,
		`phone2`,
		`phone3`,
		`tournament`
	)	
	value (
		"'.quotemeta ($insert -> {id}).'",
		"'.quotemeta ($insert -> {name_eng}).'",
		"'.quotemeta ($insert -> {name_original}).'",
		"'.quotemeta ($insert -> {address}).'",
		"'.quotemeta ($insert -> {country}).'",
		"'.quotemeta ($insert -> {email1}).'", 
		"'.quotemeta ($insert -> {email2}).'", 
		"'.quotemeta ($insert -> {email3}).'", 
		"'.quotemeta ($insert -> {fax1}).'", 
		"'.quotemeta ($insert -> {fax2}).'", 
		"'.quotemeta ($insert -> {fax3}).'", 
		"'.quotemeta ($insert -> {link1}).'", 
		"'.quotemeta ($insert -> {link2}).'", 
		"'.quotemeta ($insert -> {link3}).'", 
		"'.quotemeta ($insert -> {phone1}).'", 
		"'.quotemeta ($insert -> {phone2}).'", 
		"'.quotemeta ($insert -> {phone3}).'", 
		"'.quotemeta ($insert -> {tournament}).'" 
	)'; 		
	
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
	return $sql;
}

sub update {
	my $self = shift;
	my $insert = shift;
	
	my $sql =
	'UPDATE '.$self -> {table}.' SET '.
	# '`hash` = "'. quotemeta ($insert -> {hash}). '",'.
	'`id` = "' . quotemeta ($insert -> {id}). '",'.
	'`name` = "' . quotemeta ($insert -> {name}). '",'.
	'`name_url` = "' . quotemeta ($insert -> {name_url}). '",'.
	'`url` = "'. quotemeta ($insert -> {url}). '",'.
	'`bref` = "' . quotemeta ($insert -> {bref}). '",'.
	# '`description` = "'. quotemeta ($insert -> {description}). '",'.
	'`vidimost_na_vitrine` = "'. quotemeta ($insert -> {vidimost_na_vitrine}).'",'.
	'`meta_title` = "'. quotemeta ($insert -> {meta_title}).'",'.
	'`meta_keywords` = "' . quotemeta ($insert -> {meta_keywords}).'",'.
	'`meta_description` = "' . quotemeta ($insert -> {meta_description}).'",'.
	'`category` = "'. quotemeta ($insert -> {category}).'",'.
	'`pictures` = "' . quotemeta ($insert -> {pictures}).'",'.
	'`s_size` = "' . quotemeta ($insert -> {s_size}).'",'.
	'`s_color` = "' . quotemeta ($insert -> {s_color}).'",'.
	'`id_m` = "' . quotemeta ($insert -> {id_m}).'",'.
	'`artikul` = "' . quotemeta ($insert -> {artikul}).'",'.
	'`price_p` = "' . quotemeta ($insert -> {price_p}).'",'.
	'`price_s` = "' . quotemeta ($insert -> {price_s}).'",'.
	'`price_z` = "' . quotemeta ($insert -> {price_z}).'",'.
	'`ostatok` = "' . quotemeta ($insert -> {ostatok}).'",'.
	'`ves` = "'. quotemeta ($insert -> {ves}).'",'.
	'`p_size` = "'. quotemeta ($insert -> {p_size}).'",'.
	'`p_color` = "'. quotemeta ($insert -> {p_color}). '", '.
	'`publish` = "'. quotemeta ($insert -> {publish}). '" '.
	' WHERE `hash` = "'.$insert -> {hash}.'"';
	
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
	
	return $sql;
}

sub set_publish_0 {
	my $self = shift;
	my $insert = shift;

	my $sql = 'UPDATE '.$self -> {table}.' SET `publish` = "0"';
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

sub select_publish_1 {
	my $self = shift;
	my $insert = shift;
	
	my $sql = 'select * from '.$self->{table} .' where `publish` = 1'; 		
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

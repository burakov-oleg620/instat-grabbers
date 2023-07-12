package work_mysql_number;
use MD5;
use url_to_file;
use work_mysql;
use Encode qw (encode decode);
use URI::Escape;
use Data::Dumper;
use clear_str;


sub new {
	my $class = shift;
	
	my $mysql_dbdriver = shift; 
	my $mysql_host = shift; 
	my $mysql_port = shift; 
	my $mysql_user = shift;  
	my $mysql_user_password = shift; 
	my $mysql_base = shift; 
	my $mysql_table = shift;
	$mysql_table = $mysql_table .'_number';
	
	$work_mysql = work_mysql -> new (
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
	
	my $sql = 'SET NAMES UTF8';
	$work_mysql -> run_query ($sql) or die (print $!);

	return bless $self; 
}


sub select_mark {
	my $self = shift;
	my $insert = shift;
	my $return  = {};
	
	$sql = 'select * from `mark` where `name` = "'.quotemeta ($insert -> {mark_name}).'"';
	$work_mysql -> run_query ($sql) or die (print $!);
	
	my @row = $work_mysql -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			$return -> {mark_id} = $_ -> {id};
		}
	}
	return $return;	
}

sub insert_mark {
	my $self = shift;
	my $insert = shift;
	my $return = {};
	
	my $sql = 'insert into `mark` (
		`name`,
		`alias`
		)
		value (
		"'.quotemeta ($insert -> {mark_name}).'" ,
		"'.quotemeta ($insert -> {mark_alias}).'" 
		)';
	$work_mysql -> run_query ($sql) or die (print $!);					
	$return -> {mark_id} =  $work_mysql ->  get_last_id ();
	return $return;
}

sub select_model {
	my $self = shift;
	my $insert = shift;
	my $return  = {};
	
	$sql = 'select * from `model` where `name` = "'.quotemeta ($insert -> {model_name}).'"';
	$work_mysql -> run_query ($sql) or die (print $!);
	
	my @row = $work_mysql -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			$return -> {model_id} = $_ -> {id};
		}
	}
	return $return ;	
}

sub insert_model {
	my $self = shift;
	my $insert = shift;
	my $return = {};
	
	my $sql = 'insert into `model` (
		`mark_id`,
		`name`,
		`alias`
		)
		value (
		"'.quotemeta ($insert -> {mark_id}).'" ,
		"'.quotemeta ($insert -> {model_name}).'" ,
		"'.quotemeta ($insert -> {model_alias}).'" 
		)';
	
	$work_mysql -> run_query ($sql) or die (print $!);					
	$return -> {model_id} =  $work_mysql ->  get_last_id ();
	return $return ;
}


sub select_body_type {
	my $self = shift;
	my $insert = shift;
	my $return  = {};
	
	$sql = 'select * from `body_type` where `name_ru` = "'.quotemeta ($insert -> {body_type_name_ru}).'"';
	$work_mysql -> run_query ($sql) or die (print $!);
	
	my @row = $work_mysql -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			$return -> {body_type_id} = $_ -> {id};
		}
	}
	return $return ;	
}

sub insert_body_type {
	my $self = shift;
	my $insert = shift;
	my $return = {};
	
	my $sql = 'insert into `body_type` (
		`name_en`,
		`name_ru`,
		`alias`
		)
		value (
		"'.quotemeta ($insert -> {body_type_name_en}).'" ,
		"'.quotemeta ($insert -> {body_type_name_ru}).'" ,
		"'.quotemeta ($insert -> {body_type_alias}).'" 
		)';
	
	$work_mysql -> run_query ($sql) or die (print $!);					
	$return -> {body_type_id} =  $work_mysql ->  get_last_id ();
	return $return ;
}


sub select_series {
	my $self = shift;
	my $insert = shift;
	my $return  = {};
	
	$sql = 'select * from `series` where `name_ru` = "'.quotemeta ($insert -> {series_name_ru}).'"';
	$work_mysql -> run_query ($sql) or die (print $!);
	
	my @row = $work_mysql -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			$return -> {series_id} = $_ -> {id};
		}
	}
	return $return ;	
}

sub insert_series {
	my $self = shift;
	my $insert = shift;
	my $return = {};
	
	my $sql = 'insert into `series` (
		`model_id`,
		`name_en`,
		`name_ru`,
		`alias`,
		`body_type_id`,
		`year_from`,
		`year_to`
		)
		value (
		"'.quotemeta ($insert -> {model_id}).'" ,
		"'.quotemeta ($insert -> {series_name_en}).'" ,
		"'.quotemeta ($insert -> {series_name_ru}).'" ,
		"'.quotemeta ($insert -> {series_alias}).'" ,
		"'.quotemeta ($insert -> {body_type_id}).'" ,
		"'.quotemeta ($insert -> {series_year_from}).'" ,
		"'.quotemeta ($insert -> {series_year_to}).'" 
		)';

	$work_mysql -> run_query ($sql) or die (print $!);					
	$return -> {series_id} =  $work_mysql ->  get_last_id ();
	return $return ;
}



sub select_modofication {
	my $self = shift;
	my $insert = shift;
	my $return  = {};
	
	$sql = 'select * from `modification` where `name_ru` = "'.quotemeta ($insert -> {modification_name_ru}).'"';
	$work_mysql -> run_query ($sql) or die (print $!);
	
	my @row = $work_mysql -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			$return -> {modification_id} = $_ -> {id};
		}
	}
	return $return ;	
}

sub insert_modification {
	my $self = shift;
	my $insert = shift;
	my $return = {};
	
	my $sql = 'insert into `modification` (
		`series_id`,
		`name_en`,
		`name_ru`,
		`alias`
		)
		value (
		"'.quotemeta ($insert -> {series_id}).'" ,
		"'.quotemeta ($insert -> {modification_name_en}).'" ,
		"'.quotemeta ($insert -> {modification_name_ru}).'" ,
		"'.quotemeta ($insert -> {modification_alias}).'" 
		)';

	$work_mysql -> run_query ($sql) or die (print $!);					
	$return -> {modification_id} =  $work_mysql ->  get_last_id ();
	return $return ;
}


sub select_photo {
	my $self = shift;
	my $insert = shift;
	my $return  = {};
	
	$sql = 'select * from `photo` where `name_ru` = "'.quotemeta ($insert -> {photo_name_ru}).'"';
	$work_mysql -> run_query ($sql) or die (print $!);
	
	my @row = $work_mysql -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			$return -> {photo_id} = $_ -> {id};
		}
	}
	return $return ;	
}

sub insert_photo {
	my $self = shift;
	my $insert = shift;
	my $return = {};
	
	my $sql = 'insert into `photo` (
		`name_en`,
		`name_ru`,
		`alias`
		)
		value (
		"'.quotemeta ($insert -> {photo_name_en}).'" ,
		"'.quotemeta ($insert -> {photo_name_ru}).'" ,
		"'.quotemeta ($insert -> {photo_alias}).'" 
		)';

	$work_mysql -> run_query ($sql) or die (print $!);					
	$return -> {photo_id} =  $work_mysql ->  get_last_id ();
	return $return ;
}

sub select_model2photo {
	my $self = shift;
	my $insert = shift;
	my $return  = {};
	
	my $sql = 'select * from `model2photo` where `photo_id` = "'.quotemeta ($insert -> {photo_id}).'"';
	$work_mysql -> run_query ($sql) or die (print $!);
	
	my @row = $work_mysql -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			$return -> {model2photo_id} = $_ -> {id};
		}
	}
	return $return ;	
}

sub insert_model2photo {
	my $self = shift;
	my $insert = shift;
	my $return = {};
	
	my $sql = 'insert into `model2photo` (
		`model_id`,
		`photo_id`
		)
		value (
		"'.quotemeta ($insert -> {model_id}).'" ,
		"'.quotemeta ($insert -> {photo_id}).'" 
		)';

	$work_mysql -> run_query ($sql) or die (print $!);					
	$return -> {model2photo_id} =  $work_mysql ->  get_last_id ();
	return $return ;
}


					
1;

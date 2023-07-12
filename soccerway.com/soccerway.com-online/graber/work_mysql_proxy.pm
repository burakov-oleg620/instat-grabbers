package work_mysql_proxy;
use strict;
use warnings;
use MD5;
use url_to_file;
use work_mysql;
use Encode qw (encode decode);
use Data::Dumper;
use clear_str;
use Cwd;
use List::Util qw (shuffle);
use File::Copy;
use LWP;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI::Escape;
use URI::URL;
use IO::File;
use LWP::Protocol::https;


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
	
	my $read_inifile = read_inifile -> new ('graber.ini');
	$self -> {read_inifile} = $read_inifile;
	undef($read_inifile);
	
	return bless $self; 
}

sub create_table {
	my $self = shift;
	
	my $sql  = '
		create table if not exists '.$self->{table}.' (
		`id` int(11) PRIMARY KEY AUTO_INCREMENT,
		`hash` char (32) unique,
		`address` char (32) ,
		`try` int(2) default \'0\', 
		`time` int(11)
	) DEFAULT CHARSET=utf8'; 
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);

}

sub drop_table () {
	my $self = shift;
	my $sql  = 'drop table if exists '.$self->{table}; 
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
}


sub get_proxy_from_service {
	
	my $self = shift;
	
	
	my $f1 = '../../ip.txt';
	my $f2 = getcwd () .'/ip.txt';
	if (-f $f1) {
		copy ($f1, $f2) or die ();
	} 
	
	#print $self -> {read_inifile} -> {proxy_url} ."\n";
	
	if (!-f $f1) {
		
		my $lwp = undef;
		$lwp = LWP::UserAgent -> new ();
		$lwp -> cookie_jar (HTTP::Cookies->new ());
		$lwp -> agent ('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0');
		$lwp -> timeout (60);
		
		my $method = 'GET'; 
		my $url = undef;

		$url = $self -> {read_inifile} -> {proxy_url};
		my $req = HTTP::Request -> new (
			$method => $url,
			[
				'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0',
				'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
				'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
			]
		);
		
		
		my $res = $lwp -> request ($req);
		print $res -> code ."\t". $url ."\n";
		
		if ($res -> code == 200) {
			
			my @content = split ("\n", $res -> content); 
			my $file = getcwd (). '/ip.txt';
			
			open (my $fh, '>'. $file) or die;
			
			if (scalar (@content) > 0) {
				foreach (@content) {
					my $clear_str = clear_str -> new ($_);
					$_ = $clear_str -> delete_4 ();
					$clear_str = undef;						
					
					if ($_ =~ /:/) {
						#print $_ ."\n";
						print $fh $_ ."\n";	
					}
				}
			}
			
			close ($fh);
		}
	}
	
	
	my @file = ();
	my $file = getcwd (). '/ip.txt';
	
	if (-f $file) {
		open (my $fh, $file) or die ();
		while (<$fh>) {
			if ($_=~ /^\d/) {
				$_ =~ s/\n+|\r+|\t+//g;
				if ($_ =~ /:/) {
					push (@file, $_);	
				}
			}
		}
		
		@file = shuffle (@file);
		@file = shuffle (@file);
		@file = shuffle (@file);
		
		if (scalar (@file) > 0) {
			foreach (@file) {
		
				my $address = $_;
				my $try = 0;
				my $md5 = MD5 -> new ();
				my $hash = $md5 -> hexhash ($address);
				$md5 = undef;
				
				print $address ."\n";
				
				my $sql = 'select * from '.$self->{table}.' where `hash` = "'.$hash.'"';
				$self -> {work_mysql} -> run_query ($sql) or die (print $!);
				my @row = $self -> {work_mysql} -> get_row_hashref (); 
				if (scalar (@row) > 0) {
					
				} else {
				
					my $sql = 'insert ignore into '.$self->{table}.' (
						`hash`,
						`address`,
						`try`, 
						`time` 
						)
						value (
						"'.$hash.'", 
						"'.quotemeta ($address).'", 
						"'.$try.'", 
						"'.time ().'" 
						)
					';
					$self -> {work_mysql} -> run_query ($sql) or die (print $!);
				}
			}
		}
	}
	return 1;
}



sub get_proxy_from_table {
	
	my $self = shift;
	my $limit  = shift;
	my $try = shift;
	
	my $return = [];
	my $sql = 'select * from '.$self -> {table}.' where `try` < "'.$try.'" limit '.$limit; 		
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
	my @row = $self -> {work_mysql} -> get_row_hashref ();
	if (scalar (@row) > 0) {
		foreach (@row) {
			push (@$return, $_);
		}
	}	
	return $return; 
}


sub set_proxy_try  {
	my $self = shift;
	my $hash  = shift;
	my $try = shift;
	
	my $sql = 'update '.$self->{table}.' set  `try` = "'.$try.'" where `hash` = "'.$hash.'"';
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
	return 1;
}	


sub clear_proxy {
	my $self = shift;
	my $clear_time  = shift;
	my $proxy_try = shift;
	
	my $time = time () - $clear_time;
	my $sql = 'select * from '.$self->{table}.' where `time` BETWEEN "0" AND '.$time.' and `try` = "'.$proxy_try.'"';
	$self -> {work_mysql} -> run_query ($sql) or die (print $!);
	my @row = $self -> {work_mysql} -> get_row_hashref (); 
	if (scalar (@row) > 0) {	
		foreach (@row) {
			my $sql = 'delete from '.$self->{table}.' where `hash` = "'.$_ ->{hash}.'"';
			$self -> {work_mysql} -> run_query ($sql) or die (print $!);
		}
	}
	return 1;
}	










1;

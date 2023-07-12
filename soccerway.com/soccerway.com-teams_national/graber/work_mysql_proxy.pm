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
	
	# my $lwp = LWP::UserAgent -> new ();
	# $lwp -> cookie_jar (HTTP::Cookies->new ());
	# $lwp -> agent ('Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16');
	# $lwp -> timeout (5);
	
	# my $method = 'GET'; 
	# my $url = undef;

	# $url = 'http://best-proxies.ru/feeds/proxylist.txt?type=http&limit=0&key=QBulVAWcrsKQ';	
	# $url = 'http://submitlog.ru/proxy_list.txt';
	
	# my $req = HTTP::Request -> new (
		# $method => $url,
		# [
			# 'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
			# 'Accept-Language' => 'ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
		# ]
	# );
	
	
	# my $res = $lwp -> request ($req);
	# print $res -> code ."\t". $url ."\n";
	
	# if ($res -> code == 200) {
		# my @content = split ("\n", $res -> content); 
		# if (scalar (@content) > 0) {
			# foreach (@content) {
				# my $clear_str = clear_str -> new ($_);
				# $_ = $clear_str -> delete_4 ();
				# $clear_str = undef;				
	
	my @file = ();
	my $file = getcwd (). '/ip.txt';
	
	if (-f $file) {
		open (my $fh, $file) or die ();
		while (<$fh>) {
			
			if ($_=~ /^\d/) {
				$_ =~ s/\n+//g;
				push (@file, $_);
			}
		}
		
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

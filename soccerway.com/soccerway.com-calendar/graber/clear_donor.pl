#!/usr/bin/perl
#экспорт в XML

use strict;
use warnings;
use locale;
use Encode qw (encode decode);
use dir_scan_recurce;
use read_text_file; 
use write_text_file_mode_rewrite; 
use clear_str;
use delete_duplicate_from_array; 
use read_inifile;
use work_mysql;
use work_for_content;
use write_to_txt1;
use write_to_txt2;

use File::Copy;
use File::Path;

use MD5;
use url_to_file;
use date_time;

use Encode qw (encode decode);

my $read_inifile = read_inifile -> new ('graber.ini'); 
my $host = $read_inifile -> get ('host');
my $alias = $read_inifile -> get ('alias');

#Читаю установки из ини файла
my $mysql_dbdriver = $read_inifile -> get ('mysql_dbdriver');
my $mysql_host = $read_inifile -> get ('mysql_host');
my $mysql_port = $read_inifile -> get ('mysql_port');
my $mysql_user = $read_inifile -> get ('mysql_user');
my $mysql_user_password = $read_inifile -> get ('mysql_user_password');
if ($mysql_user_password eq ' ') {$mysql_user_password = '';}
my $mysql_base = $read_inifile -> get ('mysql_base');
my $mysql_table = $read_inifile -> get ('mysql_table');
my $atable = $read_inifile -> get ('atable');

my $work_mysql = work_mysql -> new (
	$mysql_dbdriver,
	$mysql_host,
	$mysql_port,
	$mysql_user,
	$mysql_user_password,
	$mysql_base
); 	

my $sql = 'delete from '.$atable.' where `donor` = "'.$alias.'"';
$work_mysql -> run_query ($sql);
		
sub get_base_path {
	use Cwd; 
	my $cwd = getcwd ();
	return $cwd;
}



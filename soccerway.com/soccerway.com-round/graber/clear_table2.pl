#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;
use lib getcwd ();
use write_text_file_mode_add;
use write_text_file_mode_rewrite; 
use read_text_file;
use work_mysql;
use read_inifile;
use work_mysql_number;

my $read_inifile = read_inifile -> new ('graber.ini'); 
                    
my $mysql_dbdriver = $read_inifile -> get ('mysql_dbdriver');
my $mysql_host = $read_inifile -> get ('mysql_host');
my $mysql_port = $read_inifile -> get ('mysql_port');
my $mysql_user = $read_inifile -> get ('mysql_user');
my $mysql_user_password = $read_inifile -> get ('mysql_user_password');
my $mysql_base = $read_inifile -> get ('mysql_base');
my $mysql_table = $read_inifile -> get ('mysql_table');
if ($mysql_user_password eq ' ') {$mysql_user_password = '';}


my $work_mysql = work_mysql -> new (
	$mysql_dbdriver,
	$mysql_host,
	$mysql_port,
	$mysql_user,
	$mysql_user_password,
	# 'graber',
	'mysql',
); 

my $sql = undef;

# $sql = 'drop DATABASE if exists '.$mysql_base;
# $work_mysql -> run_query ($sql);

$sql = 'CREATE DATABASE if not exists '.$mysql_base;
$work_mysql -> run_query ($sql);
$work_mysql = undef;

$work_mysql = work_mysql -> new (
	$mysql_dbdriver,
	$mysql_host,
	$mysql_port,
	$mysql_user,
	$mysql_user_password,
	$mysql_base
); 


# $sql  = 'drop table if exists '.$mysql_table; 
# $work_mysql -> run_query ($sql);

$sql  = 'delete from '.$mysql_table.' where `type` = "media"'; 
$work_mysql -> run_query ($sql);

$sql  = '
	create table if not exists '.$mysql_table.' (
	hash char (32) not null primary key unique,
	method char (5),
	url text,
	referer text,
	file text,
	state char (5),
	type  char (7),
	str_for_content text
) DEFAULT CHARSET=utf8;'; 

$work_mysql -> run_query ($sql);



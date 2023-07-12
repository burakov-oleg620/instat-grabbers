#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;
use lib getcwd ();
use File::Path;
use Encode qw (decode encode);
use locale;
use List::Util qw (shuffle);
use Cwd;
use dir_scan_recurce;

use threads;
use threads::shared;
use Thread::Queue;

use read_inifile;
use read_select1;
use read_select2;
use clear_str;
use create_type_workdir;
use url_to_file;
use read_xml;

use work_mysql_number;
use work_mysql_graber;
use work_mysql_proxy;
use work_for_content;

use write_text_file_mode_add;
use write_text_file_mode_rewrite; 
use read_text_file;

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI::Escape;
use JSON::XS;
use Data::Dumper;
use URI::URL;
# use category_hash;

#system 'clear_table.pl'; 
#system 'clear_dir.pl';

#Читаю установки из ини файла
my $read_inifile = read_inifile -> new ('graber.ini'); 
my $mysql_dbdriver = $read_inifile -> get ('mysql_dbdriver');
my $mysql_host = $read_inifile -> get ('mysql_host');
my $mysql_port = $read_inifile -> get ('mysql_port');
my $mysql_user = $read_inifile -> get ('mysql_user');
my $mysql_user_password = $read_inifile -> get ('mysql_user_password');
if ($mysql_user_password eq ' ') {$mysql_user_password = '';}
my $mysql_base = $read_inifile -> get ('mysql_base');
my $mysql_table = $read_inifile -> get ('mysql_table');

my $threads_all = $read_inifile -> get ('threads_all'); 
my $sleep1 = $read_inifile -> get ('sleep1'); 
my $sleep2 = $read_inifile -> get ('sleep2'); 
my $sleep3 = $read_inifile -> get ('sleep3'); 

my $host = $read_inifile -> get ('host');	
my $set_proxy = $read_inifile -> get ('set_proxy');
my $count_all = $read_inifile -> get ('count_all');	

# читаем шаблоны (ссылок и прочее)
my $read_select2 = read_select2 -> new ('select2.txt'); 
my @read_select2 = $read_select2 -> get ();
$read_select2 = undef;

my $read_select3 = read_select2 -> new ('select3.txt'); 
my @read_select3 = $read_select3 -> get ();
$read_select3 = undef;

my $read_select4 = read_select2 -> new ('select4.txt'); 
my @read_select4 = $read_select4 -> get ();
$read_select4 = undef;	

my @proxy = (); #массив с прокси
my @useragent = (); 


#создаю экземпляр броузера
# my $lwp = undef;
# $lwp = LWP::UserAgent -> new ();
# $lwp -> cookie_jar (HTTP::Cookies->new ());
# $lwp -> agent ('Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16');
# $lwp -> timeout (5);
# $lwp -> proxy ('http', 'http://127.0.0.1:8080');

#очередь работы, куда добавляются задания
# my $queue_job = Thread::Queue->new ();
# my $queue_job_proxy = Thread::Queue->new ();

#гобальные переменные
# my @start_second = (); my $start_second = 0; #переменные для отслеживания запуска start_second ();
# my @pattern_from_select = (); my $pattern_from_select = undef; #проверка контента на наличие указанного шаблона текста

# my %tid_hash :shared; 
# %tid_hash = (); #глобальный хеш - работают потоки или нет.


#устанавливаем соединение с базой данных
#соединение для тела программы
our $work_mysql_graber = work_mysql_graber -> new (
	$mysql_dbdriver,
	$mysql_host,
	$mysql_port,
	$mysql_user,
	$mysql_user_password,
	$mysql_base,
	$mysql_table
); 

start_first (); #добавляеет входящую ссылку из XML файла

sub start_first {
	
	my $count = 0;
	
	my $workdir1 = getcwd () .'/xls2';
	my $dir_scan_recurce = dir_scan_recurce -> new ($workdir1);
	while (my $file1 = $dir_scan_recurce -> get_file ()) {
		print ++$count."\n";
		
		my $pattern = 'xls$';
		if ($file1 =~ /$pattern/) {	
			
			# print '***' ."\n";
			# my $category_hash =  category_hash -> new ($file1);
			# %cat =  $category_hash -> do ();
			# $category_hash = undef;
			
			# foreach (keys (%cat)) {
				# print $cat {$_} ."\n";
			# }
		
			my @file1 = ();	
			my $read_text_file = read_text_file -> new ($file1); 
			while (my $str1 = $read_text_file -> get_str ()) {
			
				if ($str1 =~ /\t/) {
					my $temp1 = []; my $pattern1 = "\t"; @$temp1 = split ($pattern1, $str1); 
					
					# print '*'.scalar (@$temp1)."\n";
					if (scalar (@$temp1) == 2 ) {			
						print ++$count."\n";	
						
						foreach (@$temp1) {
							my $clear_str = clear_str -> new ($_); 
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;
						}
						
						# my $url_str = 'http://1k.by/products/search?searchFor=products&s_keywords='.$temp1 -> [1].'&s_categoryid=0';
						# my $uri = URI::URL-> new( $url_str, 'http://'.$host);
						# my $url = $uri->abs;
						
						
						# $temp1 -> [0] = encode ('utf8', decode ('cp1251', $temp1 -> [0]));
						# $temp1 -> [0] = uri_escape ($temp1 -> [0]);
						# my $url = 'http://basicdecor.ru/?search='.$temp1 -> [0];
						
						if ($temp1 -> [0] =~ /\d+/ and $temp1 -> [1] == 1) {
						
							my $data_area_id = $temp1 -> [0];
						
							my $url = 'https://int.soccerway.com/a/block_teams_index_national_teams?block_id=page_teams_1_block_teams_index_national_teams_2&callback_params='.uri_escape ('{"level":1}').'&action=expandItem&params='.uri_escape ('{"area_id":"'.$data_area_id.'","level":2,"item_key":"area_id"}');;
							my $method = 'GET';
							# my $type = 'html';
							
							my $type = 'out';
							
							my $referer = $url;
							my $str_for_content = 'href';
							
							$work_mysql_graber -> insert_ignore (
								$method, 
								$url,
								$referer,
								$type, 
								$str_for_content
							); 
						}
					}
				}
			}
		}
	}
}



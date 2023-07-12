#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;
use lib getcwd ();
use File::Path;
use Encode qw (decode encode);
use locale;
use List::Util qw (shuffle);

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
# use JSON::XS;
#use work_mysql_number;

use work_mysql_graber;
use work_mysql_proxy;
use work_for_content;

use write_text_file_mode_add;
use write_text_file_mode_rewrite; 
use read_text_file;

use LWP;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI::Escape;
use URI::URL;
use IO::File;



# use HTML::TreeBuilder::XPath;
# use utf8;
# use WWW::Mechanize::PhantomJS;
# use MIME::Base64;

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
my $lwp_proxy = undef;

#создаю экземпляр броузера
my $lwp = undef;
$lwp = LWP::UserAgent -> new ();
$lwp -> cookie_jar (HTTP::Cookies->new ());
$lwp -> agent ('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0');
$lwp -> timeout (20);
# $lwp -> proxy ('http', 'http://127.0.0.1:8080');

#очередь работы, куда добавляются задания
my $queue_job = Thread::Queue->new ();
my $queue_job_proxy = Thread::Queue->new ();

#гобальные переменные
my @start_second = (); my $start_second = 0; #переменные для отслеживания запуска start_second ();
my @pattern_from_select = (); my $pattern_from_select = undef; #проверка контента на наличие указанного шаблона текста

my %tid_hash :shared; 
%tid_hash = (); #глобальный хеш - работают потоки или нет.
my %proxy :shared; 
%proxy = ();

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


# ситуация с прокси
if ($read_inifile -> {proxy_set} == 1) {

	my $work_mysql_proxy = work_mysql_proxy -> new (
		$mysql_dbdriver,
		$mysql_host,
		$mysql_port,
		$mysql_user,
		$mysql_user_password,
		$mysql_base,
		$mysql_table. '_proxy',	
	); 
	
	if ($read_inifile -> {get_proxy_from_service} == 1) {
	
		$work_mysql_proxy -> drop_table (); 
		$work_mysql_proxy -> create_table (); 
		$work_mysql_proxy -> clear_proxy ($read_inifile -> {proxy_clear}, $read_inifile -> {proxy_try_max});
		$work_mysql_proxy -> get_proxy_from_service (); 
		$work_mysql_proxy = undef;
		
	}
}	

# login ();
# start_first (); #добавляеет входящую ссылку из XML файла

our @threads = (); 
push (@threads, threads -> new (\&work_thread1)); 
foreach  (1..$threads_all) {
	push (@threads, threads -> new (\&work_thread2));
	sleep 1;
}
foreach (@threads) {
	$_ -> join ();
	sleep 1;
}


sub start_first {
	my $read_xml = read_xml -> new ('select1.xml');
	my $xml = $read_xml -> get ();
	
	foreach (@$xml) {
		
		my $method = 'GET'; 
		my $url = $_->{url}; 
		my $referer = $_->{referer}; 
		
		# $url = uri_unescape ($url);
		# $url = encode ('cp1251', decode ('utf8', $url));
			
		my $type = 'html';
		my $str_for_content = $_->{str_for_content}; 
		
		$work_mysql_graber -> insert_ignore (
			$method, 
			$url,
			$referer,
			$type, 
			$str_for_content
		); 						
		
		$work_mysql_graber -> update_set_new ($url);
	}
	
	$work_mysql_graber = undef;
}


sub work_thread1 {
	
	#Создаем дескриптор на mysql соединение
	#обязательно по соединения на поток.
	our $work_mysql_graber = work_mysql_graber -> new (
		$mysql_dbdriver,
		$mysql_host,
		$mysql_port,
		$mysql_user,
		$mysql_user_password,
		$mysql_base,
		$mysql_table
	); 
	
	our $work_mysql_proxy = undef;
	if ($read_inifile -> {proxy_set} == 1) {
		$work_mysql_proxy = work_mysql_proxy -> new (
			$mysql_dbdriver,
			$mysql_host,
			$mysql_port,
			$mysql_user,
			$mysql_user_password,
			$mysql_base,
			$mysql_table. '_proxy',	
		); 
	}
	
	
	my $count = 0;
	while (1) {
		if ($read_inifile -> {proxy_set} == 1) {
			# $work_mysql_proxy -> drop_table (); 
			# $work_mysql_proxy -> create_table (); 
			# $work_mysql_proxy -> clear_proxy ($read_inifile -> {proxy_clear}, $read_inifile -> {proxy_try_max});
			
			if ($queue_job_proxy -> pending () < $read_inifile -> {proxy_select}) {
				my $get_proxy_from_table = $work_mysql_proxy -> get_proxy_from_table ($read_inifile -> {proxy_select} * 2, $read_inifile -> {proxy_try_max});
				if (scalar (@$get_proxy_from_table) > 0 and scalar (@$get_proxy_from_table) > ($read_inifile -> {proxy_select} -1)) {
					foreach (@$get_proxy_from_table) {
						if (exists ($proxy {$_ -> {hash}})) {
						
						} else {
							$queue_job_proxy -> enqueue ($_); 
							$proxy {$_->{hash}} = $_ -> {address};
						}
					}
				} else {
					
					print 'end proxy scalar (@$get_proxy_from_table) = ' . scalar (@$get_proxy_from_table) ."\n";
					die ();
					exit;
				}
			}
		}	
		
		
		
		my $num_keys_tid_hash = keys (%tid_hash);
		if ($num_keys_tid_hash < $threads_all) {
			my $array = $work_mysql_graber -> select_all_update_work ($threads_all);
			if (scalar (@$array) > 0) {
				foreach (@$array) {
					$queue_job -> enqueue ($_); 
				}
			} else {
				if ($num_keys_tid_hash == 0) {$count++;}
				if ($count > 3) {
					exit;
				}
			}
		}
		
		sleep $sleep1;
		
	}
	$work_mysql_graber = undef;
}


sub work_thread2 {

	# # Для вставки в таблицу номеров
	# our $work_mysql_number = work_mysql_number -> new (
		# $mysql_dbdriver,
		# $mysql_host,
		# $mysql_port,
		# $mysql_user,
		# $mysql_user_password,
		# $mysql_base,
		# $mysql_table		
	# ); 		
	# #удаление исоздание таблиц номеров.
	# $work_mysql_number -> drop_table ();
	# $work_mysql_number -> create_table ();


	#работа с прокси в потоке.
	our $work_mysql_proxy = work_mysql_proxy -> new (
		$mysql_dbdriver,
		$mysql_host,
		$mysql_port,
		$mysql_user,
		$mysql_user_password,
		$mysql_base,
		$mysql_table. '_proxy',	
	); 
	
	
	#Создаем дескриптор на mysql соединение
	#обязательно по соединения на поток.	
	our $work_mysql_graber = work_mysql_graber -> new (
		$mysql_dbdriver,
		$mysql_host,
		$mysql_port,
		$mysql_user,
		$mysql_user_password,
		$mysql_base,
		$mysql_table
	); 	
	
	
	
	my $count = 0;
	while (my $job = $queue_job -> dequeue ()) {
		#Узнать номер потока и поместить его в hash потоков
		our $tid = threads -> tid (); $tid_hash {$tid} = 1; 
		
		my $create_type_workdir = create_type_workdir -> new ($job -> {type});
		my $type_workdir = $create_type_workdir -> do ();
		$create_type_workdir = undef;
		
		my $file = $type_workdir.'/'.$job -> {file};
		
		my $response = get_content_from_url ($job);
			
		if (-f $file) {
			my $referer = $job -> {url}; #определяем родительское URL (реферера)
			
			if ($job -> {type} eq 'html') {

				my $content2 = get_content_from_file ($file); 
				# $content2 = utf8_to_win1251 ($content2);
				
				my $clear_str = clear_str -> new ($content2); 
				$content2 = $clear_str -> delete_4 ();
				$clear_str = undef;	
				
				# $content2 =~ s/>\s+</></g;
				# $content2 =~ s/\'/"/g;
				# $content2 =~ s/\"\"/" "/g;
				
				# {
					# my $pattern1 = '<div class="pos_.+?"';
					# my $pattern2 = '<div class="pos"';
					# $content2 =~ s/$pattern1/$pattern2/g;
				# }
				
				
				# my $tree = HTML::TreeBuilder::XPath -> new ();
				# $tree -> parse_content ($content2);
				# my $content3 = $tree -> findnodes_as_string ('//div[@class="pos"]'); 
				# $tree->delete;
				# $tree = undef;						
				
				# # ссылки на товары
				# my @content3 = split ("\n", $content3); 
				# if (scalar (@content3) > 0) {
					# foreach (@content3) {
						# my $clear_str = clear_str -> new ($_);
						# $_ = $clear_str -> delete_4 ();
						# $clear_str = undef;						
						# $_ = entities_decode ($_);	

						
				
				#ссылки на соревнования первая таблица
				my $pattern1 = '(<ul class="areas".+?</ul>)';
				my $work_for_content = work_for_content -> new ($content2); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;										
						
						my $pattern1 = 'data-area_id="(.+?)"';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;			
								
								my $data_area_id = $_;
								
								#https://int.soccerway.com/a/block_teams_index_club_teams?block_id=page_teams_1_block_teams_index_club_teams_2&callback_params={"level":1}&action=expandItem&params={"area_id":"8","level":2,"item_key":"area_id"}
								my $url = 'https://int.soccerway.com/a/block_teams_index_club_teams?block_id=page_teams_1_block_teams_index_club_teams_2&callback_params='.uri_escape ('{"level":1}').'&action=expandItem&params='.uri_escape ('{"area_id":"'.$data_area_id.'","level":2,"item_key":"area_id"}');
								
								
								# my $uri = URI::URL-> new( $_, $job -> {url});
								# my $url = $uri->abs;
								
								my $method = 'GET';
								my $type = 'out';
								my $str_for_content = $job -> {str_for_content};
								
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
			
			
			if ($job -> {type} eq 'out') {
				
				my $content2 = get_content_from_file ($file); 
				# $content2 = utf8_to_win1251 ($content2);
				
				my $clear_str = clear_str -> new ($content2); 
				$content2 = $clear_str -> delete_4 ();
				$clear_str = undef;	

				$content2 =~ s/\\//g;
				
				if ($content2 =~ /\{"commands"/) {
				
					my $pattern1 = 'data-competition_id="(.+?)"';
					my $work_for_content = work_for_content -> new ($content2); 
					my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;										
							
							#https://int.soccerway.com/a/block_teams_index_club_teams?block_id=page_teams_1_block_teams_index_club_teams_2&callback_params={"level":"2"}&action=expandItem&params={"competition_id":"9","level":3,"item_key":"competition_id"}
							# my $url = 'https://int.soccerway.com/a/block_teams_index_club_teams?block_id=page_teams_1_block_teams_index_club_teams_2&callback_params='.uri_escape ('{"level":1}').'&action=expandItem&params='.uri_escape ('{"area_id":"'.$data_area_id.'","level":2,"item_key":"area_id"}');
							my $url = 'https://int.soccerway.com/a/block_teams_index_club_teams?block_id=page_teams_1_block_teams_index_club_teams_2&callback_params='.uri_escape ('{"level":"2"}').'&action=expandItem&params='.uri_escape ('{"competition_id":"'.$_.'","level":3,"item_key":"competition_id"}');

							
							# my $uri = URI::URL-> new( $_, $job -> {url});
							# my $url = $uri->abs;
							
							my $method = 'GET';
							my $type = 'pdf';
							my $str_for_content = $job -> {str_for_content};
							
							$work_mysql_graber -> insert_ignore (
								$method, 
								$url,
								$referer,
								$type, 
								$str_for_content
							); 
						}
					}
					
					
						
					$pattern1 = 'href="(.+?)"';
					$work_for_content = work_for_content -> new ($content2); 
					$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;										
							
							if ($_ =~ /^\/teams\//) {
								
								my $uri = URI::URL-> new( $_, $job -> {url});
								my $url = $uri->abs;
								
								my $method = 'GET';
								my $type = 'media';
								my $str_for_content = $job -> {str_for_content};
								
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

			
			if ($job -> {type} eq 'pdf') {
				
				my $content2 = get_content_from_file ($file); 
				# $content2 = utf8_to_win1251 ($content2);
				
				my $clear_str = clear_str -> new ($content2); 
				$content2 = $clear_str -> delete_4 ();
				$clear_str = undef;	

				$content2 =~ s/\\//g;
				
				if ($content2 =~ /\{"commands"/) {
					
					my $pattern1 = 'href="(.+?)"';
					my $work_for_content = work_for_content -> new ($content2); 
					my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;										
							
							if ($_ =~ /^\/teams\//) {
								
								my $uri = URI::URL-> new( $_, $job -> {url});
								my $url = $uri->abs;
								
								my $method = 'GET';
								my $type = 'media';
								my $str_for_content = $job -> {str_for_content};
								
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
			
			
			if ($job -> {type} eq 'medim') {
			
				my $content2 = get_content_from_file ($file); 
				# $content2 = utf8_to_win1251 ($content2);
				
				my $clear_str = clear_str -> new ($content2); 
				$content2 = $clear_str -> delete_4 ();
				$clear_str = undef;	
			
			
				#ссылки на команды
				my $pattern1 = '(<div class="container left">.+?</a>)';
				my $work_for_content = work_for_content -> new ($content2); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;										
						
						my $pattern1 = 'href="(.+?)"';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;															
								
								my $pattern1 = '/teams/';
								if ($_ =~ /$pattern1/) {
									$_ =~ s/\?.+$//;
									$_ =~ s/\#.+$//;
				
									my $uri = URI::URL-> new( $_, $job -> {url});
									my $url = $uri->abs;
									my $method = 'GET';
									my $type = 'media';
									my $str_for_content = $job -> {str_for_content};
									
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
				
				$pattern1 = '(<div class="container right">.+?</a>)';
				$work_for_content = work_for_content -> new ($content2); 
				$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;										
						
						my $pattern1 = 'href="(.+?)"';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;															
								
								my $pattern1 = '/teams/';
								if ($_ =~ /$pattern1/) {
								
									$_ =~ s/\?.+$//;
				
									my $uri = URI::URL-> new( $_, $job -> {url});
									my $url = $uri->abs;
									my $method = 'GET';
									my $type = 'media';
									my $str_for_content = $job -> {str_for_content};
									
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
				
				#судьи
				$pattern1 = '(<a.+?</a>)';
				$work_for_content = work_for_content -> new ($content2); 
				$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;										
						
						my $pattern1 = 'href="(.+?)"';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;															
				
								my $pattern1 = '/referees/';
								my $pattern2 = '\?';
								
								if ($_ =~ /$pattern1/ and $_ !~ /$pattern2/) {
				
									my $uri = URI::URL-> new( $_, $job -> {url});
									my $url = $uri->abs;
									my $method = 'GET';
									my $type = 'medir';
									my $str_for_content = $job -> {str_for_content};
									
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
			
			
			if ($job -> {type} eq 'media') {

				my $content2 = get_content_from_file ($file); 
				# $content2 = utf8_to_win1251 ($content2);
				
				my $clear_str = clear_str -> new ($content2); 
				$content2 = $clear_str -> delete_4 ();
				$clear_str = undef;	
				
				my $pattern1 = '(<a.+?</a>)';
				my $work_for_content = work_for_content -> new ($content2); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;										
						
						my $pattern1 = 'href="(.+?)"';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;															
								
								my $pattern1 = '/players/.+?/\d+';
								my $pattern2 = '\?';
								if ($_ =~ /$pattern1/ and $_ !~ /$pattern2/) {
				
									my $uri = URI::URL-> new( $_, $job -> {url});
									my $url = $uri->abs;
									my $method = 'GET';
									my $type = 'mediu';
									my $str_for_content = $job -> {str_for_content};
									# my $referer = $job -> {str_for_content};
									
									$work_mysql_graber -> insert_ignore (
										$method, 
										$url,
										$referer,
										$type, 
										$str_for_content
									); 
								}
								
								$pattern1 = '/coaches/';
								$pattern2 = '\?';
								if ($_ =~ /$pattern1/ and $_ !~ /$pattern2/) {
				
									my $uri = URI::URL-> new( $_, $job -> {url});
									my $url = $uri->abs;
									my $method = 'GET';
									my $type = 'medic';
									my $str_for_content = $job -> {str_for_content};
									
									$work_mysql_graber -> insert_ignore (
										$method, 
										$url,
										$referer,
										$type, 
										$str_for_content
									); 
								}
								
								$pattern1 = '/\d+/venue/$';
								$pattern2 = '\?';
								if ($_ =~ /$pattern1/ and $_ !~ /$pattern2/) {
				
									my $uri = URI::URL-> new( $_, $job -> {url});
									my $url = $uri->abs;
									my $method = 'GET';
									my $type = 'pictura';
									my $str_for_content = $job -> {str_for_content};
									
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
			} #if html
			
			
			#удаление файла (только для этого грабера!!!!!)
			# unlink ($file) or die (print $!);
			
		} else {
			#если файла нету
			$work_mysql_graber -> update_set_fail ();
		}
		
		delete ($tid_hash {$tid}); #убираю элемент (поток) из хеша работающих потоков
	}
	
	$work_mysql_graber = undef;
	
	
	
	#######################подпрограммы потока.
	
	sub get_content_from_url {
		my $job = shift;
		
		my $method = $job -> {method};
		my $url = $job -> {url};
		my $referer = $job -> {referer};
		my $file = $job -> {type}. '/'. $job -> {file};
		my $type = $job -> {type};
		my $useragent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0';
		
		# if (-f 'proxy_list.txt') {
			# if (scalar (@proxy) == 0) {
				# my $read_select2 = read_select2 -> new ('proxy_list.txt'); 
				# @proxy = $read_select2 -> get ();
				# @proxy = shuffle (@proxy); 
			# }
			
			# my $lwp_proxy = shift (@proxy);
			# $lwp -> proxy ('http', 'http://'.$lwp_proxy);		
		# }
		
		if (-f 'useragent.txt') {
			if (scalar (@useragent) == 0) {
				my $read_select2 = read_select2 -> new ('useragent.txt'); 
				@useragent = $read_select2 -> get ();
				@useragent = shuffle (@useragent); 
			}
			$useragent = shift (@useragent);
		}

		
		if ($read_inifile -> {proxy_set} == 1) {
			
			if ($lwp_proxy = $queue_job_proxy -> dequeue_nb ())  {
				# print '$lwp_proxy -> {address} = '. $lwp_proxy -> {address} ."\n";
				
				#удаление из контролирующего прокси хеша
				if (exists ($proxy {$lwp_proxy -> {hash}})) {
					delete $proxy {$lwp_proxy -> {hash}};
				}
				
				# print 'scalar proxy pool = '. $queue_job_proxy -> pending() . "\n";
				# print $lwp_proxy -> {address} ."\n";
				$lwp -> proxy (['http', 'https'], 'http://'.$lwp_proxy -> {address});
				
			} else {
				die ();
				
				# exit;
				
				# $work_mysql_proxy -> drop_table (); 
				# $work_mysql_proxy -> create_table (); 
				# $work_mysql_proxy -> clear_proxy ($read_inifile -> {proxy_clear}, $read_inifile -> {proxy_try_max});
				# $work_mysql_proxy -> get_proxy_from_service (); 				

				# my $get_proxy_from_table = $work_mysql_proxy -> get_proxy_from_table ($read_inifile -> {proxy_select}, $read_inifile -> {proxy_try_max});
				# if (scalar (@$get_proxy_from_table) > 0) {
					# foreach (@$get_proxy_from_table) {
						# $queue_job_proxy -> enqueue ($_); 
					# }
					
					# $lwp_proxy = $queue_job_proxy -> dequeue_nb ();
					# $lwp -> proxy ('http', 'http://'.$lwp_proxy -> {address});
				# } else {
					# print 'proxy!!!!! net' ."\n";
					# exit;				
				# }
			}
		}
		
		my $request = HTTP::Request -> new (
			$method => $url,
			[
				'User-Agent' => $useragent,
				'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
				'Accept-Language' => 'ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
				
				#'Accept-Charset' => 'windows-1251,utf-8;q=0.7,*;q=0.7',
				# 'Referer' => $referer,
			]
		);

		my $response = $lwp -> request ($request, $file);
		
		#индикация происходящего на экране
		# print $response -> status_line  ."\t". scalar (@threads). "\t". $job -> {url}  ."\n";
		
		# print $response -> code  ."\t". scalar (@threads). "\t". $job -> {url}  ."\n";
		print get_date() ."\t". $response -> code  ."\t". scalar (@threads). "\t". $job -> {url}  ."\n";
		
		# if ($read_inifile -> {screen_log} == 1) {
			# $log -> put_str ($response -> code  ."\t". scalar (@threads). "\t". $job -> {url});			
		# }
		
		# my $code = 500;
		if ($response -> code == 200) {
		# if ($code == 200) {
			
			# my $content = get_content_from_file ($file);
			$work_mysql_graber -> update_set_pass ($url);
			
		} else {
			
			if ($read_inifile -> {proxy_set} == 1) {
			
				if ($response -> code == 500 or $response -> code == 503) {
				# if ($code == 500) {
				
					# $lwp_proxy -> {try}++; #ставлю прокси попытку неудачную
					# print '$lwp_proxy -> {try} = '. $lwp_proxy -> {try} ."\n";
					# $work_mysql_proxy -> set_proxy_try ($lwp_proxy -> {hash}, $lwp_proxy -> {try});
					# $work_mysql_graber -> update_set_new ($url); 
					
					# #поскольку у нас прокси чистые, то сразу переводим в fail
					if ($job -> {str_for_content} < 15) {
					
						$job -> {str_for_content} = $job -> {str_for_content} + 1 ;
						
						$work_mysql_graber -> update_set_str_for_content ($url, $job -> {str_for_content});	
						$work_mysql_graber -> update_set_new ($url);	
						
					} else {
						
						$work_mysql_graber -> update_set_str_for_content ($url, $job -> {str_for_content});	
						$work_mysql_graber -> update_set_fail ($url);
					}
					
					
				} else {
					$work_mysql_graber -> update_set_fail ($url);
				}

				
				# if ($response -> code == 403) {
					# print '$lwp_proxy -> {try} = '. $lwp_proxy -> {try}++ ."\n";
					# $work_mysql_proxy -> set_proxy_try ($lwp_proxy -> {hash}, $lwp_proxy -> {try});
					# $work_mysql_graber -> update_set_new ($url);
				# }
				
			} else {
				
				$work_mysql_graber -> update_set_fail ($url);
				
			}
			
		}
		
		my $sleep = Random ($sleep2, $sleep3); 
		sleep $sleep;	

		
		my $return = {};
		return $return;
	}
	
}





sub get_content_from_file {
	my $file = shift;
	my @file = ();
	
	# print $file ."\n";
	# open (my $fh, $file) or die;
	
	open (my $fh, '<:encoding(UTF-8)', $file) or die (print $file ."\n");
	while (<$fh>) {push (@file, $_);}
	close ($fh); 
	my $pattern = ''; my $str = join ($pattern, @file); 
	return $str;
}


sub get_base_path {
	use Cwd; 
	my $cwd = getcwd ();
	return $cwd;
}

sub put_content_to_file {
	my $content = shift;
	my $file = shift;
	open (my $fh, '>'. $file) or die ($!);
	my $written = syswrite $fh, $content, length ($content);
	close ($fh) or die $!;		
}	

sub utf8_to_win1251 {
	use Encode qw (encode decode); 
	my $str = shift;
	$str = encode ('cp1251', decode ('utf8', $str)); 
	return $str;
}

sub Random {
	my $from = shift;
	my $to = shift;
	my $random = $from + rand(($to - $from));
	return $random;
}


sub entities_decode {
	use HTML::Entities;
	my $str = shift;
	#перед отдачей модулю нужно сделать decode с любой кодировки
	$str = decode ('cp1251', $str);
	$str = decode_entities ($str);
	$str = encode ('cp1251', $str);
	return $str;
}

sub get_1 {
	
	my $url = 'http://www.asos.com/';
	my $method = 'GET';
	my $useragent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16';
	my $request = HTTP::Request -> new (
		$method => $url,
		[
			'User-Agent' => $useragent,
			'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
			'Accept-Language' => 'ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
			'Accept-Charset' => 'windows-1251,utf-8;q=0.7,*;q=0.7',
			# 'Referer' => $referer,
		]
	);

	my $file = getcwd () .'/html/get_1.html';
	my $response = $lwp -> request ($request, $file);
	print $response -> code  ."\t". $url ."\n";
	
	{
	
		my $url = 'http://www.asos.com/ru/?r=1&dcsref=';
		my $method = 'GET';
		my $useragent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16';
		my $request = HTTP::Request -> new (
			$method => $url,
			[
				'User-Agent' => $useragent,
				'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
				# 'Accept-Language' => 'ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
				# 'Accept-Charset' => 'windows-1251,utf-8;q=0.7,*;q=0.7',
				# 'Referer' => $referer,
			]
		);

		my $file = getcwd () .'/html/get_2.html';
		my $response = $lwp -> request ($request, $file);
		print $response -> code  ."\t". $url ."\n";
	
	
	}
	
	return 1;
}

sub login {
	my $url = 'http://www.eurobasket.com/news_system/ndverifikacijasub.asp';
	my $postdata = 'firstsec=1&email=is.fin.dept%40gmail.com&pwd=basket55&women=0&B1=Login';

	push (@{ $lwp->requests_redirectable }, 'POST');
	my $req = HTTP::Request -> new (
	'POST' => $url,
		[
			'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20100101 Firefox/11.0',
			'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
			'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
			'Referer' => 'http://basketball.eurobasket.com/player/Andrey-Vorontsevich/Russia/CSKA-Moscow/71366',
			'Content-Type' => 'application/x-www-form-urlencoded',
		]
	);

	$req -> content ($postdata);
	my $file = getcwd () .'/picture/login.html';
	my $res = $lwp -> request ($req, $file); 
	print $res -> code ."\t" . $url ."\n";
	
	my $sleep = Random ($sleep2, $sleep3); 
	sleep $sleep;		
}


sub get_date { 
	use  Date::Calc qw (Time_to_Date Date_to_Time);
	# my ($year,$month,$day, $hour,$min,$sec) = Time_to_Date(time());
	
	# my $time = shift;
	
	
	my @date = Time_to_Date(time());
	foreach (@date) {
		while (length ($_) < 2) {
			$_ = '0'.$_;
		}
	}
	
	my $str = $date[0] .'-'.$date[1].'-'.$date[2] .'_'.$date[3].':'.$date[4].':'.$date[5];
	return $str;
}

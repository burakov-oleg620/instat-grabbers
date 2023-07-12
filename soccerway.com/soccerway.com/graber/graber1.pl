#!/usr/bin/env perl
use strict;
use warnings;
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

use work_mysql_proxy;
use work_mysql_graber;
use work_for_content;

use write_text_file_mode_add;
use write_text_file_mode_rewrite; 
use read_text_file;

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI::Escape;
use HTML::TreeBuilder::XPath;
use LWP::Protocol::http;
use work_mysql_agregator;
use work_mysql_agregator2;
use URI::URL;
use utf8;


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
my $count_all = $read_inifile -> get ('count_all');	

#Создаем дескриптор на mysql соединение
my  $work_mysql_graber = work_mysql_graber -> new (
	$mysql_dbdriver,
	$mysql_host,
	$mysql_port,
	$mysql_user,
	$mysql_user_password,
	$mysql_base,
	$mysql_table
); 

#соединяемся с прокси таблицей
my  $work_mysql_proxy = work_mysql_proxy -> new (
	$mysql_dbdriver,
	$mysql_host,
	$mysql_port,
	$mysql_user,
	$mysql_user_password,
	$mysql_base,
	$mysql_table. '_proxy',	
); 

# ситуация с прокси
my $queue_job_proxy = Thread::Queue->new ();
my $lwp_proxy = undef; #глобальная переменная, содержащая данные о прокси
if ($read_inifile -> {proxy_set} == 1) {
	
	$work_mysql_proxy -> drop_table (); 
	$work_mysql_proxy -> create_table (); 
	$work_mysql_proxy -> clear_proxy ($read_inifile -> {proxy_clear}, $read_inifile -> {proxy_try_max});
	$work_mysql_proxy -> get_proxy_from_service (); 
}	


# #Создаем дескриптор на mysql соединение
# my $work_mysql_agregator = work_mysql_agregator -> new (
	# $mysql_dbdriver,
	# $mysql_host,
	# $mysql_port,
	# $mysql_user,
	# $mysql_user_password,
	# $mysql_base,
	# $read_inifile -> {agregator}
# ); 

# $work_mysql_agregator -> drop ();		
# $work_mysql_agregator -> create ();		
# $work_mysql_agregator -> clear ($read_inifile -> {clear_agregator});		

# #Создаем дескриптор на mysql соединение
# my $work_mysql_agregator2 = work_mysql_agregator2 -> new (
	# $mysql_dbdriver,
	# $mysql_host,
	# $mysql_port,
	# $mysql_user,
	# $mysql_user_password,
	# $mysql_base,
	# $read_inifile -> {agregator2}
# ); 

# $work_mysql_agregator2 -> drop ();		
# $work_mysql_agregator2 -> create ();		
# $work_mysql_agregator2 -> clear ($read_inifile -> {clear_agregator});		

my @global = ();
my @proxy = (); 
my @useragent = (); 

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


#создаю экземпляр броузера
my $lwp = undef;
$lwp = LWP::UserAgent -> new ();
$lwp -> cookie_jar (HTTP::Cookies->new ());
$lwp -> agent ('Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16');
$lwp -> timeout (60);
# $lwp -> proxy ('http', 'http://127.0.0.1:8080');

my %proxy = ();

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
	}
	
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

# login ();
# {
	# my $sleep = Random ($sleep2, $sleep3); 
	# sleep $sleep;		
# }

# get_1 ();

# {
	# my $sleep = Random ($sleep2, $sleep3); 
	# sleep $sleep;		
# }

# start_first ();

work_thread3 (); #делает NEW из WORK
work_thread1 (); #забираю првичные ссылки из массива

while (scalar (@global) > 0) {
	my $str = shift (@global); 
	work_thread2 ($str); 
	work_thread1 (); #добавляю ссылки в глобальный массив из БД
}



sub start_first {
	
	my $read_xml = read_xml -> new ('select1.xml');
	my $xml = $read_xml -> get ();
	
	foreach (@$xml) {
		
		my $method = 'GET'; 
		my $url = $_->{url}; 
		my $referer = $_->{referer}; 
			
		my $type = 'html';
		my $str_for_content = $_->{str_for_content}; 
		
		$work_mysql_graber -> insert_ignore (
			$method, 
			$url,
			$referer,
			$type, 
			$str_for_content
		); 						
		
		# Не делаю ссылки new при апе
		# $work_mysql_graber -> update_set_new ($url);
	}
}

sub work_thread1 {
	my $array = $work_mysql_graber -> select_all_update_work ($threads_all);
	if (scalar (@$array) > 0) {
		foreach (@$array) {
			push (@global,$_)
		}
	}
}


sub work_thread2 {
	my $job = shift;
	
	my $hash = $job -> {hash};	
	my $method = $job -> {method};	
	my $url = $job -> {url};	
	my $referer = $job -> {referer};	
	my $file = $job -> {file};	
	my $type = $job -> {type};	
	my $str_for_content = $job -> {str_for_content};	
	
	my $create_type_workdir = create_type_workdir -> new ($type);
	my $type_workdir = $create_type_workdir -> do ();
	$file = $type_workdir.'/'.$file;
	
	my $content1 = get_content_from_url ($job);
	if (defined $content1) {
		my $content2 = $content1; 
	
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
				my $pattern1 = '(<table class="matches date_matches grouped.+?</table>)';
				my $work_for_content = work_for_content -> new ($content2); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;										
						
						my $pattern1 = '(<th class="competition-link">.+?</th>)';
						my $work_for_content = work_for_content -> new ($_); 
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
										
										my $uri = URI::URL-> new( $_, $job -> {url});
										my $url = $uri->abs;
										my $method = 'GET';
										my $type = 'html';
										my $str_for_content = $job -> {str_for_content};
										
										# $work_mysql_graber -> insert_ignore (
											# $method, 
											# $url,
											# $referer,
											# $type, 
											# $str_for_content
										# ); 
									}
								}
							}
						}
					}
				}		
				
				#генерация JSON ссылок
				$pattern1 = '(<tr class="group-head clickable.+?</tr>)';
				$work_for_content = work_for_content -> new ($content2); 
				$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						my $begin = 'http://int.soccerway.com/a/block_date_matches?block_id=page_matches_1_block_date_matches_1';
						my $action = 'showMatches';
						my $stage_value = undef;
						my $callback_params = undef;
						my $params = undef;
						
						
						my $pattern1 = 'stage-value="(.+?)"';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								$stage_value = $_;
							}
						}
								
						$pattern1 = 'var block = new GroupedMatchesBlock(.+?)block.registerForCallbacks';
						$work_for_content = work_for_content -> new ($content2); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								
								my $pattern1 = '(\{"bookmaker_urls".+?)\);';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ =~ s/\\//g;
										
										my $str = ', "stage-value":"'.$stage_value.'"';
										$_ =~ s/\}$/$str}/;
										$callback_params = $_;
									}
								}
							}
						}
								
								
						$pattern1 = 'id="date_matches-(\d+?)"';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								$params = '{"competition_id":'.$_.'}';
							}
						}
						
						my $url = 
						$begin .'&'.
						'callback_params='.uri_escape ($callback_params) .'&'.
						'action=showMatches' .'&'.
						'params='.uri_escape ($params);
						
						my $method = 'GET';
						my $type = 'html';
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
				
				$pattern1 = '\{"commands":';
				if ($content2 =~ /$pattern1/) {
				
					$content2 =~ s/\\//g;
					
					my $pattern1 = 'href="(.+?)"';
					my $work_for_content = work_for_content -> new ($content2); 
					my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;										
							$_ =~ s/\\//g;
							
							my $pattern1 = '/matches/';
							if ($_ =~ /$pattern1/) {
								$_ =~ s/\?.+$//;
								$_ =~ s/\#.+$//;
							
								my $uri = URI::URL-> new( $_, $job -> {url});
								my $url = $uri->abs;
								my $method = 'GET';
								my $type = 'medim';
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

				
				#matches
				$pattern1 = '(<tr class="even.+?</tr>)';
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
								
								my $pattern1 = '/matches/';								
								if ($_ =~ /$pattern1/) {
									
									$_ =~ s/\?.+$//;
									$_ =~ s/\#.+$//;
								
									my $uri = URI::URL-> new( $_, $job -> {url});
									my $url = $uri->abs;
									my $method = 'GET';
									my $type = 'medim';
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



			
			# #ссылки на матчи в competition
			# #пока отключили
			# $pattern1 = '(<table class="matches.+?</table>)';
			# $work_for_content = work_for_content -> new ($content2); 
			# $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
			# if (defined $work_for_content_result -> [0]) {
				# foreach (@$work_for_content_result) {		
					# my $clear_str = clear_str -> new ($_);
					# $_ = $clear_str -> delete_4 ();
					# $clear_str = undef;										
					
					# my $pattern1 = '(<td class="score-time.+?</td>)';
					# my $work_for_content = work_for_content -> new ($_); 
					# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					# if (defined $work_for_content_result -> [0]) {
						# foreach (@$work_for_content_result) {		
							# my $clear_str = clear_str -> new ($_);
							# $_ = $clear_str -> delete_4 ();
							# $clear_str = undef;										
					
							# my $pattern1 = 'href="(.+?)"';
							# my $work_for_content = work_for_content -> new ($_); 
							# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							# if (defined $work_for_content_result -> [0]) {
								# foreach (@$work_for_content_result) {		
									# my $clear_str = clear_str -> new ($_);
									# $_ = $clear_str -> delete_4 ();
									# $clear_str = undef;															
									# $_ =~ s/\?.+$//;
									
									# my $uri = URI::URL-> new( $_, $job -> {url});
									# my $url = $uri->abs;
									# my $method = 'GET';
									# my $type = 'medim';
									# my $str_for_content = $job -> {str_for_content};
									# # my $referer = $job -> {str_for_content};
									
									# $work_mysql_graber -> insert_ignore (
										# $method, 
										# $url,
										# $referer,
										# $type, 
										# $str_for_content
									# ); 
								# }
							# }
						# }
					# }
				# }
			# }		

			
			
			
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
				
			} #if html			
			
			
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
								
								my $pattern1 = '/players/';
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
			
			
		} else {
			#если файла нету
			$work_mysql_graber -> update_set_fail ();
		}
	}

}

sub work_thread3 {
	$work_mysql_graber -> update_set_new_if_work ();
}


sub get_content_from_url {
	my $job = shift;
	
	my $method = $job -> {method};
	my $url = $job -> {url};;
	my $referer = $job -> {referer};;
	my $file = $job->{type}.'/'.$job -> {file};
	
	my $content = undef;	
	my $useragent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16';
	
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
			
			# if ($read_inifile -> {get_proxy_from_service} == 1) {
				# $work_mysql_proxy -> drop_table (); 
				# $work_mysql_proxy -> create_table (); 
				# $work_mysql_proxy -> clear_proxy ($read_inifile -> {proxy_clear}, $read_inifile -> {proxy_try_max});
				# $work_mysql_proxy -> get_proxy_from_service (); 
			# }
			
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
			
			if ($lwp_proxy = $queue_job_proxy -> dequeue_nb ())  {
				# print '$lwp_proxy -> {address} = '. $lwp_proxy -> {address} ."\n";
				
				#удаление из контролирующего прокси хеша
				if (exists ($proxy {$lwp_proxy -> {hash}})) {
					delete $proxy {$lwp_proxy -> {hash}};
				}
				
				# print 'scalar proxy pool = '. $queue_job_proxy -> pending() . "\n";
				# print $lwp_proxy -> {address} ."\n";
				$lwp -> proxy (['http', 'https'], 'http://'.$lwp_proxy -> {address});
			}
		}
	}

	
	my $req = HTTP::Request -> new (
		$method => $url,
		[	
			'User-Agent' => $useragent,
			'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
			'Accept-Language' => 'ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
			'Accept-Charset' => 'windows-1251,utf-8;q=0.7,*;q=0.7',
			'Referer' => $referer, 
		]
	);


	my $response = $lwp -> request ($req, $file);
	print $response -> code ."\t". $url. "\n";
	
	if ($response -> code == 200) {
		$work_mysql_graber -> update_set_pass ($url); 
	} else {
		
		if ($read_inifile -> {proxy_set} == 1) {
			# $lwp_proxy -> {try}++; #ставлю прокси попытку неудачную
			# $work_mysql_proxy -> set_proxy_try ($lwp_proxy -> {hash}, $lwp_proxy -> {try});
			$work_mysql_graber -> update_set_new ($url); 
			
		} else {
			$work_mysql_graber -> update_set_fail ($url);
		}		
	}
	
	my $sleep = Random ($sleep2, $sleep3); 
	sleep $sleep;	
}


sub get_content_from_file {
	my $file = shift;
	my @file = ();
	open (my $fh, $file) or die;
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
	open (my $fh, '>'.$file) or die;
	print $fh $content; 
	close ($fh);
}

sub utf8_to_win1251 {
	use Encode qw (encode decode); 
	my $str = shift;
	$str = encode ('cp1251', decode ('utf8', $str)); 
	return $str;
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


sub Random {
	my $from = shift;
	my $to = shift;
	my $random = $from + rand(($to - $from));
	return $random;
}


sub login {
	
	my $url = 'http://www.superjob.ru/user/login';
	my $postdata = 'returnUrl=http%3A%2F%2Fwww.superjob.ru%2Fvacancy%2Fsearch%2F%3Fdetail_search%3D1%26sbmit%3D1%26keywords%255B0%255D%255Bkeys%255D%3D%26period%3D0%26exclude_words%3D%26place_of_work%3D0%26t%255B%255D%3D4%26%3D%26catalogues%3D11%26pay1%3D%26pay2%3D%26type_of_work%3D0%26age%3D%26pol%3D0%26education%3D0%26experience%3D0%26lng%3D0%26agency%3D1%26%3D%25D0%259D%25D0%25B0%25D0%25B9%25D1%2582%25D0%25B8&LoginForm%5Blogin%5D='.uri_escape(encode ('utf8', decode ('cp1251', $read_inifile -> {user}))).'&LoginForm%5Bpassword%5D='.uri_escape(encode ('utf8', decode ('cp1251', $read_inifile -> {password})));
	push (@{ $lwp->requests_redirectable }, 'POST');
	my $req = HTTP::Request -> new (
	'POST' => $url,
		[
			'Host' => 'www.superjob.ru',
			'User-Agent' => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.17) Gecko/20110420 Firefox/3.6.17 (.NET CLR 3.5.30729)',
			'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
			'Accept-Language' => 'ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
			'Referer' => 'http://www.superjob.ru/vacancy/search/?detail_search=1&sbmit=1&keywords%5B0%5D%5Bkeys%5D=&period=0&exclude_words=&place_of_work=0&t%5B%5D=4&=&catalogues=11&pay1=&pay2=&type_of_work=0&age=&pol=0&education=0&experience=0&lng=0&agency=1&=%D0%9D%D0%B0%D0%B9%D1%82%D0%B8',
			'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
			'X-Requested-With' => 'XMLHttpRequest',
		]
	);
	$req -> content ($postdata);
	my $file = getcwd () .'/txt/login.html';
	my $res = $lwp -> request ($req, $file); 
	print $res -> code ."\t".$url."\n";
	
	return 1;
	
}

# POST http://www.superjob.ru/user/login HTTP/1.1
# Host: www.superjob.ru
# User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:35.0) Gecko/20100101 Firefox/35.0
# Accept: application/json, text/javascript, */*; q=0.01
# Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3
# Content-Type: application/x-www-form-urlencoded; charset=UTF-8
# X-Requested-With: XMLHttpRequest
# Referer: http://www.superjob.ru/vacancy/search/?detail_search=1&sbmit=1&keywords%5B0%5D%5Bkeys%5D=&period=0&exclude_words=&place_of_work=0&t%5B%5D=4&=&catalogues=11&pay1=&pay2=&type_of_work=0&age=&pol=0&education=0&experience=0&lng=0&agency=1&=%D0%9D%D0%B0%D0%B9%D1%82%D0%B8
# Content-Length: 469
# Cookie: testcookie=1421440895; _wss=54bc0827; _ws=54b9777f01addd500a0a01306d2709fcbc7223c50354bc0c3a0162ba881a2638fc29f8f3c3072946ec8bed2b0c; _ga=GA1.2.861983719.1421440894; ctown=750; uechat_34349_pages_count=4; uechat_34349_first_time=1421608994487; _ym_visorc_1605911=b; sjvid=a19b11a16da7a5c9; __unam=4c9247b-14afe7fdbf7-6ede7e17-2; _gat=1; uechat_34349_mode=0
# Connection: keep-alive
# Pragma: no-cache
# Cache-Control: no-cache

# returnUrl=http%3A%2F%2Fwww.superjob.ru%2Fvacancy%2Fsearch%2F%3Fdetail_search%3D1%26sbmit%3D1%26keywords%255B0%255D%255Bkeys%255D%3D%26period%3D0%26exclude_words%3D%26place_of_work%3D0%26t%255B%255D%3D4%26%3D%26catalogues%3D11%26pay1%3D%26pay2%3D%26type_of_work%3D0%26age%3D%26pol%3D0%26education%3D0%26experience%3D0%26lng%3D0%26agency%3D1%26%3D%25D0%259D%25D0%25B0%25D0%25B9%25D1%2582%25D0%25B8&LoginForm%5Blogin%5D=hr5653200%40yandex.ru&LoginForm%5Bpassword%5D=2710tj

sub get_1 {
	
	my $url = 'http://www.superjob.ru';
	my $req = HTTP::Request -> new (
		'GET' => $url,
		[	
			'User-Agent' => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.17) Gecko/20110420 Firefox/3.6.17 (.NET CLR 3.5.30729)',
			'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
			'Accept-Language' => 'ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
			'Accept-Charset' => 'windows-1251,utf-8;q=0.7,*;q=0.7',
		]
	);

	my $file = getcwd () .'/txt/001.html';
	my $response = $lwp -> request ($req, $file);	
	print $response -> code ."\t".$url."\n";
	
	return 1;
}




sub get_phone {
	my $insert = shift;
	
	my $method = 'GET';
	my $url = 'http://minsk.mn.olx.by/ajax/misc/contact/phone/'.$insert ->{phone}.'/';
	my $useragent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16';
	
	# if (-f 'proxy_list.txt') {
		# if (scalar (@proxy) == 0) {
			# my $read_select2 = read_select2 -> new ('proxy_list.txt'); 
			# @proxy = $read_select2 -> get ();
			# @proxy = shuffle (@proxy); 
		# }
		
		# my $lwp_proxy = shift (@proxy);
		# $lwp -> proxy ('http', 'http://'.$lwp_proxy);		
	# }
	
	# if (-f 'useragent.txt') {
		# if (scalar (@useragent) == 0) {
			# my $read_select2 = read_select2 -> new ('useragent.txt'); 
			# @useragent = $read_select2 -> get ();
			# @useragent = shuffle (@useragent); 
		# }
		# $useragent = shift (@useragent);
	# }

	my $req = HTTP::Request -> new (
		$method => $url,
		[
			'Host' => 'minsk.mn.olx.by',
			'User-Agent' => $useragent,
			'Accept' => 'Accept: text/javascript, text/html, application/xml, text/xml, */*',
			'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
			'Accept-Language' => 'Accept-Language: ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
			'X-Requested-With' =>  'XMLHttpRequest',
			'Referer' => $insert -> {referer},
		]
	);

	my $file = getcwd () .'/media/'. $insert -> {phone} .'.html';
	my $response = $lwp -> request ($req, $file);
	print '*phone*' ."\t". $response -> code ."\t". $url. "\n";
	
	
	#проверка адреса кратинки в файле и получение ее.!!
	if (-f $file) {
		my $content1 = get_content_from_file ($file);
		$content1 =~ s/\n//g;
		
		my $pattern1 = '{"value":"(.+?)"}';
		my $work_for_content = work_for_content -> new ($content1); 
		my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;				
				
				my $pattern1 = '<img.+?src.+?"(.+?)"';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;			
						
						$_ =~ s/\\//g;
						my $url = $_;
						my $method = 'GET';
						
						my $imgfile = $url;
						$imgfile =~ s/^.+phoneimage\///;
						$imgfile =~ s/\/.+$//;
						
						my $req = HTTP::Request -> new (
							$method => $url,
							[
								'User-Agent' => $useragent,
								'Accept' => 'Accept: text/javascript, text/html, application/xml, text/xml, */*',
								'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
								'Accept-Language' => 'Accept-Language: ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
								'Referer' => $insert -> {referer},
							]
						);

						my $file = getcwd () .'/picture/'. $imgfile;
						my $response = $lwp -> request ($req, $file);
						print '*img_phone*' ."\t". $response -> code ."\t". $url. "\n";
						
					}
				}
			}
		}
	}
	
	
	my $sleep = Random ($sleep2, $sleep3); 
	sleep $sleep;		
}


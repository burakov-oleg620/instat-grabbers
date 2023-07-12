#!/usr/bin/env perl
#специальная статистика Стасу.

use strict;
use warnings;
use Cwd;
use lib getcwd ();

use locale;
use dir_scan_recurce;
use read_text_file; 
use write_text_file_mode_rewrite; 
use clear_str;
use delete_duplicate_from_array; 
use read_inifile;
use url_to_file;
use Encode qw (encode decode);
use Tie::IxHash;
use work_for_content;
use File::Path;
use File::Copy;
use MD5;
use work_mysql_agregator;
use utf8;
use JSON::XS;
use Data::Dumper;

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI::Escape;
use HTML::TreeBuilder::XPath;
use URI::URL;
use work_mysql_graber;
use work_mysql_agregator;
use work_mysql_agregator2;


sub get_base_path {
	use Cwd; 
	my $cwd = getcwd ();
	return $cwd;
}

#„итаю установки из ини файла
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

my $workdir1 = get_base_path.'/txt'; 
my $workdir2 = get_base_path.'/picture'; 
my $workdir4 = get_base_path.'/pictura'; 
my $workdir3 = get_base_path.'/out'; 

my $file1 = $workdir1.'/write_text_file_mode_rewrite6.xls'; 
my $file2 = $workdir1.'/write_text_file_mode_rewrite666.xls'; 

#создаю экземпл¤р броузера
my $lwp = undef;
$lwp = LWP::UserAgent -> new ();
$lwp -> cookie_jar (HTTP::Cookies->new ());
$lwp -> agent ('Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16');
$lwp -> timeout (60);
# $lwp -> proxy ('http', 'http://127.0.0.1:8080');



# —оздаем дескриптор на mysql соединение
my $work_mysql_agregator2 = work_mysql_agregator2 -> new (
	$mysql_dbdriver,
	$mysql_host,
	$mysql_port,
	$mysql_user,
	$mysql_user_password,
	$mysql_base,
	$read_inifile -> {agregator}
); 

if ($read_inifile -> {clear_agregator} == 1) {
	$work_mysql_agregator2 -> drop ();
}
$work_mysql_agregator2 -> create ();		


#Cоздаем дескриптор на mysql соединение
my $work_mysql_graber = work_mysql_graber -> new (
	$mysql_dbdriver,
	$mysql_host,
	$mysql_port,
	$mysql_user,
	$mysql_user_password,
	$mysql_base,
	$mysql_table
); 


my $count = 0;
my @read_text_file1 = ();
my %header = (); 
tie (%header, 'Tie::IxHash'); #чтобы было по мере добавлени¤

my $date = undef;
my $insert2 = {};
tie (%$insert2, 'Tie::IxHash'); #чтобы было по мере добавлени¤

{
	my $workdir1 = getcwd () .'/xls';
	my $dir_scan_recurce = dir_scan_recurce -> new ($workdir1);
	while (my $file1 = $dir_scan_recurce -> get_file ()) {
		print ++$count."\n";
		
		my $pattern = 'xls$';
		if ($file1 =~ /$pattern/) {	
			
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
						
						my $pattern1 = '/matches/(.+)/';
						my $work_for_content = work_for_content -> new ($temp1 -> [0]); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								
								my @temp = split (/\//, $_);
								if (scalar (@temp) == 3) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
									}
									
									$insert2 -> {date} = $temp[0].'-'.$temp[1].'-'.$temp[2];
								}
							}
						}
					}
				}
			}
		}
	}

}


#количество ссылок в статусе pass
my $sql = 'select COUNT(*) from '.$mysql_table.' where state = "pass"';
my $return = $work_mysql_graber -> select_count ($sql);
$insert2 -> {count_url_pass} = $return;

#количество ссылок в статусе fail
$sql = 'select COUNT(*) from '.$mysql_table.' where state = "fail"';
$return = $work_mysql_graber -> select_count ($sql);
$insert2 -> {count_url_fail} = $return;

#количество ссылок в статусе new
$sql = 'select COUNT(*) from '.$mysql_table.' where state = "new"';
$return = $work_mysql_graber -> select_count ($sql);
$insert2 -> {count_url_new} = $return;

#количество сграбленных матчей
$sql = 'select COUNT(*) from '.$mysql_table.' where state = "pass" and type = "medim"';
$return = $work_mysql_graber -> select_count ($sql);
$insert2 -> {count_grab_matches} = $return;

my $xml = [];
{
	
	my $workdir1 = getcwd () .'/out';
	my $dir_scan_recurce = dir_scan_recurce -> new ($workdir1);
	while (my $file1 = $dir_scan_recurce -> get_file ()) {
		print ++$count."\n";
		
		my $pattern = 'xml$';
		if ($file1 =~ /$pattern/) {	

			$file1 =~ s/^.+\///;
			my $pattern1 = '(\d+)\.xml';
			my $work_for_content = work_for_content -> new ($file1); 
			my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
			if (defined $work_for_content_result -> [0]) {
				foreach (@$work_for_content_result) {		
					my $clear_str = clear_str -> new ($_);
					$_ = $clear_str -> delete_3_s ();
					$_ = $clear_str -> delete_4 ();
					$clear_str = undef;		
			
					push (@$xml, $_);
				}
			}
		}
	}
	
	$insert2 -> {count_xml} = scalar (@$xml);
	$insert2 -> {id_xml} = $xml;
}


my $match_parsed_id = [];
my $read_text_file1 = read_text_file -> new ($file1); 
while (my $str1 = $read_text_file1 -> get_str ()) {
	print ++$count."\n";
	
	if ($str1 =~ /\t/) {
		my $temp1 = []; my $pattern1 = "\t"; @$temp1 = split ($pattern1, $str1); 
		
		# print '*'.scalar (@$temp1)."\n";
		if (scalar (@$temp1 > 1)) {			
			
			foreach (@$temp1) {
				my $clear_str = clear_str -> new ($_); 
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;
			}
			
			# my $temp2 = [];
			# my $time = time ();
			# push (@$temp2, $time);
			# push (@$temp2, get_date ($time));
			# push (@$temp2, get_time ($time));
			# push (@$temp2, $temp1 -> [0]);
			
			{
				my $match_id = $temp1 -> [0];	
				$match_id =~ s/\?.+$//;
				my $pattern1 = '/(\d+)/$';
				my $work_for_content = work_for_content -> new ($match_id); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_3_s ();
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						# $_ = entities_encode ($_);
						push (@$match_parsed_id, $_);
					}
				}
			}
		}
	}
}

$read_text_file1 = undef;

$insert2 -> {count_pars_matches} = scalar (@$match_parsed_id);
$insert2 -> {id_pars_matches} = $match_parsed_id;


$insert2 -> {count_matches_where_not_players} = $insert2 -> {count_pars_matches} - $insert2 -> {count_xml};


my $json = encode_json ($insert2);
print $json ."\n";

my $md5 = MD5 -> new ();
my $hash = $md5 -> hexhash ($insert2 -> {date});
$md5 = undef;

$insert2 ->  {hash} = $hash;
$insert2 ->  {json} = $json;
$insert2 -> {time} = time (); 
$insert2 -> {id_xml} = join (',', @$xml);
$insert2 -> {id_pars_matches} = join (',', @$match_parsed_id);

foreach (keys (%$insert2)) {
	print $_ ."\t" .$insert2 -> {$_} ."\n";
	# $insert2 -> {$_} = decode ('utf8', $insert2 -> {$_});
}


my $work_mysql_agregator_result = $work_mysql_agregator2 -> select ($insert2); 
if (scalar (@$work_mysql_agregator_result) > 0) {
	$work_mysql_agregator2 -> update ($insert2); 

} else {
	
	#вставляем урл в агрегтор (чтобы больше его не просить.
	$work_mysql_agregator2 -> insert ($insert2); 
}

# my %file1 = ();
# my $read_text_file2 = read_text_file -> new ($file2); 
# while (my $str1 = $read_text_file2 -> get_str ()) {
	# print ++$count."\n";
	
	# if ($str1 =~ /\t/) {
		# my $temp1 = []; my $pattern1 = "\t"; @$temp1 = split ($pattern1, $str1); 
		
		# # print scalar (@$temp1) ."\n";
		# if (scalar (@$temp1 == 2)) {			
			# foreach (@$temp1) {
				# my $clear_str = clear_str -> new ($_); 
				# $_ = $clear_str -> delete_4 ();
				# $clear_str = undef;
			# }
			
			# $file1 {$temp1 -> [0]} = $temp1;
		# }
	# }
# }
# $read_text_file2 = undef;

# my @global = ();

# my $match_id = undef;
# my $read_text_file1 = read_text_file -> new ($file1); 
# while (my $str1 = $read_text_file1 -> get_str ()) {
	# print ++$count."\n";
	
	# if ($str1 =~ /\t/) {
		# my $temp1 = []; my $pattern1 = "\t"; @$temp1 = split ($pattern1, $str1); 
		
		# # print '*'.scalar (@$temp1)."\n";
		# if (scalar (@$temp1 > 1)) {			
			
			# foreach (@$temp1) {
				# my $clear_str = clear_str -> new ($_); 
				# $_ = $clear_str -> delete_4 ();
				# $clear_str = undef;
			# }
			
			# my $temp2 = [];
			
			
			# my $time = time ();
			# push (@$temp2, $time);
			
			# push (@$temp2, get_date ($time));
			# push (@$temp2, get_time ($time));
			
			# push (@$temp2, $temp1 -> [0]);
			
			# {
				# $match_id = $temp1 -> [0];	
				# $match_id =~ s/\?.+$//;
				# my $pattern1 = '/(\d+)/$';
				# my $work_for_content = work_for_content -> new ($match_id); 
				# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				# if (defined $work_for_content_result -> [0]) {
					# foreach (@$work_for_content_result) {		
						# my $clear_str = clear_str -> new ($_);
						# $_ = $clear_str -> delete_3_s ();
						# $_ = $clear_str -> delete_4 ();
						# $clear_str = undef;		
						# $_ = entities_encode ($_);
						# $match_id = $_;
						# push (@$temp2, $_);
						# push (@global, $_);
					# }
				# }
			# }
			
			# push (@$temp2, $temp1 -> [11]);
			
			# if ($temp1 -> [0] ne '-') {				
				# my $str = join ("\t", @$temp2); 
				# # push (@read_text_file1, $str);
				# $header {$temp1 -> [0]} = $str
			# }
		# }
	# }
# }
# $read_text_file1 = undef;



# if (scalar (values (%header)) > 0) {
	# my $write_text_file_mode_rewrite = write_text_file_mode_rewrite -> new ($file2);
	# my @headers = (
		# 'unixtime',
		# 'date_now', 
		# 'time_now',
		
		# 'match_url',
		# 'match_id',
		# 'match_date',
		
	# ); 
	# $write_text_file_mode_rewrite -> put_str (join ("\t", @headers)."\n");
	# foreach (values (%header)) {
		# print ++$count."\n";
		# $write_text_file_mode_rewrite -> put_str ($_."\n");
	# }
	# $write_text_file_mode_rewrite = undef;
	
# } else {

	# my $write_text_file_mode_rewrite = write_text_file_mode_rewrite -> new ($file2);
	# $write_text_file_mode_rewrite -> put_str ('либо ничего нет, либо чтото пошло не так'."\n");
	# $write_text_file_mode_rewrite = undef;
# }


# {
	# my $time = time();
	# my $dir_scan_recurce = dir_scan_recurce -> new (getcwd () . '/txt');
	# while (my $file1 = $dir_scan_recurce -> get_file ()) {
		# print ++$count."\n";

		# my $pattern = 'write_text_file_mode_rewrite66.xls$';
		# if ($file1 =~ /$pattern/) {	
			# print $file1 ."\n";
			
			# my $file2 = $read_inifile -> {copy_path_log}.'/'.get_date ($time) .'_'.get_time ($time) .'.log.xls';
			# if (-f $file1 and -d $read_inifile -> {copy_path_log}) {
				# copy ($file1,$file2) or die;
			# }
		# }
	# }
	# $dir_scan_recurce = undef;
# }

# #посылаем информацию в базу
# my $dir_scan_recurce = dir_scan_recurce -> new ($workdir3);
# while (my $file1 = $dir_scan_recurce -> get_file ()) {
	# print ++$count."\n";
	
	# my $pattern = 'xml$';
	# if ($file1 =~ /$pattern/) {	
		
		# my $id = undef;
		# my $pattern1 = '/(\d+)\.xml';
		# my $work_for_content = work_for_content -> new ($file1); 
		# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		# if (defined $work_for_content_result -> [0]) {
			# foreach (@$work_for_content_result) {		
				# my $clear_str = clear_str -> new ($_);
				# $_ = $clear_str -> delete_3_s ();
				# $_ = $clear_str -> delete_4 ();
				# $clear_str = undef;		
				# $id = $_;
			# }
		# }
	
		# my $file2 = $id .'.xml';
		# $file2 = $read_inifile -> {copy_path}.'/'.$file2;
		
		# if (-f $file1 and -d $read_inifile -> {copy_path}) {
			# copy ($file1,$file2) or die;
			
			
			# #проверка на то, что сигнал нужно посылать в базу
			# # если {"@ret":0} - значит я не посылаю в базу сигнал, что готов XML
			# # если {"@ret":1} - значит посылаю
			
			# my $ret = 'nok';
			# {
				# my $insert = {};
				# tie (%$insert, 'Tie::IxHash'); #чтобы было по мере добавлени¤

				# $insert -> {server} = 'instatfootball.com';
				# $insert -> {base} = 'football';
				# $insert -> {login} = 'football_parser';
				# $insert -> {pass} = 'MeD9ZUbzuRTO';
				# $insert -> {proc} = 'prc_gsm_check_match_need';
				# $insert -> {params} -> {'@ret'} = [];
				# push (@{$insert -> {params} -> {'@ret'}}, 'in');
				# push (@{$insert -> {params} -> {'@ret'}}, 'out');
				# $insert -> {params} -> {'@gsm_match_id'} = [];
				# push (@{$insert -> {params} -> {'@gsm_match_id'}}, $id);
				# push (@{$insert -> {params} -> {'@gsm_match_id'}}, 'in');
				
				# my $json = encode_json ($insert);
				# print $json ."\n";
				# my $post_content = post ($json);
				# # {"server":"instatfootball.com","base":"football","login":"football_parser","pass":"some_password","proc":"prc_gsm_check_match_need","params":{"@ret":["int","out"],"@gsm_match_id":["2780191","in"]}}
				
				
				# my $pattern1 = '("\@ret":1)';
				# my $work_for_content = work_for_content -> new ($post_content); 
				# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				# if (defined $work_for_content_result -> [0]) {
					# foreach (@$work_for_content_result) {		
						# my $clear_str = clear_str -> new ($_);
						# $_ = $clear_str -> delete_4 ();
						# $clear_str = undef;		
						# $ret = 'ok';
					# }
				# }
			# }
			
			# if ($ret eq 'ok') {
				# my $insert = {};
				# tie (%$insert, 'Tie::IxHash'); #чтобы было по мере добавлени¤

				# $insert -> {server} = 'instatfootball.com';
				# # $insert -> {base} = 'football_dev';
				# $insert -> {base} = 'football';
				# $insert -> {login} = 'football_parser';
				# $insert -> {pass} = 'MeD9ZUbzuRTO';
				# $insert -> {proc} = 'parsing_save_f_parser_match_info';
				# $insert -> {params} -> {'@matches_id'} = [];

				# $insert -> {params} -> {'@ret'} = [];
				# push (@{$insert -> {params} -> {'@ret'}}, 'in');
				# push (@{$insert -> {params} -> {'@ret'}}, 'out');

				# $insert -> {params} -> {'@msg'} = [];
				# push (@{$insert -> {params} -> {'@msg'}}, 'varchar(500)');
				# push (@{$insert -> {params} -> {'@msg'}}, 'out');
				
				# # push (@{$insert -> {params} -> {'@matches_id'}}, join (',', @global));
				# push (@{$insert -> {params} -> {'@matches_id'}}, $id);
				# push (@{$insert -> {params} -> {'@matches_id'}}, 'in');
				
				# my $json = encode_json ($insert);
				# print $json ."\n";
				# post ($json);
			# }
			
		# }
	# }
# }



sub good_count {
	my $str = shift;
	while (length ($str) < 5) {
		$str = '0'.$str;
	}
	return $str;
}

sub get_date { 
	my $str = shift;
	use  Date::Calc qw (Time_to_Date Date_to_Time);
	# my ($year,$month,$day, $hour,$min,$sec) = Time_to_Date($str);
	my @date1 = Time_to_Date($str);
	my @date2 = ();
	
	push (@date2, $date1[0]);
	push (@date2, $date1[1]);
	push (@date2, $date1[2]);
	
	foreach (@date2) {
		while (length ($_) < 2) {
			$_ = '0'.$_;
		}
	}
	# my $str = $year .'-'.$month.'-'.$day .' '.$hour.':'.$min.':'.$sec;
	# $str = $year .'-'.$month.'-'.$day;
	$str = join ('-', @date2);
	return $str;
}

sub get_time { 
	my $str = shift;
	use  Date::Calc qw (Time_to_Date Date_to_Time);
	my ($year,$month,$day, $hour,$min,$sec) = Time_to_Date($str);
	my @date1 = Time_to_Date($str);
	my @date2 = ();
	push (@date2, $date1[3]);
	push (@date2, $date1[4]);
	push (@date2, $date1[5]);
	foreach (@date2) {
		while (length ($_) < 2) {
			$_ = '0'.$_;
		}
	}
	
	# my $str = $year .'-'.$month.'-'.$day .' '.$hour.':'.$min.':'.$sec;
	# $str = $hour.':'.$min.':'.$sec;
	
	$str = join ('-', @date2);
	
	return $str;
}


sub entities_decode {
	use HTML::Entities;
	my $str = shift;
	#перед отдачей модулю нужно сделать decode с любой кодировки
	# $str = decode ('cp1251', $str);
	$str = decode_entities ($str);
	# $str = encode ('cp1251', $str);
	return $str;
}

sub entities_encode {
	use HTML::Entities;
	my $str = shift;
	$str = encode_entities ($str, '<>"\'&');
	return $str;
}

sub post {
	my $postdata = shift;
	
	# $postdata = uri_escape ($postdata);
	# print $postdata ."\n";
	
	my $url = 'http://service.instatfootball.com/ws.php';
	# my $postdata = 'firstsec=1&email=is.fin.dept%40gmail.com&pwd=basket55&women=0&B1=Login';

	push (@{ $lwp->requests_redirectable }, 'POST');
	my $req = HTTP::Request -> new (
	'POST' => $url,
		[
			# 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20100101 Firefox/11.0',
			# 'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
			# 'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
			# 'Referer' => 'http://basketball.eurobasket.com/player/Andrey-Vorontsevich/Russia/CSKA-Moscow/71366',
			# 'Content-Type' => 'application/x-www-form-urlencoded',
			
			'Accept' => 'application/json',
			'Content-Type' => 'application/json',
		]
	);
	
	$req -> content ($postdata);
	my $file = getcwd () .'/txt/post.html';
	# my $res = $lwp -> request ($req, $file); 
	my $res = $lwp -> request ($req); 
	print $res -> code ."\t" . $url ."\n";
	
	print $res -> content ."\n";
	my $content = $res -> content;
	$content =~ s/\r+|\n+|\t+//g;
	
	my $sleep = Random ($sleep2, $sleep3); 
	sleep $sleep;		
	return $content;
}

sub post2 {
	my $postdata = shift;
	
	# UpdateFootballScoreswayTeams
	# UpdateFootballScoreswayPlayers
	# UpdateFootballScoreswayCoaches
	
	my $key_import2 = '22812357092873478234729374';
    my $url = 'http://data.instatfootball.tv/api/import2?key='.$key_import2.'&method=UpdateFootballScoreswayPlayers';	

	push (@{ $lwp->requests_redirectable }, 'POST');
	my $req = HTTP::Request -> new (
	'POST' => $url,
		[
			# 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20100101 Firefox/11.0',
			# 'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
			# 'Referer' => 'http://basketball.eurobasket.com/player/Andrey-Vorontsevich/Russia/CSKA-Moscow/71366',
			# 'Content-Type' => 'application/json',
			
			'Accept' => '*/*',
			'Content-Type' => 'multipart/form-data; boundary=----------------------------4b5789fa8d3f',
			
		]
	);
	
	my $str = 
'------------------------------4b5789fa8d3f
Content-Disposition: form-data; name="json"

'.$postdata.'
------------------------------4b5789fa8d3f--';
	

	$req -> content ($str);
	
	my $file = getcwd () .'/txt/players.html';
	my $res = $lwp -> request ($req, $file); 
	print $res -> code ."\t" . $url ."\n";
	
	# my $sleep = Random ($sleep2, $sleep3); 
	# sleep $sleep;		
}


sub Random {
	my $from = shift;
	my $to = shift;
	my $random = $from + rand(($to - $from));
	return $random;
}

#!/usr/bin/env perl
#игроки
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
use JSON::XS;

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI::Escape;
use HTML::TreeBuilder::XPath;
use URI::URL;
# use utf8;

sub get_base_path {
	use Cwd; 
	my $cwd = getcwd ();
	return $cwd;
}

my $read_inifile = read_inifile -> new ('graber.ini'); 
my $host = $read_inifile -> get ('host');

#Читаю установки из ини файла
my $mysql_dbdriver = $read_inifile -> get ('mysql_dbdriver');
my $mysql_host = $read_inifile -> get ('mysql_host');
my $mysql_port = $read_inifile -> get ('mysql_port');
my $mysql_user = $read_inifile -> get ('mysql_user');
my $mysql_user_password = $read_inifile -> get ('mysql_user_password');
if ($mysql_user_password eq ' ') {$mysql_user_password = '';}
my $mysql_base = $read_inifile -> get ('mysql_base');
my $mysql_table = $read_inifile -> get ('mysql_table');

#создаю экземпляр броузера
my $lwp = undef;
$lwp = LWP::UserAgent -> new ();
$lwp -> cookie_jar (HTTP::Cookies->new ());
$lwp -> agent ('Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16');
$lwp -> timeout (60);
# $lwp -> proxy ('http', 'http://127.0.0.1:8080');


my $workdir1 = get_base_path.'/txt'; 
my $workdir2 = get_base_path.'/picture'; 
my $workdir3 = get_base_path.'/media'; 

my $file1 = $workdir1.'/write_text_file_mode_rewrite3.xls'; 
my $file2 = $workdir1.'/write_text_file_mode_rewrite2.xls'; 
my $file3 = $workdir1.'/write_text_file_mode_rewrite3.xls'; 


my $count = 0;
my @read_text_file1 = ();
my %header = (); 
tie (%header, 'Tie::IxHash'); #чтобы было по мере добавления

my $actual_date = undef;
my $workdir4 = getcwd () .'/xls';
my $dir_scan_recurce = dir_scan_recurce -> new ($workdir4);
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
				if (scalar (@$temp1) == 2 ){			
					print ++$count."\n";	
					
					foreach (@$temp1) {
						my $clear_str = clear_str -> new ($_); 
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;
					}
					
					if ($temp1 -> [0] =~ /matches\/(\d+)\/(\d+)\/(\d+)/) {
						$actual_date = $1 .'-'.$2.'-'.$3;
					}
				}
			}
		}
	}
}
$dir_scan_recurce = undef;


# my %file1 = ();
# my $read_text_file2 = read_text_file -> new ($file1); 
# while (my $str1 = $read_text_file2 -> get_str ()) {
	# print ++$count."\n";
	
	# if ($str1 =~ /\t/) {
		# my $temp1 = []; my $pattern1 = "\t"; @$temp1 = split ($pattern1, $str1); 
		
		# # print scalar (@$temp1) ."\n";
		# if (scalar (@$temp1 == 3)) {			
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
			
			my $insert = {};
			tie (%$insert, 'Tie::IxHash'); #чтобы было по мере добавления
			
			$insert -> {url} = $temp1 -> [0];
			$insert -> {id} = $temp1 -> [1];
			$insert -> {id_team} = $temp1 -> [2];
			$insert -> {name} = $temp1 -> [3];
			$insert -> {surname} = $temp1 -> [4];
			$insert -> {birthday} = $temp1 -> [5];
			$insert -> {age} = $temp1 -> [6];
			$insert -> {country} = $temp1 -> [7];
			$insert -> {place_of_birth} = $temp1 -> [8];
			$insert -> {nationality} = $temp1 -> [9];
			$insert -> {position} = $temp1 -> [10];
			$insert -> {height} = $temp1 -> [11];
			$insert -> {weight} = $temp1 -> [12];
			$insert -> {foot} = $temp1 -> [13];
			$insert -> {img} = $temp1 -> [14];
			$insert -> {dead} = $temp1 -> [15];
			
			if (defined ($actual_date)) {
				$insert -> {actual_date} = $actual_date;
			}  else {
				$insert -> {actual_date} = '1900-01-01';
			}
			
			foreach (keys (%$insert)) {
				if ($insert -> {$_} eq '-') {
					$insert -> {$_} = '';
				}
				$insert -> {$_} = decode ('utf8',$insert -> {$_});
			}
			
			my $a = [];
			push (@$a, $insert);
			
			my $json_str = encode_json ($a);
			print $json_str ."\n";
			
			post ($json_str);
			
		}
	}
}
$read_text_file1 = undef;


# my $delete_duplicate_from_array = delete_duplicate_from_array -> new (@read_text_file1);
# @read_text_file1 = $delete_duplicate_from_array -> do ();
# $delete_duplicate_from_array = undef;
# @read_text_file1 = sort (@read_text_file1);

# my $write_text_file_mode_rewrite = write_text_file_mode_rewrite -> new ($file3);

# my @headers = (
	# 'URL',
	# 'КОД',
	# 'НАИМЕНОВАНИЕ',
	# 'КАТЕГОРИЯ',
	# 'КАРТИНКА',
	# 'БРЕНД',
	# 'ХАРАКТЕРИСТИКИ',
	# 'ЦЕНА',
# ); 

# # $write_text_file_mode_rewrite -> put_str (join ("\t", @headers)."\n");

# foreach (@read_text_file1) {
	# print ++$count."\n";
	# $write_text_file_mode_rewrite -> put_str ($_."\n");
# }
# $write_text_file_mode_rewrite = undef;


sub post {
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

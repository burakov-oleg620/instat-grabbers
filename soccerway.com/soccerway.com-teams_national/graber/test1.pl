#!/usr/bin/env perl
use strict;
use warnings;
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
use Cwd;

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI::Escape;
use HTML::TreeBuilder::XPath;
use URI::URL;
use URI::ESCAPE;


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


#создаю экземпляр броузера
my $lwp = undef;
$lwp = LWP::UserAgent -> new ();
$lwp -> cookie_jar (HTTP::Cookies->new ());
$lwp -> agent ('Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16');
$lwp -> timeout (60);
# $lwp -> proxy ('http', 'http://127.0.0.1:8080');
$lwp -> proxy ('http', 'http://93.104.213.59:3128');



sub get_base_path {
	use Cwd; 
	my $cwd = getcwd ();
	return $cwd;
}

my $workdir1 = get_base_path.'/txt'; 
my $workdir2 = get_base_path.'/picture'; 
my $workdir3 = get_base_path.'/media'; 

my $file1 = $workdir1.'/1.csv'; 

my $count = 0;
my @read_text_file1 = ();
my %header = (); 
tie (%header, 'Tie::IxHash'); #чтобы было по мере добавления
my %file1 = ();

# my $result_get_1 = get_1 ();

login ();


sub get_1  {
	my $url = 'http://mnogo-dok.ru/rf.php?p=acer_aspire_5830tg_2414g64mnbb_1.pdf';
	my $useragent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16';
	my $request = HTTP::Request -> new (
		'GET' => $url,
		[
			'User-Agent' => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16',
			'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
			'Accept-Language' => 'ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
			'Accept-Charset' => 'windows-1251,utf-8;q=0.7,*;q=0.7',
		]
	);

	my $file = getcwd () .'/pdf/acer_aspire_5830tg_2414g64mnbb_1.pdf';
	my $response = $lwp -> request ($request, $file);
	
	print $response -> code ."\t". $url."\n";
	my $content1 = $response -> content;
	$content1 =~ s/\n+//g;
	
	return 1;
}


sub login {
	my $url = 'http://mnogo-dok.ru/instrukcii/sendvalues/10098/%D0%90%D0%B2%D1%82%D0%BE%D1%82%D0%B5%D1%85%D0%BD%D0%B8%D0%BA%D0%B0/CD-%D1%87%D0%B5%D0%B9%D0%BD%D0%B4%D0%B6%D0%B5%D1%80%D1%8B/Panasonic/CX-D801_CX-DP803N/';
	my $postdata = 'lets_down=1';
	
	push (@{ $lwp->requests_redirectable }, 'POST');
	my $req = HTTP::Request -> new (
	'POST' => $url,
		[
			'Host' => 'mnogo-dok.ru',
			'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:39.0) Gecko/20100101 Firefox/39.0',
			'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
			'Accept-Language' => 'ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
			'Referer' => 'http://mnogo-dok.ru/instrukcii/sendvalues/10098/%D0%90%D0%B2%D1%82%D0%BE%D1%82%D0%B5%D1%85%D0%BD%D0%B8%D0%BA%D0%B0/CD-%D1%87%D0%B5%D0%B9%D0%BD%D0%B4%D0%B6%D0%B5%D1%80%D1%8B/Panasonic/CX-D801_CX-DP803N/',
			'Content-Type' => 'application/x-www-form-urlencoded',
		]
	);

	
	$req -> content ($postdata);
	
	my $file = '1.doc';
	unlink ($file);
	
	my $response = $lwp -> request ($req, $file); 
	
	print $response -> code ."\t". $url;
	
	my $headers = $response->headers; # HTTP::Headers object
	print $headers -> as_string () ."\n"; # 1 вариант
	
	while (my ($key, $value) =  each (%$headers)) { # 2 вариант
		print $key."\t".$value."\n";                
		
		if ($value =~ /filename="(.+?)"/) {
			copy ($file, getcwd () .'/picture/'. $1) or die ();
		}
	}         	
	
	return 1;
}


sub Random {
	my $from = shift;
	my $to = shift;
	my $random = $from + rand(($to - $from));
	return $random;
}

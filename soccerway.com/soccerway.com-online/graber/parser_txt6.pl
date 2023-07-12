#!/usr/bin/env perl
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

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI::Escape;
use HTML::TreeBuilder::XPath;
use URI::URL;


sub get_base_path {
	use Cwd; 
	my $cwd = getcwd ();
	return $cwd;
}

my $read_inifile = read_inifile -> new ('graber.ini'); 
my $host = $read_inifile -> get ('host');

#„итаю установки из ини файла
my $mysql_dbdriver = $read_inifile -> get ('mysql_dbdriver');
my $mysql_host = $read_inifile -> get ('mysql_host');
my $mysql_port = $read_inifile -> get ('mysql_port');
my $mysql_user = $read_inifile -> get ('mysql_user');
my $mysql_user_password = $read_inifile -> get ('mysql_user_password');
if ($mysql_user_password eq ' ') {$mysql_user_password = '';}
my $mysql_base = $read_inifile -> get ('mysql_base');
my $mysql_table = $read_inifile -> get ('mysql_table');

#создаю экземпл¤р броузера
my $lwp = undef;
$lwp = LWP::UserAgent -> new ();
$lwp -> cookie_jar (HTTP::Cookies->new ());
$lwp -> agent ('Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16');
$lwp -> timeout (60);
# $lwp -> proxy ('http', 'http://127.0.0.1:8080');


my $workdir1 = get_base_path.'/txt'; 
my $workdir2 = get_base_path.'/picture'; 
my $workdir4 = get_base_path.'/pictura'; 
my $workdir3 = get_base_path.'/media'; 

my $file1 = $workdir1.'/write_text_file_mode_rewrite6.xls'; 
# my $file2 = $workdir1.'/write_text_file_mode_rewrite4.xls'; 

# #—оздаем дескриптор на mysql соединение
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


my $count = 0;
my @read_text_file1 = ();
my %header = (); 
tie (%header, 'Tie::IxHash'); #чтобы было по мере добавлени¤

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
my $match_id = undef;
my $read_text_file1 = read_text_file -> new ($file1); 
while (my $str1 = $read_text_file1 -> get_str ()) {
	#print ++$count."\n";
	
	if ($str1 =~ /\t/) {
		my $temp1 = []; my $pattern1 = "\t"; @$temp1 = split ($pattern1, $str1); 
		
		# print '*'.scalar (@$temp1)."\n";
		if (scalar (@$temp1 > 1)) {			
			
			foreach (@$temp1) {
				my $clear_str = clear_str -> new ($_); 
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;
			}
			
			#если присутвует Lineups (иначе не формируем XML)
			if ($temp1 -> [16] ne '-') {
			#if ($temp1 -> [0] ne '-') {
				
				#массив дл¤ отсылки инфы пост запросом
				my $insert = {};
				tie (%{$insert}, 'Tie::IxHash'); #чтобы было по мере добавлени¤

				{
					$match_id = $temp1 -> [0];	
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
							$_ = entities_encode ($_);
							$match_id = $_;
						}
					}
				}
				
				
				
				my $temp2 = [];
				push (@$temp2, '<gsmrs version="2.0" sport="soccer" lang="en" last_generated="'.get_date ().'" last_updated="'.get_date ().'">');
				
				push (@$temp2, '<method method_id="2" name="get_matches">');
				push (@$temp2, '<parameter name="detailed" value="yes"/>');
				push (@$temp2, '<parameter name="id" value="'.$match_id.'"/>');
				push (@$temp2, '<parameter name="lang" value="en"/>');
				push (@$temp2, '<parameter name="type" value="match"/>');
				push (@$temp2, '<parameter name="url" value="'.$temp1 -> [0].'" />');
				push (@$temp2, '</method>');
				
				{
					my $competition_id = '';	
					my $pattern1 = '(<competition_id>.+?</competition_id>)';
					my $work_for_content = work_for_content -> new ($temp1 -> [1]); 
					my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_3_s ();
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
							$_ = entities_encode ($_);
							$competition_id = $_;
						}
					}
					
					my $competition_name = '';	
					$pattern1 = '(<competition_name>.+?</competition_name>)';
					$work_for_content = work_for_content -> new ($temp1 -> [1]); 
					$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_3_s ();
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
							$_ = entities_encode ($_);
							$competition_name = $_;
						}
					}
					
					my $competition_type = '';	
					$pattern1 = '(<competition_type>.+?</competition_type>)';
					$work_for_content = work_for_content -> new ($temp1 -> [1]); 
					$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_3_s ();
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
							$_ = entities_encode ($_);
							$competition_type = $_;
						}
					}
					
					my $competition_country = '';	
					$pattern1 = '(<competition_country>.+?</competition_country>)';
					$work_for_content = work_for_content -> new ($temp1 -> [1]); 
					$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_3_s ();
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
							$_ = entities_encode ($_);
							$competition_country = $_;
						}
					}
					
					push (@$temp2, '<competition competition_id="'.$competition_id.'" competition_name="'.$competition_name.'" competition_type="'.$competition_type.'" competition_country="'.$competition_country.'">');
				}
				
				{
					my $season_id = '';	
					my $pattern1 = '(<season_id>.+?</season_id>)';
					my $work_for_content = work_for_content -> new ($temp1 -> [2]); 
					my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_3_s ();
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
							$_ = entities_encode ($_);
							$season_id = $_;
						}
					}
					
					my $season_name = '';	
					$pattern1 = '(<season_name>.+?</season_name>)';
					$work_for_content = work_for_content -> new ($temp1 -> [2]); 
					$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_3_s ();
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
							$_ = entities_encode ($_);
							$season_name = $_;
						}
					}
					push (@$temp2, '<season season_id="'.$season_id.'" name="'.$season_name.'">');
				}
				
				{
					my $round_id = '';	
					my $pattern1 = '(<round_id>.+?</round_id>)';
					my $work_for_content = work_for_content -> new ($temp1 -> [3]); 
					my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_3_s ();
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
							$_ = entities_encode ($_);
							$round_id = $_;
						}
					}
					
					my $round_name = '';	
					$pattern1 = '(<round_name>.+?</round_name>)';
					$work_for_content = work_for_content -> new ($temp1 -> [3]); 
					$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_3_s ();
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
							$_ = entities_encode ($_);
							$round_name = $_;
						}
					}
				
					push (@$temp2, '<round round_id="'.$round_id.'" name="'.$round_name.'">');
				}
				
				
				{
					my $team_A_id = '';
					my $team_A_name = '';
					my $team_B_id = '';
					my $team_B_name = '';
					my $date = '';
					my $time = '';
					my $timestamp = '';
					my $status = '';
					my $fs_A = '';
					my $fs_B = '';
					my $GameWeek = '';
					
					my $content = $temp1 -> [14];
					my @content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {
							
							my $pattern1 = '(<first_team_id>.+?</first_team_id>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$team_A_id = $_;
								}
							}
							
							$pattern1 = '(<first_team_name>.+?</first_team_name>)';
							$work_for_content = work_for_content -> new ($_); 
							$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$team_A_name = $_;
								}
							}
						}
					}				
					
					$content = $temp1 -> [15];
					@content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {
							my $pattern1 = '(<second_team_id>.+?</second_team_id>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$team_B_id = $_;
								}
							}
							
							$pattern1 = '(<second_team_name>.+?</second_team_name>)';
							$work_for_content = work_for_content -> new ($_); 
							$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$team_B_name = $_;
								}
							}
						}
					}				
					
					$content = $temp1 -> [26];
					@content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {				
							
							my $pattern1 = '<date>(.+?)</date>';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$date = $_;
								}
							}
						}
					}
					
					$content = $temp1 -> [26];
					@content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {				
					
							my $pattern1 = '<time>(.+?)</time>';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$time = $_;
								}
							}
						}
					}
					
					$content = $temp1 -> [26];
					@content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {				
					
							my $pattern1 = '<timestamp>(.+?)</timestamp>';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$timestamp = $_;
								}
							}
						}
					}
					
					
					$content = $temp1 -> [13];
					@content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {				
					
							my $pattern1 = '^(.+)$';
							my $work_for_content = work_for_content -> new ($_); 
							my  $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$status = $_;
								}
							}
						}
					}
					
					$content = $temp1 -> [23];
					@content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {				
					
							my $pattern1 = '^(.+)$';
							my $work_for_content = work_for_content -> new ($_); 
							my  $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$fs_A = $_;
								}
							}
						}
					}
					
					$content = $temp1 -> [24];
					@content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {				
					
							my $pattern1 = '^(.+)$';
							my $work_for_content = work_for_content -> new ($_); 
							my  $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$fs_B = $_;
								}
							}
						}
					}
					
					

					$content = $temp1 -> [29];
					@content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {				
					
							my $pattern1 = '^(.+)$';
							my $work_for_content = work_for_content -> new ($_); 
							my  $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									if ($_ ne '-') {
										$GameWeek = $_;
									}
								}
							}
						}
					}
					
					
					push (@$temp2, '<match match_id="'.$match_id.'" date_utc="'.$date.'" time_utc="'.$time.'" timestamp="'.$timestamp.'" team_A_id="'.$team_A_id.'" team_A_name="'.$team_A_name.'" team_B_id="'.$team_B_id.'" team_B_name="'.$team_B_name.'" status="'.$status.'" fs_A="'.$fs_A.'" fs_B="'.$fs_B.'" GameWeek="'.$GameWeek.'">');
				}
				 
				push (@$temp2, '<competition_plus>');
				{
					my $content = $temp1 -> [30];
					my @content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {				
					
							my $label = '';
							my $value = '';
							
							my $pattern1 = '(<label.+?</label>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$label = $_;
								}
							}
							
							$pattern1 = '(<value.+?</value>)';
							$work_for_content = work_for_content -> new ($_); 
							$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$value = $_;
								}
							}
							
							push (@$temp2, '<round id="'.$value.'" name="'.$label.'" />');
						}
					}
				}
				
				push (@$temp2, '</competition_plus>');
				
				push (@$temp2, '<GameWeek>');
				{
					my $content = $temp1 -> [29];
					my @content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {				
					
							my $pattern1 = '^(.+)$';
							my $work_for_content = work_for_content -> new ($_); 
							my  $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									if ($_ ne '-') {
										push (@$temp2, '<number>'.$_.'</number>');
									}
								}
							}
						}
					}
				}
				push (@$temp2, '</GameWeek>');


				
				push (@$temp2, '<matchinfo>');
				{
					my $content = $temp1 -> [5];
					my @content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {
						
							my $person_id = '-';	
							my $pattern1 = '(<referee_id>.+?</referee_id>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$person_id = $_;
								}
							}
							
							my $name = '-';	
							$pattern1 = '(<referee_name>.+?</referee_name>)';
							$work_for_content = work_for_content -> new ($_); 
							$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$name = $_;
								}
							}
						
							if ($person_id ne '-') {
								push (@$temp2, '<referee person_id="'.$person_id.'" name="'.$name.'" />');
							}
						}
					}
				}	
				
				{
					my $content = $temp1 -> [6];
					my @content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {
					
							my $person_id = '-';	
							my $pattern1 = '(<assistant_referee_id>.+?</assistant_referee_id>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$person_id = $_;
								}
							}
							
							my $name = '-';	
							$pattern1 = '(<assistant_referee_name>.+?</assistant_referee_name>)';
							$work_for_content = work_for_content -> new ($_); 
							$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$name = $_;
								}
							}
						
							if ($person_id ne '-') {
								push (@$temp2, '<assistant_referee person_id="'.$person_id.'" name="'.$name.'" />');
							}
						}
					}
				}	
				
				{
					my $content = $temp1 -> [7];
					my @content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {
					
							my $person_id = '-';	
							my $pattern1 = '(<fourth_official_id>.+?</fourth_official_id>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$person_id = $_;
								}
							}
							
							my $name = '-';	
							$pattern1 = '(<fourth_official_name>.+?</fourth_official_name>)';
							$work_for_content = work_for_content -> new ($_); 
							$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$name = $_;
								}
							}
						
							if ($person_id ne '-') {
								push (@$temp2, '<fourth_official person_id="'.$person_id.'" name="'.$name.'" />');
							}
						}
					}
				}	
				
				{
					my $content = $temp1 -> [8];
					my @content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {
					
							my $person_id = '-';	
							my $pattern1 = '(<attendance>.+?</attendance>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$person_id = $_;
								}
							}
						
							if ($person_id ne '-') {
								push (@$temp2, '<attendance value="'.$person_id.'"/>');
							}
						}
					}
				}	
				{
					my $content = $temp1 -> [9];
					my @content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {
					
							my $person_id = '-';	
							my $pattern1 = '(<coach_team_a_id>.+?</coach_team_a_id>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$person_id = $_;
								}
							}
							
							my $name = '-';	
							$pattern1 = '(<coach_team_a_name>.+?</coach_team_a_name>)';
							$work_for_content = work_for_content -> new ($_); 
							$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$name = $_;
								}
							}
						
							if ($person_id ne '-') {
								push (@$temp2, '<coach_team_a person="'.$name.'" person_id="'.$person_id.'" />');
							}
						}
					}
				}	
				
				{
					my $content = $temp1 -> [10];
					my @content = split ('\|\|', $content);
					if (scalar (@content) > 0) {
						foreach (@content) {
					
							my $person_id = '-';	
							my $pattern1 = '(<coach_team_b_id>.+?</coach_team_b_id>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$person_id = $_;
								}
							}
							
							my $name = '-';	
							$pattern1 = '(<coach_team_b_name>.+?</coach_team_b_name>)';
							$work_for_content = work_for_content -> new ($_); 
							$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									$_ = entities_encode ($_);
									$name = $_;
								}
							}
						
							if ($person_id ne '-') {
								push (@$temp2, '<coach_team_b person="'.$name.'" person_id="'.$person_id.'" />');
							}
						}
					}
				}	
				
				push (@$temp2, '</matchinfo>');

				push (@$temp2, '<lineups>');
				{
					
					my $content = $temp1 -> [16];
					if ($content ne '-') {
						my @content = split ('\|\|', $content);
						if (scalar (@content) > 0) {
							foreach (@content) {
						
								my $person_id = '';	
								my $pattern1 = '(<lineups_person_id>.+?</lineups_person_id>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person_id = $_;
									}
								}
								
								my $name = '';	
								$pattern1 = '(<lineups_person_name>.+?</lineups_person_name>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$name = $_;
									}
								}
								
								my $team_id = '';
								$pattern1 = '(<team_id>.+?</team_id>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$team_id = $_;
									}
								}
								
								
								my $shirtnumber = '';
								$pattern1 = '(<shirtnumber>.+?</shirtnumber>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$shirtnumber = $_;
									}
								}
								
								if ($person_id ne '-') {
									push (@$temp2, '<event code="L" name="Line-up" person="'.$name.'" person_id="'.$person_id.'" team_id="'.$team_id.'" shirtnumber="'.$shirtnumber.'" />');
								}
							}
						}
					}	
					
					push (@$temp2, '</lineups>');
					
					
					push (@$temp2, '<lineups_bench>');
					{
						my $content = $temp1 -> [17];
						if ($content ne '-') {
							my @content = split ('\|\|', $content);
							if (scalar (@content) > 0) {
								foreach (@content) {
							
									my $person_id = '';	
									my $pattern1 = '(<lineups_bench_person_id>.+?</lineups_bench_person_id>)';
									my $work_for_content = work_for_content -> new ($_); 
									my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											$_ = entities_encode ($_);
											$person_id = $_;
										}
									}
									
									my $name = '';	
									$pattern1 = '(<lineups_bench_name>.+?</lineups_bench_name>)';
									$work_for_content = work_for_content -> new ($_); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											# $_ = entities_encode ($_);
											$name = $_;
										}
									}
									
									my $team_id = '';
									$pattern1 = '(<team_id>.+?</team_id>)';
									$work_for_content = work_for_content -> new ($_); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											$_ = entities_encode ($_);
											$team_id = $_;
										}
									}
									
									
									my $shirtnumber = '';
									$pattern1 = '(<shirtnumber>.+?</shirtnumber>)';
									$work_for_content = work_for_content -> new ($_); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											$_ = entities_encode ($_);
											$shirtnumber = $_;
										}
									}
									
									if ($person_id ne '-') {
										push (@$temp2, '<event code="SUB" name="Substitution on bench" person="'.$name.'" person_id="'.$person_id.'" team_id="'.$team_id.'" shirtnumber="'.$shirtnumber.'" />');
									}
								}
							}
						}
					}
				}	
				
				push (@$temp2, '</lineups_bench>');


				
				push (@$temp2, '<substitutions>');
				{
					my $content = $temp1 -> [18];
					if ($content ne '-') {
						my @content = split ('\|\|', $content);
						if (scalar (@content) > 0) {
							foreach (@content) {
							
								push (@$temp2, '<sub>');
								
								my $person_id = '';	
								my $pattern1 = '(<substitutes_in_person_id>.+?</substitutes_in_person_id>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person_id = $_;
									}
								}
								
								my $name = '';	
								$pattern1 = '(<substitutes_in_person_name>.+?</substitutes_in_person_name>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$name = $_;
									}
								}
								
								my $substitutes_in_person_shirtnumber = '';	
								$pattern1 = '(<substitutes_in_person_shirtnumber>.+?</substitutes_in_person_shirtnumber>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$substitutes_in_person_shirtnumber = $_;
									}
								}
								
								my $minute = '';	
								$pattern1 = '(<minute>.+?</minute>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$minute = $_;
									}
								}
								
								my $minute_extra = '';	
								$pattern1 = '(<minute_extra>.+?</minute_extra>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$minute_extra = $_;
									}
								}
								
								my $team_id = '';	
								$pattern1 = '(<team_id>.+?</team_id>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$team_id = $_;
									}
								}
								
								if ($person_id ne '-') {
									push (@$temp2, '<event code="SI" name="Substitute in" person="'.$name.'" person_id="'.$person_id.'" team_id="'.$team_id.'" shirtnumber="'.$substitutes_in_person_shirtnumber.'" minute="'.$minute.'" minute_extra="'.$minute_extra.'"/>');
								}
								
								
								$person_id = '';	
								$pattern1 = '(<substitutes_out_person_id>.+?</substitutes_out_person_id>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person_id = $_;
									}
								}
								
								$name = '';	
								$pattern1 = '(<substitutes_out_person_name>.+?</substitutes_out_person_name>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$name = $_;
									}
								}
								
								my $substitutes_out_person_shirtnumber = '';	
								$pattern1 = '(<substitutes_out_person_shirtnumber>.+?</substitutes_out_person_shirtnumber>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$substitutes_out_person_shirtnumber = $_;
									}
								}
								
								$minute = '';	
								$pattern1 = '(<minute>.+?</minute>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$minute = $_;
									}
								}
								
								if ($person_id ne '-') {
									push (@$temp2, '<event code="SO" name="Substitute out" person="'.$name.'" person_id="'.$person_id.'" team_id="'.$team_id.'" shirtnumber="'.$substitutes_out_person_shirtnumber.'" minute="'.$minute.'" />');
								}
								
								push (@$temp2, '</sub>');
							}
						}
					}
				}	
				
				push (@$temp2, '</substitutions>');
				

				push (@$temp2, '<goals>');
				my %goals_person = ();
				{
					my $content = $temp1 -> [19];
					if ($content ne '-') {
						my @content = split ('\|\|', $content);
						if (scalar (@content) > 0) {
							foreach (@content) {
							
								my $person_id = '';	
								my $pattern1 = '(<person_id>.+?</person_id>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person_id = $_;
									}
								}
								
								my $person = '';	
								$pattern1 = '(<person>.+?</person>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person = $_;
									}
								}
								
								my $minute = '';	
								$pattern1 = '(<minute>.+?</minute>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$minute = $_;
									}
								}
								
								my $minute_extra = '';	
								$pattern1 = '(<minute_extra>.+?</minute_extra>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$minute_extra = $_;
									}
								}
								
								
								my $team_id = '';	
								$pattern1 = '(<team_id>.+?</team_id>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$team_id = $_;
									}
								}
								
								my $assist_id = '';	
								$pattern1 = '(<assist_id>.+?</assist_id>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$assist_id = $_;
									}
								}
								
								my $assist_name = '';	
								$pattern1 = '(<assist_name>.+?</assist_name>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$assist_name = $_;
									}
								}
								
								if ($assist_id ne '') {
									my $str = '<code>AS</code><name>Assist</name><assist_id>'.$assist_id.'</assist_id><assist_name>'.$assist_name.'</assist_name>';
									$goals_person {$person_id} = $str;
								}
							}
						}
					}
				}	
				
				{
					my $content = $temp1 -> [20];
					if ($content ne '-') {
						my @content = split ('\|\|', $content);
						if (scalar (@content) > 0) {
							foreach (@content) {
							
								my $person_id = '';	
								my $pattern1 = '(<person_id>.+?</person_id>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person_id = $_;
									}
								}
								
								my $person = '';	
								$pattern1 = '(<person>.+?</person>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person = $_;
									}
								}
								
								my $minute = '';	
								$pattern1 = '(<minute>.+?</minute>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$minute = $_;
									}
								}
								
								my $minute_extra = '';	
								$pattern1 = '(<minute_extra>.+?</minute_extra>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$minute_extra = $_;
									}
								}
								
								
								my $team_id = '';	
								$pattern1 = '(<team_id>.+?</team_id>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$team_id = $_;
									}
								}
								
								my $assist_id = '';	
								$pattern1 = '(<assist_id>.+?</assist_id>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$assist_id = $_;
									}
								}
								
								my $assist_name = '';	
								$pattern1 = '(<assist_name>.+?</assist_name>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$assist_name = $_;
									}
								}
								
								if ($assist_id ne '') {
									my $str = '<code>AS</code><name>Assist</name><assist_id>'.$assist_id.'</assist_id><assist_name>'.$assist_name.'</assist_name>';
									$goals_person {$person_id} = $str;
								}
							}
						}
					}
				}	
				
				
				{
					my $content = $temp1 -> [25];
					if ($content ne '-') {
						my @content = split ('\|\|', $content);
						if (scalar (@content) > 0) {
							foreach (@content) {
							
								push (@$temp2, '<goal>');
								
								my $person_id = '';	
								my $pattern1 = '(<person_id>.+?</person_id>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person_id = $_;
									}
								}
								
								my $person = '';	
								$pattern1 = '(<person>.+?</person>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person = $_;
									}
								}
								
								my $minute = '';	
								$pattern1 = '(<minute>.+?</minute>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$minute = $_;
									}
								}
								
								my $minute_extra = '';	
								$pattern1 = '(<minute_extra>.+?</minute_extra>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$minute_extra = $_;
									}
								}
								
								my $team_id = '';	
								$pattern1 = '(<team_id>.+?</team_id>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$team_id = $_;
									}
								}
								
								my $code = '';	
								$pattern1 = '(<code>.+?</code>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$code = $_;
									}
								}
								
								my $name = '';	
								$pattern1 = '(<name>.+?</name>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$name = $_;
									}
								}
								
								if ($person_id ne '') {
									push (@$temp2, '<event code="'.$code.'" name="'.$name.'" person="'.$person.'" person_id="'.$person_id.'" team_id="'.$team_id.'" minute="'.$minute.'" minute_extra="'.$minute_extra.'"/>');
									# print '<event code="'.$code.'" name="'.$name.'" person="'.$person.'" person_id="'.$person_id.'" team_id="'.$team_id.'" minute="'.$minute.'" minute_extra="'.$minute_extra.'"/>' ."\n";
								}
								
								if (exists($goals_person {$person_id})) {
									
									my $cc = $goals_person {$person_id};
									my $assist_id = '';	
									$pattern1 = '(<assist_id>.+?</assist_id>)';
									$work_for_content = work_for_content -> new ($cc); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											$_ = entities_encode ($_);
											$assist_id = $_;
										}
									}
									
									my $assist_name = '';	
									$pattern1 = '(<assist_name>.+?</assist_name>)';
									$work_for_content = work_for_content -> new ($cc); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											$_ = entities_encode ($_);
											$assist_name = $_;
										}
									}
									
									my $code = '';	
									$pattern1 = '(<code>.+?</code>)';
									$work_for_content = work_for_content -> new ($cc); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											$_ = entities_encode ($_);
											$code = $_;
										}
									}
									
									my $name = '';	
									$pattern1 = '(<name>.+?</name>)';
									$work_for_content = work_for_content -> new ($cc); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											$_ = entities_encode ($_);
											$name = $_;
										}
									}
									
									if ($assist_id ne '') {
										push (@$temp2, '<event code="'.$code.'" name="'.$name.'" person="'.$assist_name.'" person_id="'.$assist_id.'" team_id="'.$team_id.'" minute="'.$minute.'" minute_extra="'.$minute_extra.'"/>');
									}
								}
								
								push (@$temp2, '</goal>');
							}
						}
					}
				}	
				
				
				push (@$temp2, '</goals>');

				
				push (@$temp2, '<bookings>');
				
				{	
					my $content = $temp1 -> [21];
					if ($content ne '-') {
						my @content = split ('\|\|', $content);
						if (scalar (@content) > 0) {
							foreach (@content) {
							
								my $person_id = '';	
								my $pattern1 = '(<person_id>.+?</person_id>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person_id = $_;
									}
								}
								
								my $person = '';	
								$pattern1 = '(<person>.+?</person>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person = $_;
									}
								}
								
								my $minute = '';	
								$pattern1 = '(<minute>.+?</minute>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$minute = $_;
									}
								}
								
								my $minute_extra = '';	
								$pattern1 = '(<minute_extra>.+?</minute_extra>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$minute_extra = $_;
									}
								}
								
								
								my $team_id = '';	
								$pattern1 = '(<team_id>.+?</team_id>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$team_id = $_;
									}
								}
								
								my $code = '';	
								$pattern1 = '(<code>.+?</code>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$code = $_;
									}
								}
								
								my $name = '';	
								$pattern1 = '(<name>.+?</name>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$name = $_;
									}
								}

								if ($person_id ne '') {
									push (@$temp2, '<event code="'.$code.'" name="'.$name.'" person="'.$person.'" person_id="'.$person_id.'" team_id="'.$team_id.'" minute="'.$minute.'" minute_extra="'.$minute_extra.'"/>');
								}
							}
						}
					}
				}	
				
				push (@$temp2, '</bookings>');

				push (@$temp2, '<penalty_shootout>');
				{	
					my $content = $temp1 -> [22];
					if ($content ne '-') {
						my @content = split ('\|\|', $content);
						if (scalar (@content) > 0) {
							foreach (@content) {
							
								my $person_id = '';	
								my $pattern1 = '(<person_id>.+?</person_id>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person_id = $_;
									}
								}
								
								my $person = '';	
								$pattern1 = '(<person>.+?</person>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person = $_;
									}
								}
								
								my $team_id = '';	
								$pattern1 = '(<team_id>.+?</team_id>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$team_id = $_;
									}
								}
								
								my $code = '';	
								$pattern1 = '(<code>.+?</code>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$code = $_;
									}
								}
								
								my $name = '';	
								$pattern1 = '(<name>.+?</name>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$name = $_;
									}
								}

								
								if ($person_id ne '') {
									push (@$temp2, '<event code="'.$code.'" name="'.$name.'" person="'.$person.'" person_id="'.$person_id.'" team_id="'.$team_id.'" />');
									# print '<event code="'.$code.'" name="'.$name.'" person="'.$person.'" person_id="'.$person_id.'" team_id="'.$team_id.'" minute="'.$minute.'" minute_extra="'.$minute_extra.'"/>' ."\n";
								}
							}
						}
					}
				}	
				
				push (@$temp2, '</penalty_shootout>');


				push (@$temp2, '<person_url>');
				{	
					my $content = $temp1 -> [27];
					if ($content ne '-') {
						my @content = split ('\|\|', $content);
						if (scalar (@content) > 0) {
							foreach (@content) {
							
								my $person_id = '';	
								my $pattern1 = '(<id>.+?</id>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person_id = $_;
									}
								}
								
								my $url = '';	
								$pattern1 = '(<url>.+?</url>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$url = $_;
									}
								}
								
								if ($person_id ne '') {
									push (@$temp2, '<person id="'.$person_id.'" url="'.$url.'" />');
								}
							}
						}
					}
				}	
				
				push (@$temp2, '</person_url>');

				push (@$temp2, '<team_url>');
				{	
					my $content = $temp1 -> [28];
					if ($content ne '-') {
						my @content = split ('\|\|', $content);
						if (scalar (@content) > 0) {
							foreach (@content) {
							
								my $person_id = '';	
								my $pattern1 = '(<team_id>.+?</team_id>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$person_id = $_;
									}
								}
								
								my $url = '';	
								$pattern1 = '(<team_url>.+?</team_url>)';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										$_ = entities_encode ($_);
										$url = $_;
									}
								}
								
								if ($person_id ne '') {
									push (@$temp2, '<team id="'.$person_id.'" url="'.$url.'" />');
								}
							}
						}
					}
				}	
				
				push (@$temp2, '</team_url>');
				
				
				push (@$temp2, '</match>');
				push (@$temp2, '</round>');
				push (@$temp2, '</season>');
				push (@$temp2, '</competition>');
				push (@$temp2, '</gsmrs>');
				

				# my $str = join ("\t", @$temp1); 
				push (@read_text_file1, $temp2);

				{
					#my $file2 = getcwd () .'/out/'.good_count ($match_id).'.xml';
					my $file2 = getcwd () .'/out/'.$match_id.'.xml';
					my $write_text_file_mode_rewrite = write_text_file_mode_rewrite -> new ($file2);
					my $str = join ("\n", @$temp2);
					$write_text_file_mode_rewrite -> put_str ($str."\n");
					$write_text_file_mode_rewrite = undef;
					
					# my $file3 = $read_inifile -> {copy_path} .'/'.good_count ($match_id).'.xml';
					# if (-f $file2 and -d $read_inifile -> {copy_path}) {
						# copy ($file2, $file3) or die ();
					# }
				}
			}
		}
	}
}
$read_text_file1 = undef;


# my $file_count = 0;
# if (scalar (@read_text_file1) > 0) {
	# foreach (@read_text_file1) {
		# print ++$count."\n";
		# $file_count++;
		
		# # my $file2 = getcwd () .'/out/'.good_count ($file_count).'.xml';
		# my $file2 = getcwd () .'/out/'.good_count ($match_id).'.xml';
		
		# my $write_text_file_mode_rewrite = write_text_file_mode_rewrite -> new ($file2);
		
		# my $str = join ("\n", @$_);
		# $write_text_file_mode_rewrite -> put_str ($str."\n");
		# $write_text_file_mode_rewrite = undef;
	# }
# }


sub post {
	my $postdata = shift;
	
	# UpdateFootballScoreswayTeams
	# UpdateFootballScoreswayPlayers
	# UpdateFootballScoreswayCoaches
	
	my $key_import2 = '22812357092873478234729374';
    my $url = 'http://data.instatfootball.tv/api/import2?key='.$key_import2.'&method=UpdateFootballScoreswayReferees';

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
	
	my $file = getcwd () .'/txt/referees.html';
	my $res = $lwp -> request ($req, $file); 
	#print $res -> code ."\t" . $url ."\n";
	
	# my $sleep = Random ($sleep2, $sleep3); 
	# sleep $sleep;		
}


sub good_count {
	my $str = shift;
	while (length ($str) < 5) {
		$str = '0'.$str;
	}
	return $str;
}

sub get_date { 
	use  Date::Calc qw (Time_to_Date Date_to_Time);
	# my $time = time ();
	my $time = time () + 3*3600;
	my ($year,$month,$day, $hour,$min,$sec) = Time_to_Date($time);
	my $str = $year .'-'.$month.'-'.$day .' '.$hour.':'.$min.':'.$sec;
	
	
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

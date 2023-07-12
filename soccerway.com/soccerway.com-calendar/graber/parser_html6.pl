#!/usr/bin/env perl
#матчи
use strict;
use warnings;
use Cwd;
use lib getcwd ();

use dir_scan_recurce;
# use locale;
# use POSIX qw (locale_h);
# setlocale(LC_CTYPE, ' ru_RU.CP1251');

use read_inifile;
use read_text_file; 
use write_text_file_mode_rewrite; 
use Encode qw (encode decode);
use clear_str;

use work_mysql_graber;
use work_for_content;
use write_to_txt1;
use write_to_txt2;
use HTML::TreeBuilder::XPath;

use url_to_file;
use URI;
use URI::Escape;
use Tie::IxHash;
use URI::URL;
use URI::Escape;
# use utf8;


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

#Создаем дескриптор на mysql соединение
my $work_mysql_graber = work_mysql_graber -> new (
	$mysql_dbdriver,
	$mysql_host,
	$mysql_port,
	$mysql_user,
	$mysql_user_password,
	$mysql_base,
	$mysql_table
); 

my	$work_mysql = work_mysql -> new (
		$mysql_dbdriver,
		$mysql_host,
		$mysql_port,
		$mysql_user,
		$mysql_user_password,
		$mysql_base
	); 	

my $workdir1 = get_base_path ().'/medim'; 
my $workdir2 = get_base_path ().'/txt'; 
my $workdir3 = get_base_path ().'/xls'; 

my $write_text_file_mode_rewrite1 = undef;
my $file1 = $workdir2.'/write_text_file_mode_rewrite1.xls'; 
my $file2 = $workdir2.'/write_text_file_mode_rewrite2.xls'; 
my $write_file1 = $workdir2.'/write_text_file_mode_rewrite6.xls'; 
$write_text_file_mode_rewrite1 = write_text_file_mode_rewrite -> new ($write_file1);

my $count = 0 ;
my %file1 = ();
# my $header = undef;
# my @read_text_file1 = ();

# {
	# my $dir_scan_recurce = dir_scan_recurce -> new ($workdir3);
	# while (my $file1 = $dir_scan_recurce -> get_file ()) {
		# print ++$count."\n";

		# my $pattern = 'xls$';
		# if ($file1 =~ /$pattern/) {	

			# my $read_text_file1 = read_text_file -> new ($file1); 
			# while (my $str1 = $read_text_file1 -> get_str ()) {
				# print ++$count."\n";
				
				# if ($str1 =~ /\t/) {
					# my $temp1 = []; my $pattern1 = "\t"; @$temp1 = split ($pattern1, $str1); 
					
					# # print '*'.scalar (@$temp1)."\n";
					# if (scalar (@$temp1 == 2)) {			
						# foreach (@$temp1) {
							# my $clear_str = clear_str -> new ($_); 
							# $_ = $clear_str -> delete_4 ();
							# $clear_str = undef;
						# }
						
						# if ($temp1 -> [1] =~ /^http:/) {
						
							# my $md5 = MD5 -> new ();
							# my $hash = $md5 -> hexhash ($temp1 -> [1]);
							# $md5 = undef;
						
							# $file1 {$hash} = $temp1;
							# # print $hash ."\n";
							# # print $temp1 -> [1] ."\n";
						# }
						
						# # foreach (keys (%file1)) {
							# # print $file1 {$_} ."\n";
						# # }
						
					# }
				# }
			# }
			# $read_text_file1 = undef;
		# }
	# }
# }



my %s = ();
my $dir_scan_recurce = dir_scan_recurce -> new ($workdir1);
while (my $file1 = $dir_scan_recurce -> get_file ()) {
	print ++$count."\n";
	
	my $pattern = 'http_';
	if ($file1 =~ /$pattern/) {	
		
		my @file1 = ();	
		my $read_text_file = read_text_file -> new ($file1); 
		while (my $str1 = $read_text_file -> get_str ()) {
			push (@file1, $str1); 
		}
		$read_text_file = undef;
		
		
		my $content1 = join (' ', @file1); 
		# $content1 = entities_decode ($content1);
		# $content1 = utf8_to_win1251 ($content1);
		
		{
			my $clear_str = clear_str -> new ($content1);
			$content1 = $clear_str -> delete_4 ();
			$clear_str = undef;						
			
			# my $pattern1 = '<td s>';
			# my $pattern2 = '<td>';
			# $content1 =~ s/$pattern1/$pattern2/gi;
			
		}
		
		# $content1 =~ s/\'/"/g;
		# $content1 =~ s/\"\"/" "/g;
		# $content1 =~ s/>\s+</></g;
		# $content1 =~ s/></> </g;
		
		# my $tree = HTML::TreeBuilder::XPath -> new ();
		# $tree -> parse_content ($content1);
		# my $content2 = $tree -> findnodes_as_string ('//div[@class="product-params"]'); 
		# $tree->delete;
		# $tree = undef;
		# $content2 =~ s/\n+//g;
		
		# print $content2 ."\n";
		
		
		# # my $pattern1 = '(<div id="club_table_box">.+?</div>)';
		# my $pattern1 = '(<div id="leagues_table_box">.+?</div>)';
		# my $work_for_content = work_for_content -> new ($content1); 
		# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		# if (defined $work_for_content_result -> [0]) {
			# foreach (@$work_for_content_result) {		
				# my $clear_str = clear_str -> new ($_);
				# $_ = $clear_str -> delete_4 ();
				# $clear_str = undef;								
				
				# $_ = entities_decode ($_);
				
				# print $_ ."\n";
				
				# my @table = ();
				# my $pattern1 = '(<tr.+?</tr>)';
				# my $work_for_content = work_for_content -> new ($_); 
				# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				# if (defined $work_for_content_result -> [0]) {
					# foreach (@$work_for_content_result) {		
						# my $clear_str = clear_str -> new ($_);
						# $_ = $clear_str -> delete_4 ();
						# $clear_str = undef;								
						
						# if ($_ =~ /\/club.html/) {
						
							# my $pattern1 = 'href="(.+?)"';
							# my $work_for_content = work_for_content -> new ($_); 
							# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							# if (defined $work_for_content_result -> [0]) {
								# foreach (@$work_for_content_result) {		
									# my $clear_str = clear_str -> new ($_);
									# $_ = $clear_str -> delete_4 ();
									# $clear_str = undef;								

						
									# # my $uri = URI::URL-> new( $_, $job -> {url});
									# my $uri = URI::URL-> new( $_, 'http://'.$host);
									# my $url = $uri->abs;
									# my $method = 'GET';
									# my $type = 'html';
									# my $str_for_content = 'href';
									# my $referer = $url;
									
									# $work_mysql_graber -> insert_ignore (
										# $method, 
										# $url,
										# $referer,
										# $type, 
										# $str_for_content
									# ); 
									
									# print $url ."\n";
								# }
							# }
						# }
						
				
						# my $td = [];
						# my $pattern1 = '(<td.+?</td>)';
						# my $work_for_content = work_for_content -> new ($_); 
						# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						# if (defined $work_for_content_result -> [0]) {
							# foreach (@$work_for_content_result) {		
								# my $clear_str = clear_str -> new ($_);
								# $_ = $clear_str -> delete_4 ();
								# $clear_str = undef;								
								# push (@$td, $_);
							# }
						# }
						
						# print 'scalar (@$td) = ' . scalar (@$td) ."\n";
						# if (scalar (@$td) == 4) {
							# push (@table, $td);
						# }
					# }
				# }
				
				# if (scalar (@table) > 0) {
					# foreach (@table) {
						# if ($_ -> [2] =~ /active/) {
						
							# my $pattern1 = 'href="(.+?)"';
							# my $work_for_content = work_for_content -> new ($_-> [1]); 
							# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							# if (defined $work_for_content_result -> [0]) {
								# foreach (@$work_for_content_result) {		
									# my $clear_str = clear_str -> new ($_);
									# $_ = $clear_str -> delete_4 ();
									# $clear_str = undef;								
									
									# # print $_  ."\n";
									
									# # my $uri = URI::URL-> new( $_, $job -> {url});
									# my $uri = URI::URL-> new( $_, 'http://'.$host);
									# my $url = $uri->abs;
									# my $method = 'GET';
									# my $type = 'media';
									# my $str_for_content = 'href';
									# my $referer = $url;
									
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
		# }
		
		
		my %players_url = ();
		
		my $write_to_txt1 = write_to_txt1 -> new ();				
		
		#урл из базы грабера
		#урл из базы грабера
		my $url = '-';
		my $str_for_content = '-';
		my $referer = '-';
		my $file = '-';
		
		{
			#URL
			my $file2 = $file1;
			$file2 =~ s/^.+\///;
			my $hash = undef;
			my $pattern1 = 'http_(.+?).html';
			my $work_for_content = work_for_content -> new ($file2); 
			my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
			if (defined $work_for_content_result -> [0]) {
				foreach (@$work_for_content_result) {		
					my $clear_str = clear_str -> new ($_);
					$_ = $clear_str -> delete_4 ();
					$clear_str = undef;		
					$hash = $_;
				}
			}
			
			my $sql = 'select * from '.$mysql_table.' where `hash` = "'.$hash.'"';
			$work_mysql	-> run_query ($sql); 
			my @row = $work_mysql -> get_row ();
			if (scalar (@row) > 0) {
				foreach (@row) {
					$url = $_ -> [2];
					$referer = $_ -> [3];
					$file = $_ -> [4];
					$str_for_content = $_ -> [7] ;
				}
			} 
		}		
		
		$write_to_txt1 -> put ($url);
		# $write_to_txt1 -> put ($referer);
		# print $url ."\n";
		
		# competition
		my $competition_id = '';
		my @array = ();
		my $pattern1 = '<div id="fresh8-data-container".+?data-competitionids="(\d+)"';
		my $work_for_content = work_for_content -> new ($content1); 
		my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				# my $str = '<competition_id>'.$_.'</competition_id>';
				# push (@array, $str);
				$competition_id = $_;
			}
		}
		
		$pattern1 = '<div class="small-column">.+?(<h2.+?</h2>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				my $str = '<competition_country>'.$_.'</competition_country>';
				push (@array, $str);
			}
		}
		
		
		# competition2 (узнаем имя соревнования)
		$pattern1 = '<ul class="left-tree">.+?(<li class="expanded.+?</li>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				my $a_count = 0;
				my @array1 = ();
				my $pattern1 = '(<a.+?</a>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						$a_count++;
						
						if ($a_count == 1) {
						
							my $pattern1 = 'href="(.+?)"';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;
									
									my @temp = split ('/', $_);
									if (scalar (@temp) > 0) {
										foreach (@temp) {
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											$_ =~ s/^\s+//;
											$_ =~ s/\s+$//;
											$_ =~ s/^\s+$//;
										}
										
										my $str = pop (@temp);
										
										my $pattern1 = '(\d+)';
										my $work_for_content = work_for_content -> new ($str); 
										my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
										if (defined $work_for_content_result -> [0]) {
											foreach (@$work_for_content_result) {		
												my $clear_str = clear_str -> new ($_);
												$_ = $clear_str -> delete_4 ();
												$clear_str = undef;		
												push (@array1 , '<competition_id>'.$_.'</competition_id>');
											}
										}
										
										$str = shift (@temp);
										$str = shift (@temp);
										
										$pattern1 = '^(.+)$';
										$work_for_content = work_for_content -> new ($str); 
										$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
										if (defined $work_for_content_result -> [0]) {
											foreach (@$work_for_content_result) {		
												my $clear_str = clear_str -> new ($_);
												$_ = $clear_str -> delete_4 ();
												$clear_str = undef;		
												push (@array1 , '<competition_type>'.$_.'</competition_type>');
											}
										}
									}
								}
								
								$pattern1 = '^(.+)$';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										my $str = $_;
										push (@array1 , '<competition_name>'.$str.'</competition_name>');
									}
								}
							}
						}
					}
				}
				
				if (scalar (@array1) > 0) {
					my $str = join ('', @array1);
					push (@array, $str);
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		# season
		@array = ();
		$pattern1 = '<ul class="left-tree">.+?(<li class="expanded.+?</li>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				my $a_count = 0;
				my @array1 = ();
				my $pattern1 = '(<a.+?</a>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						$a_count++;
						
						if ($a_count == 2) {
						
							my $pattern1 = 'href="(.+?)"';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									my @temp = split ('/', $_);
									if (scalar (@temp) > 0) {
										foreach (@temp) {
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											
											$_ =~ s/^\s+//;
											$_ =~ s/\s+$//;
											$_ =~ s/^\s+$//;
										}
										
										my $str = pop (@temp);
										
										my $pattern1 = 's(\d+)';
										my $work_for_content = work_for_content -> new ($str); 
										my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
										if (defined $work_for_content_result -> [0]) {
											foreach (@$work_for_content_result) {		
												my $clear_str = clear_str -> new ($_);
												$_ = $clear_str -> delete_4 ();
												$clear_str = undef;		
												push (@array1 , '<season_id>'.$_.'</season_id>');
											}
										}
									}
								}
								
								$pattern1 = '^(.+)$';
								$work_for_content = work_for_content -> new ($_); 
								$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_3_s ();
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										my $str = $_;
										push (@array1 , '<season_name>'.$str.'</season_name>');
									}
								}
							}
						}
					}
				}
				
				if (scalar (@array1) > 0) {
					my $str = join ('', @array1);
					push (@array, $str);
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put (pop (@array));
		} else {
			$write_to_txt1 -> put ('-');
		}		
		

		
		@array = ();
		
		#round вариант 3 то что красным, если expanded не нашлось
		$pattern1 = '(<li class="current expanded">.+?</a>)';		
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				my @array1 = ();
				my $pattern1 = '(<a.+?</a>)';
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
								
								$_ =~ s/\/$//;
								
								my @temp = split ('/', $_);
								if (scalar (@temp) > 0) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										
										$_ =~ s/^\s+//;
										$_ =~ s/\s+$//;
										$_ =~ s/^\s+$//;
										$_ =~ s/r//;
									}
									
									my $str = pop (@temp);
									my $pattern1 = '(\d+)';
									my $work_for_content = work_for_content -> new ($str); 
									my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											$_ =~ s/^\s+//;
											$_ =~ s/\s+$//;
											$str = $_;
										}
									}
									
									push (@array1 , '<round_id>'.$str.'</round_id>');
								}
							}
						}
						
						$pattern1 = '^(.+)$';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								my $str = $_;
								push (@array1 , '<round_name>'.$str.'</round_name>');
							}
						}
					}
				}
				
				if (scalar (@array1) > 0) {
					my $str = join ('', @array1);
					push (@array, $str);
				}
			}
		} 
		
		
		#round вариант 1 если ЕСТЬ expanded
		# $pattern1 = '(<li class=" expanded">|"current expanded">.+?</a>)';
		$pattern1 = '(<li class=" expanded">.+?</a>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				
				my @array1 = ();
				my $pattern1 = '(<a.+?</a>)';
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
								
								$_ =~ s/\/$//;
								
								my @temp = split ('/', $_);
								if (scalar (@temp) > 0) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										
										$_ =~ s/^\s+//;
										$_ =~ s/\s+$//;
										$_ =~ s/^\s+$//;
										$_ =~ s/r//;
									}
									
									my $str = pop (@temp);
									my $pattern1 = '(\d+)';
									my $work_for_content = work_for_content -> new ($str); 
									my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											$_ =~ s/^\s+//;
											$_ =~ s/\s+$//;
											$str = $_;
										}
									}
									
									push (@array1 , '<round_id>'.$str.'</round_id>');
								}
							}
						}
						
						$pattern1 = '^(.+)$';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								my $str = $_;
								push (@array1 , '<round_name>'.$str.'</round_name>');
							}
						}
					}
				}
				
				if (scalar (@array1) > 0) {
					my $str = join ('', @array1);
					push (@array, $str);
				}
			}
		} 
		
		

		#round вариант 2 то что красным, если expanded не нашлось
		$pattern1 = '(<li class="current leaf">.+?</li>)';		
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				my @array1 = ();
				my $pattern1 = '(<a.+?</a>)';
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
								
								$_ =~ s/\/$//;
								
								
								my @temp = split ('/', $_);
								if (scalar (@temp) > 0) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										
										$_ =~ s/^\s+//;
										$_ =~ s/\s+$//;
										$_ =~ s/^\s+$//;
										$_ =~ s/r//;
									}
									
									my $str = pop (@temp);
									my $pattern1 = '(\d+)';
									my $work_for_content = work_for_content -> new ($str); 
									my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											$_ =~ s/^\s+//;
											$_ =~ s/\s+$//;
											$str = $_;
										}
									}
									
									push (@array1 , '<round_id>'.$str.'</round_id>');
								}
							}
						}
						
						$pattern1 = '^(.+)$';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								my $str = $_;
								push (@array1 , '<round_name>'.$str.'</round_name>');
							}
						}
					}
				}
				
				if (scalar (@array1) > 0) {
					my $str = join ('', @array1);
					push (@array, $str);
				}
			}
		} 
		
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		
		#Id - идентификатор матча,
		@array = ();
		$pattern1 = '^(.+)$';
		$work_for_content = work_for_content -> new ($url); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$_ =~ s/\/$//;
				
				my @temp = split ('/', $_);
				if (scalar (@temp) > 0) {
					foreach (@temp) {
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						$_ =~ s/^\s+//;
						$_ =~ s/\s+$//;
						$_ =~ s/^\s+$//;
					}
					# pop (@temp); 
					push (@array , pop (@temp));
				}
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		# Referee
		@array = ();
		$pattern1 = '<td>Referee:</td>(.+?</td>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				
				my @array1 = ();
				my $pattern1 = '(<a.+?</a>)';
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
								
								$_ =~ s/\/$//;
								
								if ($_ !~ /^http/) {
									$_ = 'http://'.$host.$_;
								}
								
								my $href = $_;
								
								my @temp = split ('/', $_);
								if (scalar (@temp) > 0) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										
										$_ =~ s/^\s+//;
										$_ =~ s/\s+$//;
										$_ =~ s/^\s+$//;
									}
									my $str = pop (@temp);
									push (@array1 , '<referee_id>'.$str.'</referee_id>');
									$players_url {$str} = $href;
								}
							}
						}
						
						$pattern1 = '^(.+)$';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
							
								my $str = $_;
								push (@array1 , '<referee_name>'.$str.'</referee_name>');
							}
						}
					}
				}
				
				if (scalar (@array1) > 0) {
					my $str = join ('', @array1);
					push (@array, $str);
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		# Assistants:
		@array = ();
		$pattern1 = '<td>Assistants:</td>(.+?</td>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				my $pattern1 = '(<a.+?</a>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						my @array1 = ();
						my $pattern1 = 'href="(.+?)"';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								
								$_ =~ s/\/$//;
								
								if ($_ !~ /^http/) {
									$_ = 'http://'.$host.$_;
								}
								my $href = $_;								
								
								my @temp = split ('/', $_);
								if (scalar (@temp) > 0) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										
										$_ =~ s/^\s+//;
										$_ =~ s/\s+$//;
										$_ =~ s/^\s+$//;
									}
									my $str = pop (@temp);
									push (@array1 , '<assistant_referee_id>'.$str.'</assistant_referee_id>');
									$players_url {$str} = $href;									
								}
							}
						}
						
						$pattern1 = '^(.+)$';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
							
								my $str = $_;
								push (@array1 , '<assistant_referee_name>'.$str.'</assistant_referee_name>');
							}
						}
						
						if (scalar (@array1) > 0) {
							my $str = join ('', @array1);
							push (@array, $str);
						}
					}
				}
				
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		# fourth_official
		@array = ();
		$pattern1 = '<td>Fourth official:</td>(.+?</td>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				my $pattern1 = '(<a.+?</a>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						my @array1 = ();
						my $pattern1 = 'href="(.+?)"';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								
								$_ =~ s/\/$//;
								
								if ($_ !~ /^http/) {
									$_ = 'http://'.$host.$_;
								}
								my $href = $_;								
								
								my @temp = split ('/', $_);
								if (scalar (@temp) > 0) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										
										$_ =~ s/^\s+//;
										$_ =~ s/\s+$//;
										$_ =~ s/^\s+$//;
									}
									my $str = pop (@temp);
									push (@array1 , '<fourth_official_id>'.$str.'</fourth_official_id>');
									$players_url {$str} = $href;	
								}
							}
						}
						
						$pattern1 = '^(.+)$';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
							
								my $str = $_;
								push (@array1 , '<fourth_official_name>'.$str.'</fourth_official_name>');
							}
						}
						
						if (scalar (@array1) > 0) {
							my $str = join ('', @array1);
							push (@array, $str);
						}
					}
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		
		#attendance 
		@array = ();
		$pattern1 = '<dt>Attendance(.+?</dd>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
		
				my $str = '<attendance>'.$_.'</attendance>';
				push (@array , $str);
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		#coach_team_a
		my $count_table = 0;
		@array = ();
		$pattern1 = '(<table class="playerstats lineups table">.+?</table>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$count_table++;
				
				if ($count_table == 1) {
				
					my $pattern1 = '(<strong>Coach:</strong>.+?</td>)';
					my $work_for_content = work_for_content -> new ($_); 
					my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
							
							my $pattern1 = '(<a.+?</a>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									my @array1 = ();
									my $pattern1 = 'href="(.+?)"';
									my $work_for_content = work_for_content -> new ($_); 
									my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											
											$_ =~ s/\/$//;
											if ($_ !~ /^http/) {
												$_ = 'http://'.$host.$_;
											}
											my $href = $_;								
											
											my @temp = split ('/', $_);
											if (scalar (@temp) > 0) {
												foreach (@temp) {
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;		
													
													$_ =~ s/^\s+//;
													$_ =~ s/\s+$//;
													$_ =~ s/^\s+$//;
												}
												my $str = pop (@temp);
												push (@array1 , '<coach_team_a_id>'.$str.'</coach_team_a_id>');
												$players_url {$str} = $href;	
											}
										}
									}
									
									$pattern1 = '^(.+)$';
									$work_for_content = work_for_content -> new ($_); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
										
											my $str = $_;
											push (@array1 , '<coach_team_a_name>'.$str.'</coach_team_a_name>');
										}
									}
									
									if (scalar (@array1) > 0) {
										my $str = join ('', @array1);
										push (@array, $str);
									}
								}
							}
						}
					}
				}
			} 
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		#coach_team_b
		$count_table = 0;
		@array = ();
		$pattern1 = '(<table class="playerstats lineups table">.+?</table>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$count_table++;
				
				if ($count_table == 2) {
				
					my $pattern1 = '(<strong>Coach:</strong>.+?</td>)';
					my $work_for_content = work_for_content -> new ($_); 
					my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
							
							my $pattern1 = '(<a.+?</a>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									my @array1 = ();
									my $pattern1 = 'href="(.+?)"';
									my $work_for_content = work_for_content -> new ($_); 
									my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											
											$_ =~ s/\/$//;
											if ($_ !~ /^http/) {
												$_ = 'http://'.$host.$_;
											}
											my $href = $_;								
											
											my @temp = split ('/', $_);
											if (scalar (@temp) > 0) {
												foreach (@temp) {
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;		
													
													$_ =~ s/^\s+//;
													$_ =~ s/\s+$//;
													$_ =~ s/^\s+$//;
												}
												my $str = pop (@temp);
												push (@array1 , '<coach_team_b_id>'.$str.'</coach_team_b_id>');
												$players_url {$str} = $href;	
											}
										}
									}
									
									$pattern1 = '^(.+)$';
									$work_for_content = work_for_content -> new ($_); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
										
											my $str = $_;
											push (@array1 , '<coach_team_b_name>'.$str.'</coach_team_b_name>');
										}
									}
									
									if (scalar (@array1) > 0) {
										my $str = join ('', @array1);
										push (@array, $str);
									}
								}
							}
						}
					}
				}
			} 
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#Date
		my $date = '-';
		@array = ();
		$pattern1 = '(<div class="details.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				my @temp = split ('<span class="divider"><\/span>', $_);
				if (scalar (@temp) > 0) {
					foreach (@temp) {
		
						my $pattern1 = 'href="(.+?)"';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								
								if ($_ =~ /\d{4}\/\d{2}\/\d{2}/) {
								
									$_ =~ s/\/$//;
									
									my @temp = split ('/', $_);
									if (scalar (@temp) > 0) {
										foreach (@temp) {
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;		
											
											$_ =~ s/^\s+//;
											$_ =~ s/\s+$//;
											$_ =~ s/^\s+$//;
										}
										my $day = pop (@temp);
										my $month = pop (@temp);
										my $year = pop (@temp);
										
										push (@array , $year.'-'.$month.'-'.$day);
									}
								}
							}
						}
					}
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
			$date = $array[0];
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#time
		my $time = '-';
		@array = ();
		$pattern1 = '(<div class="details.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				my @temp = split ('<span class="divider"><\/span>', $_);
				if (scalar (@temp) > 0) {
					foreach (@temp) {
						
						if ($_ =~ /timestamp/) {
		
							my $pattern1 = '(<span.+?</span>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
					
									$_ =~ s/^\s+//;
									$_ =~ s/\s+$//;
									$_ =~ s/^\s+$//;
									if ($_ =~ /\d{2}:\d{2}/) {
										push (@array, $_);
									}
								}
							}
						}
					}
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put (pop (@array));
			$time = $array[0];	
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		#status
		@array = ();
		$pattern1 = '(<h3 class="thick scoretime.+?</h3>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				# $_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				my $pattern1 = '(<span class="match-state">.+?</span>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_3_s ();
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
		
						$_ = entities_decode ($_);	
						
						$_ =~ s/^\s+//;
						$_ =~ s/\s+$//;
						$_ =~ s/^\s+$//;
						
						if ($_ !~ /:/) {
							push (@array, $_);
						}
					}
				}
			}
		} 
		

		if (scalar (@array) == 0) { 

			my $pattern1 = '(<div class="container middle.+?</div>)';
			my $work_for_content = work_for_content -> new ($content1); 
			my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
			if (defined $work_for_content_result -> [0]) {
				foreach (@$work_for_content_result) {		
					my $clear_str = clear_str -> new ($_);
					# $_ = $clear_str -> delete_3_s ();
					$_ = $clear_str -> delete_4 ();
					$clear_str = undef;		
					
					my $pattern1 = '(<span class="details".+?</span>)';
					my $work_for_content = work_for_content -> new ($_); 
					my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_3_s ();
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
			
							$_ = entities_decode ($_);	
							
							$_ =~ s/^\s+//;
							$_ =~ s/\s+$//;
							$_ =~ s/^\s+$//;
							
							push (@array, $_);
							
						}
					}
				}
			} 
		
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		#first_team
		my $first_team_id = '-';
		@array = ();
		$pattern1 = '<div class="match-info".+?<div class="container left".+?(<a class="team-title".+?</a>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				my @array1 = ();
				my $pattern1 = '(<a.+?</a>)';
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
								
								$_ =~ s/\/$//;
								
								my @temp = split ('/', $_);
								if (scalar (@temp) > 0) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										
										$_ =~ s/^\s+//;
										$_ =~ s/\s+$//;
										$_ =~ s/^\s+$//;
									}
									
									my $str = pop (@temp);
									push (@array1 , '<first_team_id>'.$str.'</first_team_id>');
									$first_team_id = $str;

								}
							}
						}
						
						$pattern1 = '^(.+)$';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								my $str = $_;
								push (@array1 , '<first_team_name>'.$str.'</first_team_name>');
							}
						}
					}
				}
				
				if (scalar (@array1) > 0) {
					my $str = join ('', @array1);
					push (@array, $str);
					# print $str ."\n";
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
			
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		#Second_team
		my $second_team_id = '-';
		@array = ();
		$pattern1 = '<div class="match-info".+?<div class="container right".+?(<a class="team-title".+?</a>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				my @array1 = ();
				my $pattern1 = '(<a.+?</a>)';
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
								
								$_ =~ s/\/$//;
								
								my @temp = split ('/', $_);
								if (scalar (@temp) > 0) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										
										$_ =~ s/^\s+//;
										$_ =~ s/\s+$//;
										$_ =~ s/^\s+$//;
									}
									my $str = pop (@temp);
									push (@array1 , '<second_team_id>'.$str.'</second_team_id>');
									$second_team_id = $str;
								}
							}
						}
						
						$pattern1 = '^(.+)$';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								push (@array1 , '<second_team_name>'.$_.'</second_team_name>');
							}
						}
					}
				}
				
				if (scalar (@array1) > 0) {
					my $str = join ('', @array1);
					push (@array, $str);
					# print $str ."\n";
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		
		
		my %player = ();
		# lineups
		$count_table = 0;
		@array = ();
		$pattern1 = '(<table class="playerstats lineups table">.+?</table>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$count_table++;
				
				{
					my $pattern1 = '<thead>.+?</thead>';
					my $pattern2 = '';
					$_ =~ s/$pattern1/$pattern2/g;
				}
				
				my @table = ();
				my $pattern1 = '(<tr.+?</tr>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;

						push (@table, $_);
					}
				}
				
				if (scalar (@table) > 0) {
					foreach (@table) {
					
						my $shirtnumber = '';
						my @array1 = ();
						my $pattern1 = '(<td class="shirtnumber">.+?</td>)';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								$_ =~ s/^\s+//;
								$_ =~ s/\s+$//;
								my $str = $_;
								push  (@array1, '<shirtnumber>'.$str.'</shirtnumber>');
								$shirtnumber = $str;
							}
						}
						
						$pattern1 = '(<td class="player large-link">.+?</td>)';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								
								my $pattern1 = '(<a.+?</a>)';
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
												
												$_ =~ s/\/$//;
												if ($_ !~ /^http/) {
													$_ = 'http://'.$host.$_;
												}
												my $href = $_;								
												
												
												my @temp = split ('/', $_);
												if (scalar (@temp) > 0) {
													foreach (@temp) {
														my $clear_str = clear_str -> new ($_);
														$_ = $clear_str -> delete_4 ();
														$clear_str = undef;		
														
														$_ =~ s/^\s+//;
														$_ =~ s/\s+$//;
														$_ =~ s/^\s+$//;
													}
													
													my $str = pop (@temp);
													push (@array1 , '<lineups_person_id>'.$str.'</lineups_person_id>');
													$player {$str} = $shirtnumber;
													$players_url {$str} = $href;
												}
											}
										}
										
										$pattern1 = '^(.+)$';
										$work_for_content = work_for_content -> new ($_); 
										$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
										if (defined $work_for_content_result -> [0]) {
											foreach (@$work_for_content_result) {		
												my $clear_str = clear_str -> new ($_);
												$_ = $clear_str -> delete_3_s ();
												$_ = $clear_str -> delete_4 ();
												$clear_str = undef;		
												
												$_ =~ s/^\s+//;
												$_ =~ s/\s+$//;
												$_ =~ s/^\s+$//;
												my $str = $_;
												push (@array1 , '<lineups_person_name>'.$str.'</lineups_person_name>');
											}
										}
										
										if ($count_table == 1) {
											push  (@array1, '<team_id>'.$first_team_id.'</team_id>');
											
										} else {
											push  (@array1, '<team_id>'.$second_team_id.'</team_id>');
										}
									}
								}
							}
						}
						
						if (scalar (@array1) > 0) {
							my $str = join ('', @array1);
							push (@array, $str);
						}
					}
				}
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		# <lineups_bench>
		$count_table = 0;
		@array = ();
		$pattern1 = '(<table class="playerstats lineups substitutions table">.+?</table>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$count_table++;
				
				{
					my $pattern1 = '<thead>.+?</thead>';
					my $pattern2 = '';
					$_ =~ s/$pattern1/$pattern2/g;
				}
				
				my @table = ();
				my $pattern1 = '(<tr.+?</tr>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;
						push (@table, $_);
					}
				}
				
				if (scalar (@table) > 0) {
					foreach (@table) {
						
						my $shirtnumber = '';
						my @array1 = ();
						my $pattern1 = '(<td class="shirtnumber">.+?</td>)';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								$_ =~ s/^\s+//;
								$_ =~ s/\s+$//;
								my $str = $_;
								push  (@array1, '<shirtnumber>'.$str.'</shirtnumber>');
								$shirtnumber = $str;
							}
						}
						
						$pattern1 = '(<td class="player large-link">.+?</td>)';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								
								my $pattern1 = '(<p class="substitute substitute-in">.+?</p>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;
										
										my $pattern1 = '(<a.+?</a>)';
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
														
														$_ =~ s/\/$//;
														if ($_ !~ /^http/) {
															$_ = 'http://'.$host.$_;
														}
														my $href = $_;								
														
														
														my @temp = split ('/', $_);
														if (scalar (@temp) > 0) {
															foreach (@temp) {
																my $clear_str = clear_str -> new ($_);
																$_ = $clear_str -> delete_4 ();
																$clear_str = undef;		
																
																$_ =~ s/^\s+//;
																$_ =~ s/\s+$//;
																$_ =~ s/^\s+$//;
															}
															
															my $str = pop (@temp);
															push (@array1 , '<lineups_bench_person_id>'.$str.'</lineups_bench_person_id>');
															$player {$str} = $shirtnumber;
															$players_url {$str} = $href;
														}
													}
												}
												
												$pattern1 = '^(.+)$';
												$work_for_content = work_for_content -> new ($_); 
												$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
												if (defined $work_for_content_result -> [0]) {
													foreach (@$work_for_content_result) {		
														my $clear_str = clear_str -> new ($_);
														$_ = $clear_str -> delete_3_s ();
														$_ = $clear_str -> delete_4 ();
														$clear_str = undef;		
														
														$_ =~ s/^\s+//;
														$_ =~ s/\s+$//;
														$_ =~ s/^\s+$//;
														
														# print $_ ."<br />\n";
														
														my $str = $_;
														push (@array1 , '<lineups_bench_name>'.$str.'</lineups_bench_name>');
													}
												}
												
												
												if ($count_table == 1) {
													push  (@array1, '<team_id>'.$first_team_id.'</team_id>');
													
												} else {
													push  (@array1, '<team_id>'.$second_team_id.'</team_id>');
												}
											}
										}
									}
								}
							}
						}
						
						if (scalar (@array1) > 0) {
							my $str = join ('', @array1);
							push (@array, $str);
						}
					}
				}
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		
		#Substitutes
		$count_table = 0;
		@array = ();
		$pattern1 = '(<table class="playerstats lineups substitutions table">.+?</table>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$count_table++;
				
				{
					my $pattern1 = '<thead>.+?</thead>';
					my $pattern2 = '';
					$_ =~ s/$pattern1/$pattern2/g;
				}
				
				
				my @table = ();
				my $pattern1 = '(<tr.+?</tr>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;

						push (@table, $_);
					}
				}
				
				if (scalar (@table) > 0) {
					foreach (@table) {
						
						my @array1 = ();
						my $tr = $_;
						
						my $pattern1 = '(<td class="player large-link">.+?</td>)';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								
								if ($_ =~ /<p class="substitute substitute-out">/) {
								
									my $pattern1 = '(<p class="substitute substitute-in">.+?</p>)';
									my $work_for_content = work_for_content -> new ($_); 
									my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;
											
											my $pattern1 = '(<a.+?</a>)';
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
															
															$_ =~ s/\/$//;
															if ($_ !~ /^http/) {
																$_ = 'http://'.$host.$_;
															}
															my $href = $_;								
															
															my @temp = split ('/', $_);
															if (scalar (@temp) > 0) {
																foreach (@temp) {
																	my $clear_str = clear_str -> new ($_);
																	$_ = $clear_str -> delete_4 ();
																	$clear_str = undef;		
																	
																	$_ =~ s/^\s+//;
																	$_ =~ s/\s+$//;
																	$_ =~ s/^\s+$//;
																}
																
																my $str = pop (@temp);
																push (@array1 , '<substitutes_in_person_id>'.$str.'</substitutes_in_person_id>');
																$players_url {$str} = $href;
																
																if (exists ($player {$str})) {
																	push  (@array1, '<substitutes_in_person_shirtnumber>'.$player {$str}.'</substitutes_in_person_shirtnumber>');
																	# print '<shirtnumber>'.$player {$str}.'</shirtnumber>' ."\n";
																	
																}
															}
														}
													}
													
													$pattern1 = '^(.+)$';
													$work_for_content = work_for_content -> new ($_); 
													$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
													if (defined $work_for_content_result -> [0]) {
														foreach (@$work_for_content_result) {		
															my $clear_str = clear_str -> new ($_);
															$_ = $clear_str -> delete_3_s ();
															$_ = $clear_str -> delete_4 ();
															$clear_str = undef;		
															
															$_ =~ s/^\s+//;
															$_ =~ s/\s+$//;
															$_ =~ s/^\s+$//;
															my $str = $_;
															push (@array1 , '<substitutes_in_person_name>'.$str.'</substitutes_in_person_name>');
														}
													}
												}
											}
										}
									}
									
									$pattern1 = '(<p class="substitute substitute-out">.+?</p>)';
									$work_for_content = work_for_content -> new ($_); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;
											
											my $tr = $_;
											
											my $pattern1 = '(<a.+?</a>)';
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
															
															$_ =~ s/\/$//;
															if ($_ !~ /^http/) {
																$_ = 'http://'.$host.$_;
															}
															my $href = $_;								
															
															my @temp = split ('/', $_);
															if (scalar (@temp) > 0) {
																foreach (@temp) {
																	my $clear_str = clear_str -> new ($_);
																	$_ = $clear_str -> delete_4 ();
																	$clear_str = undef;		
																	
																	$_ =~ s/^\s+//;
																	$_ =~ s/\s+$//;
																	$_ =~ s/^\s+$//;
																}
																
																my $str = pop (@temp);
																push (@array1 , '<substitutes_out_person_id>'.$str.'</substitutes_out_person_id>');
																$players_url {$str} =  $href;
																
																if (exists ($player {$str})) {
																	push  (@array1, '<substitutes_out_person_shirtnumber>'.$player {$str}.'</substitutes_out_person_shirtnumber>');
																}
															}
														}
													}
													
													$pattern1 = '^(.+)$';
													$work_for_content = work_for_content -> new ($_); 
													$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
													if (defined $work_for_content_result -> [0]) {
														foreach (@$work_for_content_result) {		
															my $clear_str = clear_str -> new ($_);
															$_ = $clear_str -> delete_3_s ();
															$_ = $clear_str -> delete_4 ();
															$clear_str = undef;		
															
															$_ =~ s/^\s+//;
															$_ =~ s/\s+$//;
															$_ =~ s/^\s+$//;
															my $str = $_;
															push (@array1 , '<substitutes_out_person_name>'.$str.'</substitutes_out_person_name>');
														}
													}
													
													$pattern1 = '^(.+)$';
													$work_for_content = work_for_content -> new ($tr); 
													$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
													if (defined $work_for_content_result -> [0]) {
														foreach (@$work_for_content_result) {		
															my $clear_str = clear_str -> new ($_);
															# $_ = $clear_str -> delete_3_s ();
															$_ = $clear_str -> delete_4 ();
															$clear_str = undef;		
															$_ =~ s/^.+<\/a>//;
															$_ =~ s/\'//g;
															$_ =~ s/^\s+//;
															$_ =~ s/\s+$//;
															
															{
																my $clear_str = clear_str -> new ($_);
																$_ = $clear_str -> delete_3_s ();
																$_ = $clear_str -> delete_4 ();
																$clear_str = undef;		
															}
															
															my @temp = split ('\+',$_);
															if (scalar (@temp) > 0) {
																foreach (@temp) {
																	my $clear_str = clear_str -> new ($_);
																	$_ = $clear_str -> delete_3_s ();
																	$_ = $clear_str -> delete_4 ();
																	$clear_str = undef;
																}
																
																if (scalar (@temp) == 2) {
																	my $str = $temp[1];
																	push  (@array1, '<minute_extra>'.$str.'</minute_extra>');
																}
																
																my $str = $temp[0];
																push  (@array1, '<minute>'.$str.'</minute>');
															}
														}
													}
													
													if ($count_table == 1) {
														push  (@array1, '<team_id>'.$first_team_id.'</team_id>');
														
													} else {
														push  (@array1, '<team_id>'.$second_team_id.'</team_id>');
													}
												}
											}
										}
									}
								}
							}
						}
						
						
						if (scalar (@array1) > 0) {
							my $str = join ('', @array1);
							push (@array, $str);
							# print $str ."\n";
						}
					}
				}
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		
		# <goal> team_a
		$count_table = 0;
		@array = ();
		$pattern1 = '(<h2>Goals</h2>.+?<table class="matches events">.+?</table>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$count_table++;
				
				{
					my $pattern1 = '<thead>.+?</thead>';
					my $pattern2 = '';
					$_ =~ s/$pattern1/$pattern2/g;
				}
				
				my @table = ();
				my $pattern1 = '(<tr.+?</tr>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;
						push (@table, $_);
					}
				}
				
				if (scalar (@table) > 0) {
					foreach (@table) {
						
						my $pattern1 = '(<td class="player player-a">.+?</td>)';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								
								if ($_ =~ /href/) {
								
									my @array1 = ();
									my $player_content = $_;
									
									$_ =~ s/<span class="assist">.+$//;
									
									my $pattern1 = '(<a.+?</a>)';
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
											
													my $pattern1 = '/(\d+)/$';
													my $work_for_content = work_for_content -> new ($_); 
													my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
													if (defined $work_for_content_result -> [0]) {
														foreach (@$work_for_content_result) {		
															my $clear_str = clear_str -> new ($_);
															$_ = $clear_str -> delete_4 ();
															$clear_str = undef;
											
															$_ =~ s/^\s+//;
															$_ =~ s/\s+$//;
															my $str = $_;
															
															push  (@array1, '<person_id>'.$str.'</person_id>');
														}
													}
												}
											}
										}
									}
									
									$pattern1 = '(<a.+?</a>)';
									$work_for_content = work_for_content -> new ($_); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;
									
											$_ =~ s/^\s+//;
											$_ =~ s/\s+$//;
											my $str = $_;
											
											push  (@array1, '<person>'.$str.'</person>');
										}
									}
									
									$pattern1 = '(<span class="minute">.+?</span>)';
									$work_for_content = work_for_content -> new ($_); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;
									
											$_ =~ s/\'//;
											$_ =~ s/^\s+//;
											$_ =~ s/\s+$//;
											
											my @temp = split ('\+',$_);
											if (scalar (@temp) > 0) {
												foreach (@temp) {
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_3_s ();
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
												}
												
												if (scalar (@temp) == 2) {
													my $str = $temp[1];
													push  (@array1, '<minute_extra>'.$str.'</minute_extra>');
												}
												
												my $str = $temp[0];
												push  (@array1, '<minute>'.$str.'</minute>');
											}
										}
									}
									
									$pattern1 = '(<span class="assist">.+?</span>)';
									$work_for_content = work_for_content -> new ($player_content); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;
									
											my $pattern1 = '(<a.+?</a>)';
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
													
															my $pattern1 = '/(\d+)/$';
															my $work_for_content = work_for_content -> new ($_); 
															my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
															if (defined $work_for_content_result -> [0]) {
																foreach (@$work_for_content_result) {		
																	my $clear_str = clear_str -> new ($_);
																	$_ = $clear_str -> delete_4 ();
																	$clear_str = undef;
													
																	$_ =~ s/^\s+//;
																	$_ =~ s/\s+$//;
																	my $str = $_;
																	
																	push  (@array1, '<assist_id>'.$str.'</assist_id>');
																}
															}
														}
													}
												}
											}
											
											$pattern1 = '(<a.+?</a>)';
											$work_for_content = work_for_content -> new ($_); 
											$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
											if (defined $work_for_content_result -> [0]) {
												foreach (@$work_for_content_result) {		
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_3_s ();
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
											
													$_ =~ s/^\s+//;
													$_ =~ s/\s+$//;
													my $str = $_;
													
													push  (@array1, '<assist_name>'.$str.'</assist_name>');
												}
											}
										}
									}
									
									push  (@array1, '<team_id>'.$first_team_id.'</team_id>');
									if (scalar (@array1) > 0) {
										my $str = join ('', @array1);
										push (@array, $str);
									}
								}
							}
						}
					}
				}
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		


		# <goal> team_b
		$count_table = 0;
		@array = ();
		$pattern1 = '(<h2>Goals</h2>.+?<table class="matches events">.+?</table>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$count_table++;
				
				{
					my $pattern1 = '<thead>.+?</thead>';
					my $pattern2 = '';
					$_ =~ s/$pattern1/$pattern2/g;
				}
				
				my @table = ();
				my $pattern1 = '(<tr.+?</tr>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;
						push (@table, $_);
					}
				}
				
				if (scalar (@table) > 0) {
					foreach (@table) {
						
						my $pattern1 = '(<td class="player player-b">.+?</td>)';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								
								if ($_ =~ /href/) {
								
									my @array1 = ();
									my $player_content = $_;
									
									$_ =~ s/<span class="assist">.+$//;
									
									my $pattern1 = '(<a.+?</a>)';
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
											
													my $pattern1 = '/(\d+)/$';
													my $work_for_content = work_for_content -> new ($_); 
													my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
													if (defined $work_for_content_result -> [0]) {
														foreach (@$work_for_content_result) {		
															my $clear_str = clear_str -> new ($_);
															$_ = $clear_str -> delete_4 ();
															$clear_str = undef;
											
															$_ =~ s/^\s+//;
															$_ =~ s/\s+$//;
															
															my $str = $_;
															push  (@array1, '<person_id>'.$str.'</person_id>');
														}
													}
												}
											}
										}
									}
									
									$pattern1 = '(<a.+?</a>)';
									$work_for_content = work_for_content -> new ($_); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;
									
											$_ =~ s/^\s+//;
											$_ =~ s/\s+$//;
											my $str = $_;
											
											push  (@array1, '<person>'.$str.'</person>');
										}
									}
									
									$pattern1 = '(<span class="minute">.+?</span>)';
									$work_for_content = work_for_content -> new ($_); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_3_s ();
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;
									
											$_ =~ s/\'//;
											$_ =~ s/^\s+//;
											$_ =~ s/\s+$//;
											
											my @temp = split ('\+',$_);
											if (scalar (@temp) > 0) {
												foreach (@temp) {
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_3_s ();
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
												}
												
												if (scalar (@temp) == 2) {
													my $str = $temp[1];
													push  (@array1, '<minute_extra>'.$str.'</minute_extra>');
												}
												
												my $str = $temp[0];
												push  (@array1, '<minute>'.$str.'</minute>');
											}
										}
									}
									
									$pattern1 = '(<span class="assist">.+?</span>)';
									$work_for_content = work_for_content -> new ($player_content); 
									$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;
									
											my $pattern1 = '(<a.+?</a>)';
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
													
															my $pattern1 = '/(\d+)/$';
															my $work_for_content = work_for_content -> new ($_); 
															my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
															if (defined $work_for_content_result -> [0]) {
																foreach (@$work_for_content_result) {		
																	my $clear_str = clear_str -> new ($_);
																	$_ = $clear_str -> delete_4 ();
																	$clear_str = undef;
													
																	$_ =~ s/^\s+//;
																	$_ =~ s/\s+$//;
																	
																	my $str = $_;
																	push  (@array1, '<assist_id>'.$str.'</assist_id>');
																}
															}
														}
													}
												}
											}
											
											$pattern1 = '(<a.+?</a>)';
											$work_for_content = work_for_content -> new ($_); 
											$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
											if (defined $work_for_content_result -> [0]) {
												foreach (@$work_for_content_result) {		
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_3_s ();
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
											
													$_ =~ s/^\s+//;
													$_ =~ s/\s+$//;
													
													my $str = $_;
													push  (@array1, '<assist_name>'.$str.'</assist_name>');
												}
											}
										}
									}
									
									push  (@array1, '<team_id>'.$second_team_id.'</team_id>');
									
									if (scalar (@array1) > 0) {
										my $str = join ('', @array1);
										push (@array, $str);
									}
								}
							}
						}
					}
				}
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		


		#bookings  (карточки)
		$count_table = 0;
		@array = ();
		$pattern1 = '(<table class="playerstats lineups table">.+?</table>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$count_table++;
				
				{
					my $pattern1 = '<thead>.+?</thead>';
					my $pattern2 = '';
					$_ =~ s/$pattern1/$pattern2/g;
				}
				
				my @table = ();
				my $pattern1 = '(<tr.+?</tr>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;

						push (@table, $_);
					}
				}
				
				if (scalar (@table) > 0) {
					foreach (@table) {
						my $content_all = $_;
						
						my $pattern1 = '(<td class="bookings">.+?</td>)';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								
								my $pattern1 = '(<span.+?</span>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;
										
										if ($_ !~ /G.png/i) {
										
											my @array1 = ();
											my $booking_content = $_;
											
											{
												my $clear_str = clear_str -> new ($booking_content);
												$booking_content = $clear_str -> delete_3_s ();
												$booking_content = $clear_str -> delete_4 ();
												$clear_str = undef;
											
												$booking_content =~ s/\'//;
												$booking_content =~ s/^\s+//;
												$booking_content =~ s/\s+$//;
											
												my @temp = split ('\+',$booking_content);
												if (scalar (@temp) > 0) {
													foreach (@temp) {
														my $clear_str = clear_str -> new ($_);
														$_ = $clear_str -> delete_3_s ();
														$_ = $clear_str -> delete_4 ();
														$clear_str = undef;
													}
													
													if (scalar (@temp) == 2) {
														my $str = $temp[1];
														push  (@array1, '<minute_extra>'.$str.'</minute_extra>');
													}
													
													my $str = $temp[0];
													push  (@array1, '<minute>'.$str.'</minute>');
												}
											}
											
											
											my $code = '-';
											my $pattern1 = '<img.+?src.+?"(.+?)"';
											my $work_for_content = work_for_content -> new ($_); 
											my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
											if (defined $work_for_content_result -> [0]) {
												foreach (@$work_for_content_result) {		
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
													
													$_ =~ s/^.+\///;
													$_ =~ s/\.png//;
											
													$_ =~ s/^\s+//;
													$_ =~ s/\s+$//;
													my $str = $_;
													push (@array1 , '<code>'.$str.'</code>');
													$code = $_;
												}
											}
											
											$pattern1 = '(<td class="player large-link">.+?</td>)';
											$work_for_content = work_for_content -> new ($content_all); 
											$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
											if (defined $work_for_content_result -> [0]) {
												foreach (@$work_for_content_result) {		
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
													
													my $pattern1 = '(<a.+?</a>)';
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
																	
																	$_ =~ s/\/$//;
																	
																	my @temp = split ('/', $_);
																	if (scalar (@temp) > 0) {
																		foreach (@temp) {
																			my $clear_str = clear_str -> new ($_);
																			$_ = $clear_str -> delete_4 ();
																			$clear_str = undef;		
																			
																			$_ =~ s/^\s+//;
																			$_ =~ s/\s+$//;
																			$_ =~ s/^\s+$//;
																		}
																		
																		my $str = pop (@temp);
																		push (@array1 , '<person_id>'.$str.'</person_id>');
																	}
																}
															}
															
															$pattern1 = '^(.+)$';
															$work_for_content = work_for_content -> new ($_); 
															$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
															if (defined $work_for_content_result -> [0]) {
																foreach (@$work_for_content_result) {		
																	my $clear_str = clear_str -> new ($_);
																	$_ = $clear_str -> delete_3_s ();
																	$_ = $clear_str -> delete_4 ();
																	$clear_str = undef;		
																	
																	$_ =~ s/^\s+//;
																	$_ =~ s/\s+$//;
																	$_ =~ s/^\s+$//;
																	my $str = $_;
																	push (@array1 , '<person>'.$str.'</person>');
																}
															}
															
															my %name = (
																'YC' => 'Yellow card',
																'Y2C' => 'Yellow 2nd/RC',
																'RC' => 'Red card',
															);
															
															if (exists ($name {$code})) {
																push  (@array1, '<name>'.$name {$code}.'</name>');
															}
															
															if ($count_table == 1) {
																push  (@array1, '<team_id>'.$first_team_id.'</team_id>');
																# print '<team_id>'.$first_team_id.'</team_id>' ."\n";
															} else {
																push  (@array1, '<team_id>'.$second_team_id.'</team_id>');
																# print '<team_id>'.$second_team_id.'</team_id>' ."\n";
															}
														}
													}
												}
											}
											
											if (scalar (@array1) > 0) {
												my $str = join ('', @array1);
												push (@array, $str);
												# print $str  ."\n";
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		$count_table = 0;
		$pattern1 = '(<table class="playerstats lineups substitutions table">.+?</table>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$count_table++;
				
				{
					my $pattern1 = '<thead>.+?</thead>';
					my $pattern2 = '';
					$_ =~ s/$pattern1/$pattern2/g;
				}
				
				my @table = ();
				my $pattern1 = '(<tr.+?</tr>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;

						push (@table, $_);
					}
				}
				
				if (scalar (@table) > 0) {
					foreach (@table) {
						my $content_all = $_;
						
						my $pattern1 = '(<td class="bookings">.+?</td>)';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								
								my $pattern1 = '(<span.+?</span>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;
										
										if ($_ !~ /G.png/i) {
										
											my @array1 = ();
											my $booking_content = $_;
											
											{
												my $clear_str = clear_str -> new ($booking_content);
												$booking_content = $clear_str -> delete_3_s ();
												$booking_content = $clear_str -> delete_4 ();
												$clear_str = undef;
											
												$booking_content =~ s/\'//;
												$booking_content =~ s/^\s+//;
												$booking_content =~ s/\s+$//;
											
												my @temp = split ('\+',$booking_content);
												if (scalar (@temp) > 0) {
													foreach (@temp) {
														my $clear_str = clear_str -> new ($_);
														$_ = $clear_str -> delete_3_s ();
														$_ = $clear_str -> delete_4 ();
														$clear_str = undef;
													}
													
													if (scalar (@temp) == 2) {
														my $str = $temp[1];
														push  (@array1, '<minute_extra>'.$str.'</minute_extra>');
													}
													
													my $str = $temp[0];
													push  (@array1, '<minute>'.$str.'</minute>');
												}
											}
											
											
											my $code = '-';
											my $pattern1 = '<img.+?src.+?"(.+?)"';
											my $work_for_content = work_for_content -> new ($_); 
											my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
											if (defined $work_for_content_result -> [0]) {
												foreach (@$work_for_content_result) {		
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
													
													$_ =~ s/^.+\///;
													$_ =~ s/\.png//;
											
													$_ =~ s/^\s+//;
													$_ =~ s/\s+$//;
													my $str = $_;
													push (@array1 , '<code>'.$str.'</code>');
													$code = $_;
												}
											}
											
											$pattern1 = '(<td class="player large-link">.+?</td>)';
											$work_for_content = work_for_content -> new ($content_all); 
											$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
											if (defined $work_for_content_result -> [0]) {
												foreach (@$work_for_content_result) {		
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
													
													my $pattern1 = '(<p class="substitute substitute-in">.+?</p>)';
													my $work_for_content = work_for_content -> new ($_); 
													my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
													if (defined $work_for_content_result -> [0]) {
														foreach (@$work_for_content_result) {		
															my $clear_str = clear_str -> new ($_);
															$_ = $clear_str -> delete_4 ();
															$clear_str = undef;
													
															my $pattern1 = '(<a.+?</a>)';
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
																			
																			$_ =~ s/\/$//;
																			
																			my @temp = split ('/', $_);
																			if (scalar (@temp) > 0) {
																				foreach (@temp) {
																					my $clear_str = clear_str -> new ($_);
																					$_ = $clear_str -> delete_4 ();
																					$clear_str = undef;		
																					
																					$_ =~ s/^\s+//;
																					$_ =~ s/\s+$//;
																					$_ =~ s/^\s+$//;
																				}
																				
																				my $str = pop (@temp);
																				push (@array1 , '<person_id>'.$str.'</person_id>');
																			}
																		}
																	}
																	
																	$pattern1 = '^(.+)$';
																	$work_for_content = work_for_content -> new ($_); 
																	$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
																	if (defined $work_for_content_result -> [0]) {
																		foreach (@$work_for_content_result) {		
																			my $clear_str = clear_str -> new ($_);
																			$_ = $clear_str -> delete_3_s ();
																			$_ = $clear_str -> delete_4 ();
																			$clear_str = undef;		
																			
																			$_ =~ s/^\s+//;
																			$_ =~ s/\s+$//;
																			$_ =~ s/^\s+$//;
																			my $str = $_;
																			push (@array1 , '<person>'.$str.'</person>');
																		}
																	}
																	
																	my %name = (
																		'YC' => 'Yellow card',
																		'Y2C' => 'Yellow 2nd/RC',
																		'RC' => 'Red card',
																	);
																	
																	if (exists ($name {$code})) {
																		push  (@array1, '<name>'.$name {$code}.'</name>');
																	}
																	
																	if ($count_table == 1) {
																		push  (@array1, '<team_id>'.$first_team_id.'</team_id>');
																		# print '<team_id>'.$first_team_id.'</team_id>' ."\n";
																	} else {
																		push  (@array1, '<team_id>'.$second_team_id.'</team_id>');
																		# print '<team_id>'.$second_team_id.'</team_id>' ."\n";
																	}
																}
															}
														}
													}
												}
											}
											
											if (scalar (@array1) > 0) {
												my $str = join ('', @array1);
												push (@array, $str);
												# print $str ."\n";
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		
		#Penalty shootout (пенальти после матча
		$count_table = 0;
		@array = ();
		$pattern1 = '(<div class="block_match_penalty_shootout.+?</ul>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$count_table++;
				
				{
					my $pattern1 = '<thead>.+?</thead>';
					my $pattern2 = '';
					$_ =~ s/$pattern1/$pattern2/g;
				}
				
				my @table = ();
				my $pattern1 = '(<li.+?</li>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;
						push (@table, $_);
					}
				}
				
				if (scalar (@table) > 0) {
					foreach (@table) {
						
						my $count_scorer = 0;
						my $pattern1 = '(<span class="scorer">.+?</span>)';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								
								$count_scorer++;
								if ($count_scorer == 1) {
									
									if ($_ =~ /href/) {
									
										my @array1 = ();
										my $player_content = $_;
										my $code = '';
										
										my $pattern1 = '(<a.+?</a>)';
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
												
														my $pattern1 = '/(\d+)/$';
														my $work_for_content = work_for_content -> new ($_); 
														my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
														if (defined $work_for_content_result -> [0]) {
															foreach (@$work_for_content_result) {		
																my $clear_str = clear_str -> new ($_);
																$_ = $clear_str -> delete_4 ();
																$clear_str = undef;
												
																$_ =~ s/^\s+//;
																$_ =~ s/\s+$//;
																my $str = $_;
																
																push  (@array1, '<person_id>'.$str.'</person_id>');
															}
														}
													}
												}
											}
										}
										
										$pattern1 = '(<a.+?</a>)';
										$work_for_content = work_for_content -> new ($_); 
										$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
										if (defined $work_for_content_result -> [0]) {
											foreach (@$work_for_content_result) {		
												my $clear_str = clear_str -> new ($_);
												$_ = $clear_str -> delete_3_s ();
												$_ = $clear_str -> delete_4 ();
												$clear_str = undef;
										
												$_ =~ s/^\s+//;
												$_ =~ s/\s+$//;
												my $str = $_;
												
												push  (@array1, '<person>'.$str.'</person>');
											}
										}
										
										$pattern1 = '(<img.+?>)';
										$work_for_content = work_for_content -> new ($_); 
										$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
										if (defined $work_for_content_result -> [0]) {
											foreach (@$work_for_content_result) {		
												my $clear_str = clear_str -> new ($_);
												$_ = $clear_str -> delete_4 ();
												$clear_str = undef;
												
												my $pattern1 = 'src="(.+?)"';
												my $work_for_content = work_for_content -> new ($_); 
												my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
												if (defined $work_for_content_result -> [0]) {
													foreach (@$work_for_content_result) {		
														my $clear_str = clear_str -> new ($_);
														$_ = $clear_str -> delete_4 ();
														$clear_str = undef;
												
														$_ =~ s/^.+\///;
														$_ =~ s/\.png$//i;
														
														$_ =~ s/^\s+//;
														$_ =~ s/\s+$//;
														
														my $str = $_;
														push  (@array1, '<code>'.$str.'</code>');
														$code = $str;
													}
												}
											}
										}
										
										my $name = '';
										if ($code eq 'PSG') {$name = 'Penalty shootout goal';} 
										if ($code eq 'PSM') {$name = 'Penalty shootout miss';} 
										push  (@array1, '<name>'.$name.'</name>');
										
										
										push  (@array1, '<team_id>'.$first_team_id.'</team_id>');
										
										if (scalar (@array1) > 0) {
											my $str = join ('', @array1);
											push (@array, $str);
											# print $str ."\n";
										}
									}
								}
							}
						}
					}
				}	
				
				if (scalar (@table) > 0) {
					foreach (@table) {
						
						my $count_scorer = 0;
						my $pattern1 = '(<span class="scorer">.+?</span>)';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								
								$count_scorer++;
								if ($count_scorer == 2) {
									
									if ($_ =~ /href/) {
									
										my @array1 = ();
										my $player_content = $_;
										my $code = '';
										
										my $pattern1 = '(<a.+?</a>)';
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
												
														my $pattern1 = '/(\d+)/$';
														my $work_for_content = work_for_content -> new ($_); 
														my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
														if (defined $work_for_content_result -> [0]) {
															foreach (@$work_for_content_result) {		
																my $clear_str = clear_str -> new ($_);
																$_ = $clear_str -> delete_4 ();
																$clear_str = undef;
												
																$_ =~ s/^\s+//;
																$_ =~ s/\s+$//;
																my $str = $_;
																
																push  (@array1, '<person_id>'.$str.'</person_id>');
															}
														}
													}
												}
											}
										}
										
										$pattern1 = '(<a.+?</a>)';
										$work_for_content = work_for_content -> new ($_); 
										$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
										if (defined $work_for_content_result -> [0]) {
											foreach (@$work_for_content_result) {		
												my $clear_str = clear_str -> new ($_);
												$_ = $clear_str -> delete_3_s ();
												$_ = $clear_str -> delete_4 ();
												$clear_str = undef;
										
												$_ =~ s/^\s+//;
												$_ =~ s/\s+$//;
												my $str = $_;
												
												push  (@array1, '<person>'.$str.'</person>');
											}
										}
										
										$pattern1 = '(<img.+?>)';
										$work_for_content = work_for_content -> new ($_); 
										$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
										if (defined $work_for_content_result -> [0]) {
											foreach (@$work_for_content_result) {		
												my $clear_str = clear_str -> new ($_);
												$_ = $clear_str -> delete_4 ();
												$clear_str = undef;
												
												my $pattern1 = 'src="(.+?)"';
												my $work_for_content = work_for_content -> new ($_); 
												my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
												if (defined $work_for_content_result -> [0]) {
													foreach (@$work_for_content_result) {		
														my $clear_str = clear_str -> new ($_);
														$_ = $clear_str -> delete_4 ();
														$clear_str = undef;
												
														$_ =~ s/^.+\///;
														$_ =~ s/\.png$//i;
														
														$_ =~ s/^\s+//;
														$_ =~ s/\s+$//;
														
														my $str = $_;
														push  (@array1, '<code>'.$str.'</code>');
														$code = $str;
													}
												}
											}
										}
										
										my $name = '';
										if ($code eq 'PSG') {$name = 'Penalty shootout goal';} 
										if ($code eq 'PSM') {$name = 'Penalty shootout miss';} 
										push  (@array1, '<name>'.$name.'</name>');
										
										
										push  (@array1, '<team_id>'.$second_team_id.'</team_id>');
										
										if (scalar (@array1) > 0) {
											my $str = join ('', @array1);
											push (@array, $str);
											# print $str ."\n";
										}
									}
								}
							}
						}
					}
				}	
			}
		}
		
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#fs_A
		@array = ();
		$pattern1 = '(<h3 class="thick scoretime.+?</h3>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				# $_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	
				$_=~ s/<span.+?<\/span>//g;
				$_=~ s/\(.+?\)//g;
				
				my $pattern1 = '(<h3 class="thick scoretime.+?</h3>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_3_s ();
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						my @temp = split ('-', $_);
						if (scalar (@temp) > 1) {
							foreach (@temp) {
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								
								$_ =~ s/^\s+//;
								$_ =~ s/\s+$//;
								$_ =~ s/^\s+$//;
							}
							push (@array, $temp[0]);
							
						} else {
							push (@array, 0);
						}	
					}
				} 
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#fs_B
		@array = ();
		$pattern1 = '(<h3 class="thick scoretime.+?</h3>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				# $_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	
				$_=~ s/<span.+?<\/span>//g;
				$_=~ s/\(.+?\)//g;
				
				my $pattern1 = '(<h3 class="thick scoretime.+?</h3>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_3_s ();
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						my @temp = split ('-', $_);
						if (scalar (@temp) > 1) {
							foreach (@temp) {
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								
								$_ =~ s/^\s+//;
								$_ =~ s/\s+$//;
								$_ =~ s/^\s+$//;
							}
							
							push (@array, $temp[1]);
							
						} else {
							push (@array, 0);
						}	
					}
				} 
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#GOALS new
		@array = ();
		$pattern1 = '(<table class="playerstats lineups table">.+?</table>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$count_table++;
				
				{
					my $pattern1 = '<thead>.+?</thead>';
					my $pattern2 = '';
					$_ =~ s/$pattern1/$pattern2/g;
				}
				
				my @table = ();
				my $pattern1 = '(<tr.+?</tr>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;

						push (@table, $_);
					}
				}
				
				if (scalar (@table) > 0) {
					foreach (@table) {
						my $content_all = $_;
						
						my $pattern1 = '(<td class="bookings">.+?</td>)';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								
								my $pattern1 = '(<span.+?</span>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;
										
										if ($_ =~ /G.png/i) {
										
											my @array1 = ();
											my $booking_content = $_;
											
											{
												my $clear_str = clear_str -> new ($booking_content);
												$booking_content = $clear_str -> delete_3_s ();
												$booking_content = $clear_str -> delete_4 ();
												$clear_str = undef;
											
												$booking_content =~ s/\'//;
												$booking_content =~ s/^\s+//;
												$booking_content =~ s/\s+$//;
											
												my @temp = split ('\+',$booking_content);
												if (scalar (@temp) > 0) {
													foreach (@temp) {
														my $clear_str = clear_str -> new ($_);
														$_ = $clear_str -> delete_3_s ();
														$_ = $clear_str -> delete_4 ();
														$clear_str = undef;
													}
													
													if (scalar (@temp) == 2) {
														my $str = $temp[1];
														push  (@array1, '<minute_extra>'.$str.'</minute_extra>');
													}
													
													my $str = $temp[0];
													push  (@array1, '<minute>'.$str.'</minute>');
												}
											}
											
											
											my $code = '-';
											my $pattern1 = '<img.+?src.+?"(.+?)"';
											my $work_for_content = work_for_content -> new ($_); 
											my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
											if (defined $work_for_content_result -> [0]) {
												foreach (@$work_for_content_result) {		
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
													
													$_ =~ s/^.+\///;
													$_ =~ s/\.png//;
											
													$_ =~ s/^\s+//;
													$_ =~ s/\s+$//;
													my $str = $_;
													push (@array1 , '<code>'.$str.'</code>');
													$code = $_;
												}
											}
											
											$pattern1 = '(<td class="player large-link">.+?</td>)';
											$work_for_content = work_for_content -> new ($content_all); 
											$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
											if (defined $work_for_content_result -> [0]) {
												foreach (@$work_for_content_result) {		
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
													
													my $pattern1 = '(<a.+?</a>)';
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
																	
																	$_ =~ s/\/$//;
																	
																	my @temp = split ('/', $_);
																	if (scalar (@temp) > 0) {
																		foreach (@temp) {
																			my $clear_str = clear_str -> new ($_);
																			$_ = $clear_str -> delete_4 ();
																			$clear_str = undef;		
																			
																			$_ =~ s/^\s+//;
																			$_ =~ s/\s+$//;
																			$_ =~ s/^\s+$//;
																		}
																		
																		my $str = pop (@temp);
																		push (@array1 , '<person_id>'.$str.'</person_id>');
																	}
																}
															}
															
															$pattern1 = '^(.+)$';
															$work_for_content = work_for_content -> new ($_); 
															$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
															if (defined $work_for_content_result -> [0]) {
																foreach (@$work_for_content_result) {		
																	my $clear_str = clear_str -> new ($_);
																	$_ = $clear_str -> delete_3_s ();
																	$_ = $clear_str -> delete_4 ();
																	$clear_str = undef;		
																	
																	$_ =~ s/^\s+//;
																	$_ =~ s/\s+$//;
																	$_ =~ s/^\s+$//;
																	my $str = $_;
																	push (@array1 , '<person>'.$str.'</person>');
																}
															}
															
															my %name = (
																'OG' => 'Own goal',
																'G' => 'Goal',
																'PG' => 'Penalty goal',
															);
															
															if (exists ($name {$code})) {
																push  (@array1, '<name>'.$name {$code}.'</name>');
															}
															
															if ($count_table == 1) {
																push  (@array1, '<team_id>'.$first_team_id.'</team_id>');
																# print '<team_id>'.$first_team_id.'</team_id>' ."\n";
															} else {
																push  (@array1, '<team_id>'.$second_team_id.'</team_id>');
																# print '<team_id>'.$second_team_id.'</team_id>' ."\n";
															}
														}
													}
												}
											}
											
											if (scalar (@array1) > 0) {
												my $str = join ('', @array1);
												push (@array, $str);
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		$count_table = 0;
		$pattern1 = '(<table class="playerstats lineups substitutions table">.+?</table>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				$count_table++;
				
				{
					my $pattern1 = '<thead>.+?</thead>';
					my $pattern2 = '';
					$_ =~ s/$pattern1/$pattern2/g;
				}
				
				my @table = ();
				my $pattern1 = '(<tr.+?</tr>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;

						push (@table, $_);
					}
				}
				
				if (scalar (@table) > 0) {
					foreach (@table) {
						my $content_all = $_;
						
						my $pattern1 = '(<td class="bookings">.+?</td>)';
						my $work_for_content = work_for_content -> new ($_); 
						my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;
								
								my $pattern1 = '(<span.+?</span>)';
								my $work_for_content = work_for_content -> new ($_); 
								my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
								if (defined $work_for_content_result -> [0]) {
									foreach (@$work_for_content_result) {		
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;
										
										if ($_ =~ /G.png/i) {
										
											my @array1 = ();
											my $booking_content = $_;
											
											{
												my $clear_str = clear_str -> new ($booking_content);
												$booking_content = $clear_str -> delete_3_s ();
												$booking_content = $clear_str -> delete_4 ();
												$clear_str = undef;
											
												$booking_content =~ s/\'//;
												$booking_content =~ s/^\s+//;
												$booking_content =~ s/\s+$//;
											
												my @temp = split ('\+',$booking_content);
												if (scalar (@temp) > 0) {
													foreach (@temp) {
														my $clear_str = clear_str -> new ($_);
														$_ = $clear_str -> delete_3_s ();
														$_ = $clear_str -> delete_4 ();
														$clear_str = undef;
													}
													
													if (scalar (@temp) == 2) {
														my $str = $temp[1];
														push  (@array1, '<minute_extra>'.$str.'</minute_extra>');
													}
													
													my $str = $temp[0];
													push  (@array1, '<minute>'.$str.'</minute>');
												}
											}
											
											
											my $code = '-';
											my $pattern1 = '<img.+?src.+?"(.+?)"';
											my $work_for_content = work_for_content -> new ($_); 
											my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
											if (defined $work_for_content_result -> [0]) {
												foreach (@$work_for_content_result) {		
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
													
													$_ =~ s/^.+\///;
													$_ =~ s/\.png//;
											
													$_ =~ s/^\s+//;
													$_ =~ s/\s+$//;
													my $str = $_;
													push (@array1 , '<code>'.$str.'</code>');
													$code = $_;
												}
											}
											
											$pattern1 = '(<td class="player large-link">.+?</td>)';
											$work_for_content = work_for_content -> new ($content_all); 
											$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
											if (defined $work_for_content_result -> [0]) {
												foreach (@$work_for_content_result) {		
													my $clear_str = clear_str -> new ($_);
													$_ = $clear_str -> delete_4 ();
													$clear_str = undef;
													
													my $pattern1 = '(<p class="substitute substitute-in">.+?</p>)';
													my $work_for_content = work_for_content -> new ($_); 
													my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
													if (defined $work_for_content_result -> [0]) {
														foreach (@$work_for_content_result) {		
															my $clear_str = clear_str -> new ($_);
															$_ = $clear_str -> delete_4 ();
															$clear_str = undef;
													
															my $pattern1 = '(<a.+?</a>)';
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
																			
																			$_ =~ s/\/$//;
																			
																			my @temp = split ('/', $_);
																			if (scalar (@temp) > 0) {
																				foreach (@temp) {
																					my $clear_str = clear_str -> new ($_);
																					$_ = $clear_str -> delete_4 ();
																					$clear_str = undef;		
																					
																					$_ =~ s/^\s+//;
																					$_ =~ s/\s+$//;
																					$_ =~ s/^\s+$//;
																				}
																				
																				my $str = pop (@temp);
																				push (@array1 , '<person_id>'.$str.'</person_id>');
																			}
																		}
																	}
																	
																	$pattern1 = '^(.+)$';
																	$work_for_content = work_for_content -> new ($_); 
																	$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
																	if (defined $work_for_content_result -> [0]) {
																		foreach (@$work_for_content_result) {		
																			my $clear_str = clear_str -> new ($_);
																			$_ = $clear_str -> delete_3_s ();
																			$_ = $clear_str -> delete_4 ();
																			$clear_str = undef;		
																			
																			$_ =~ s/^\s+//;
																			$_ =~ s/\s+$//;
																			$_ =~ s/^\s+$//;
																			my $str = $_;
																			push (@array1 , '<person>'.$str.'</person>');
																		}
																	}
																	
																	my %name = (
																		'OG' => 'Own goal',
																		'G' => 'Goal',
																		'PG' => 'Penalty goal',
																	);
																	
																	if (exists ($name {$code})) {
																		push  (@array1, '<name>'.$name {$code}.'</name>');
																		push  (@array1, '<code>'.$code.'</code>');
																	}
																	
																	if ($count_table == 1) {
																		push  (@array1, '<team_id>'.$first_team_id.'</team_id>');
																		# print '<team_id>'.$first_team_id.'</team_id>' ."\n";
																	} else {
																		push  (@array1, '<team_id>'.$second_team_id.'</team_id>');
																		# print '<team_id>'.$second_team_id.'</team_id>' ."\n";
																	}
																}
															}
														}
													}
												}
											}
											
											if (scalar (@array1) > 0) {
												my $str = join ('', @array1);
												push (@array, $str);
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		


		#date_time
		# $write_to_txt1 -> put (get_date_time ($date, $time));
		@array = ();
		$pattern1 = '(<div class="details.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				# $_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				my $pattern1 = 'data-value=\'(.+?)\'';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_3_s ();
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
			
						$_ =~ s/^\s+//;
						$_ =~ s/\s+$//;
						$_ =~ s/^\s+$//;
						$_ = get_date_time2 ($_);
						push (@array, $_);
					}
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
			$time = $array[0];
		} else {
			$write_to_txt1 -> put ('-');
		}		


		#urls
		@array = ();
		if (keys (%players_url) > 0) {
			foreach (keys (%players_url)) {
				# print $_ ."\t".$players_url {$_} ."\n";
				my $str = '<id>'.$_.'</id>'.'<url>'.$players_url {$_} .'</url>';
				push (@array, $str)
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#teams_urls
		#first_team
		@array = ();
		$pattern1 = '<div class="match-info".+?<div class="container left".+?(<a class="team-title".+?</a>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				my @array1 = ();
				my $pattern1 = '(<a.+?</a>)';
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
								
								$_ =~ s/\/$//;
								
								my @temp = split ('/', $_);
								if (scalar (@temp) > 0) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										
										$_ =~ s/^\s+//;
										$_ =~ s/\s+$//;
										$_ =~ s/^\s+$//;
									}
									my $str = pop (@temp);
									push (@array1 , '<team_id>'.$str.'</team_id>');
									$second_team_id = $str;
								}
							}
						}
						
						$pattern1 = 'href="(.+?)"';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								$_ = entities_decode ($_);
								
								if ($_ !~ /^http/) {
									$_ = 'http://'.$host.$_
								}
								
								$_ =~ s/^\s+//;
								$_ =~ s/\s+$//;
								$_ =~ s/^\s+$//;
								
								my $str = $_;
								push (@array1 , '<team_url>'.$str.'</team_url>');
							}
						}
					}
				}
				
				if (scalar (@array1) > 0) {
					my $str = join ('', @array1);
					push (@array, $str);
				}
			}
		} 
		
		
		#Second_team
		$pattern1 = '<div class="match-info".+?<div class="container right".+?(<a class="team-title".+?</a>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				my @array1 = ();
				my $pattern1 = '(<a.+?</a>)';
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
								
								$_ =~ s/\/$//;
								
								my @temp = split ('/', $_);
								if (scalar (@temp) > 0) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
										
										$_ =~ s/^\s+//;
										$_ =~ s/\s+$//;
										$_ =~ s/^\s+$//;
									}
									my $str = pop (@temp);
									push (@array1 , '<team_id>'.$str.'</team_id>');
									$second_team_id = $str;
								}
							}
						}
						
						$pattern1 = 'href="(.+?)"';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								$_ = $clear_str -> delete_4 ();
								$clear_str = undef;		
								$_ = entities_decode ($_);
								
								if ($_ !~ /^http/) {
									$_ = 'http://'.$host.$_
								}
								
								$_ =~ s/^\s+//;
								$_ =~ s/\s+$//;
								$_ =~ s/^\s+$//;
								
								my $str = $_;
								push (@array1 , '<team_url>'.$str.'</team_url>');
							}
						}
					}
				}
				
				if (scalar (@array1) > 0) {
					my $str = join ('', @array1);
					push (@array, $str);
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		#Gameweek
		@array = ();
		$pattern1 = '(<div class="details.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				my @temp = split ('<span class="divider"><\/span>', $_);
				if (scalar (@temp) > 0) {
					foreach (@temp) {
						
						if ($_ =~ /Game week/i) {
							
							my $pattern1 = '(<span.+?</span>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
					
									$_ =~ s/^\s+//;
									$_ =~ s/\s+$//;
									$_ =~ s/^\s+$//;
									
									if ($_ =~ /\d+/) {
										push (@array, $_);
									}
								}
							}
						}
					}
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put (pop (@array));
			$time = $array[0];	
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#competition_plus
		@array = ();
		$pattern1 = '(<div class="details.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				my @temp = split ('<span class="divider"><\/span>', $_);
				if (scalar (@temp) > 2) {
					
					shift (@temp);
					pop (@temp);
					
					foreach (@temp) {
						
						if ($_ =~ /<a/) {
						
							my $label = undef;
							my $value = undef;
							
							my $pattern1 = '(<a.+?</a>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
					
									$_ =~ s/^\s+//;
									$_ =~ s/\s+$//;
									$_ =~ s/^\s+$//;
									
									$label = $_;
								}
							}
							
							$pattern1 = 'r(\d+)\/';
							$work_for_content = work_for_content -> new ($_); 
							$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
					
									$_ =~ s/^\s+//;
									$_ =~ s/\s+$//;
									$_ =~ s/^\s+$//;
									
									$value = $_;
								}
							}
							
							if (defined ($label) and defined ($value)) {
								my $str = '<label>'.$label.'</label><value>'.$value.'</value>';
								push (@array, $str);
							}
							
							
						} else {
							
							my $label = '';
							my $value = '';
							
							my $pattern1 = '^(.+)$';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
					
									$_ =~ s/^\s+//;
									$_ =~ s/\s+$//;
									$_ =~ s/^\s+$//;
									
									$label = $_;
								}
							}
							
							if (defined ($label) and defined ($value)) {
								my $str = '<label>'.$label.'</label><value>'.$value.'</value>';
								push (@array, $str);
							}
						}
					}
				}
			}
		} 
		
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
			$time = $array[0];	
		} else {
			$write_to_txt1 -> put ('-');
		}		




		#details
		@array = ();
		$pattern1 = '(<div class="details.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				push (@array, $_);
			}
		} 
		
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($str);
			$time = $array[0];	
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		#Venue
		@array = ();
		$pattern1 = '(<a.+?</a>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				if ($_ =~ /href="venue/) {
					
					my $pattern1 = '^(.+)$';
					my $work_for_content = work_for_content -> new ($_); 
					my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_3_s ();
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;		
							
							my $pattern1 = '^(.+)\(';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									push (@array, $_);
								}
							}
						}
					}
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put (pop (@array));
			$time = $array[0];	
		} else {
			$write_to_txt1 -> put ('-');
		}		
		


		
		# # #картинка
		# # my %picture = ();
		# # tie %picture, 'Tie::IxHash';
		# # $pattern1 = '(<div class="product-card-gallery_.+?</div>)';
		# # $work_for_content = work_for_content -> new ($content1); 
		# # $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		# # if (defined $work_for_content_result -> [0]) {
			# # foreach (@$work_for_content_result) {		
				# # my $clear_str = clear_str -> new ($_);
				# # $_ = $clear_str -> delete_4 ();
				# # $clear_str = undef;								
				
				# # my $pattern1 = '<img.+?src.+?"(.+?)"';
				# # my $work_for_content = work_for_content -> new ($_); 
				# # my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				# # if (defined $work_for_content_result -> [0]) {
					# # foreach (@$work_for_content_result) {		
						# # my $clear_str = clear_str -> new ($_);
						# # $_ = $clear_str -> delete_4 ();
						# # $clear_str = undef;
						
						# # $_ = entities_decode ($_);
						# # $_ =~ s/\&size=.+$//;
						
						# # if ($_ !~ /^http/) {
							# # $_ = 'http:'.$_;
						# # }
						
						# # $picture {$_} = $_;
					# # }
				# # }
			# # }
		# # }
		
			
		# # if (keys (%picture) > 0) {
			# # my @file = ();
			
			# # foreach (keys  (%picture)) {
				
				# # my $uri = URI::URL-> new ($_, 'http://'.$host);
				# # my $url = $uri->abs;
				# # # print $url ."\n";
				
				# # my $method = 'GET';
				# # my $type = 'picture';
				# # my $referer = $host;
				# # my $str_for_content = 'href';
				
				# # my $md5 = MD5 -> new ();
				# # my $hash = $md5 -> hexhash ($url);
				# # $md5 = undef;
				
				# # my @hash = split ('', $hash);
				# # while (scalar (@hash) > 10) {
					# # pop (@hash);
				# # }
				# # my $file = join ('', @hash);
				# # $file = $file .'.jpg';
				
				# # # my $url_to_file = url_to_file -> new ($url);
				# # # my $file = $url_to_file -> do ();
				# # # $url_to_file = undef;
				
				# # $work_mysql_graber -> insert_ignore_shift_file (
					# # $method, 
					# # $url,
					# # $referer,
					# # $type, 
					# # $str_for_content,
					# # $file
				# # ); 							
				
				# # push (@file, $file);
			# # }
			
			# # # my $file_str = join ('||', values (%picture));
			# # my $file_str = join ('||', @file);
			# # $write_to_txt1 -> put ($file_str);
			
		# # } else {
			# # $write_to_txt1 -> put ('-');
		# # }
		
		
		my $str = $write_to_txt1 -> get ();
		$write_text_file_mode_rewrite1 -> put_str ($str ."\n");	
		$write_to_txt1 = undef;
				
	} else {
		# unlink ($file1) or die;
	}
	
	
} #читаем файлы из каталога
$write_text_file_mode_rewrite1 = undef;


# foreach (sort (values (%s))) {
	# if ($_ !~ /</) {
		# print $_ ."\n";
	# }
# }



sub utf8_to_win1251 {
	use Encode qw (encode decode); 
	my $str = shift;
	$str = encode ('cp1251', decode ('utf8', $str)); 
	# $str = encode ('cp1251', decode ('koi8-r', $str)); 
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

sub get_base_path {
	use Cwd; 
	my $cwd = getcwd ();
	return $cwd;
}

sub Random {
	my $from = shift;
	my $to = shift;
	my $random = $from + rand(($to - $from));
	return $random;
}

sub get_date_time {
	use Date::Calc qw (Time_to_Date Date_to_Time);
	
	my $date = shift;
	my $time = shift;
	
	# print '$date = ' . $date . "\n";
	# print '$time = ' . $time . "\n";
	
	if ($time !~ /\d{2}:\d{2}/) {
		$time = '16:00';
	}
	
	my $return = '-';
	if ($time =~ /\d{2}:\d{2}/ and $date =~ /\d{4}-\d{2}-\d{2}/) {
	
		my @time = split (':', $time);
		if (scalar (@time) > 0) {
			foreach (@time) {
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;								
				if (length ($_) == 2) {
					$_ =~ s/^0//;
				}
			}
		}
		
		my @date = split ('-', $date);
		if (scalar (@date) > 0) {
			foreach (@date) {
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;								
				if (length ($_) == 2) {
					$_ =~ s/^0//;
				}
			}
		}
		
		# my $time = Date_to_Time ($year,$month,$day, $hour,$min,$sec);
		
		my $ttime = Date_to_Time ($date[0],$date[1],$date[2], $time[0],$time[1], '0');
		$ttime = $ttime + 2*3600;
		
		# my ($year,$month,$day, $hour,$min,$sec) = Time_to_Date($ttime);
		my @date_new = Time_to_Date($ttime);
		if (scalar (@date_new) > 0) {
			foreach (@date_new) {
				if (length ($_) < 2) {
					$_ = '0'.$_;
				}
			}
		}
		
		$date = $date_new[0].'-'.$date_new[1].'-'.$date_new[2];
		$time = $date_new[3].':'.$date_new[4];
		
		$return = '<date>'.$date.'</date><time>'.$time.'</time>';
		# print $return ."\n";
	}

	
	return $return;
}


sub get_date_time2 {
	use Date::Calc qw (Time_to_Date Date_to_Time);
	
	my $str = shift;
	my $ttime = $str;
	$ttime = $ttime + 3*3600;
		
	# my ($year,$month,$day, $hour,$min,$sec) = Time_to_Date($ttime);
	my @date_new = Time_to_Date ($ttime);
	if (scalar (@date_new) > 0) {
		foreach (@date_new) {
			if (length ($_) < 2) {
				$_ = '0'.$_;
			}
		}
	}
	
	my $date = $date_new[0].'-'.$date_new[1].'-'.$date_new[2];
	my $time = $date_new[3].':'.$date_new[4];
	
	# my $return = '<date>'.$date.'</date><time>'.$time.'</time><timestamp>'.$ttime.'</timestamp>';
	my $return = '<date>'.$date.'</date><time>'.$time.'</time><timestamp>'.$str.'</timestamp>';
	
	return $return;
}

sub entities_encode {
	use HTML::Entities;
	my $str = shift;
	$str = encode_entities ($str, '<>"\'&');
	return $str;
}

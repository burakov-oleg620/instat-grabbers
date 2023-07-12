#!/usr/bin/env perl
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

my $workdir1 = get_base_path ().'/pictura'; 
my $workdir2 = get_base_path ().'/txt'; 
my $workdir3 = get_base_path ().'/xls'; 

my $write_text_file_mode_rewrite1 = undef;
my $file1 = $workdir2.'/write_text_file_mode_rewrite1.xls'; 
my $file2 = $workdir2.'/write_text_file_mode_rewrite2.xls'; 
my $write_file1 = $workdir2.'/write_text_file_mode_rewrite1.xls'; 
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
		# my $content2 = $tree -> findnodes_as_string ('//div[@class="product-spec-wrap__body"]'); 
		# $tree->delete;
		# $tree = undef;
		
		# my @content2 = split ("\n", $content2);
		# if (scalar (@content2) > 0) {
			# foreach (@content2) {
				# my $clear_str = clear_str -> new ($_);
				# $_ = $clear_str -> delete_4 ();
				# $clear_str = undef;		
			# }
			# $content2 = join (' ', @content2);
		# }
		
		
		
		my $write_to_txt1 = write_to_txt1 -> new ();				
		
		#урл из базы грабера
		my $url = '-';
		my $referer = '-';
		my $str_for_content = '-';
		my $file2 = $file1;
		$file2 =~ s/^.+\///;
		
		
		{
			#URL
			my $sql = 'select * from '.$mysql_table.' where `file` = "'.$file2.'"';
			$work_mysql	-> run_query ($sql); 
			my @row = $work_mysql -> get_row ();
			if (scalar (@row) > 0) {
				foreach (@row) {
					$url = $_ -> [2] ;
					$referer = $_ -> [3] ;
					$str_for_content = $_-> [7];
				}
			} 
		}
		
		$write_to_txt1 -> put ($url);

		my @array = ();
		my $pattern1 = '^(.+)$';
		my $work_for_content = work_for_content -> new ($url); 
		my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				
				my @temp = split (/\//, $_);
				if (scalar (@temp) > 3) {
					foreach (@temp) {
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
					}
					
					$_ =~ s/^\s+//;
					$_ =~ s/\s+$//;
					$_ =~ s/^\s+$//;
					
					if ($_ eq '') {$_ = '-';}
					pop (@temp);
					push (@array, pop (@temp));
				}
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		


		#name
		@array = ();
		$pattern1 = '(<h1.+?</h1>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				if ($_ eq '') {$_ = '-';}
				push (@array, $_);
			}
		}

		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		


		#address
		@array = ();
		$pattern1 = '(<dl class="details">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				my $pattern1 = '(<dt.+?</dd>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						if ($_ =~ /Address/ui) {
							
							my $pattern1 = '(<dd.+?</dd>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									if ($_ eq '') {$_ = '-';}
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
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#Zip_code
		@array = ();
		$pattern1 = '(<dl class="details">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				my $pattern1 = '(<dt.+?</dd>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						if ($_ =~ /Zip code/ui) {
							
							my $pattern1 = '(<dd.+?</dd>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									if ($_ eq '') {$_ = '-';}
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
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#City
		@array = ();
		$pattern1 = '(<dl class="details">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				my $pattern1 = '(<dt.+?</dd>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						if ($_ =~ /City:/ui) {
							
							my $pattern1 = '(<dd.+?</dd>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									if ($_ eq '') {$_ = '-';}
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
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		


		#Opened
		@array = ();
		$pattern1 = '(<dl class="details">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				my $pattern1 = '(<dt.+?</dd>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						if ($_ =~ /Opened:/ui) {
							
							my $pattern1 = '(<dd.+?</dd>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									if ($_ eq '') {$_ = '-';}
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
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#Architect
		@array = ();
		$pattern1 = '(<dl class="details">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				my $pattern1 = '(<dt.+?</dd>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						if ($_ =~ /Architect:/ui) {
							
							my $pattern1 = '(<dd.+?</dd>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									if ($_ eq '') {$_ = '-';}
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
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#Capacity
		@array = ();
		$pattern1 = '(<dl class="details">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				my $pattern1 = '(<dt.+?</dd>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						if ($_ =~ /Capacity:/ui) {
							
							my $pattern1 = '(<dd.+?</dd>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									if ($_ eq '') {$_ = '-';}
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
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		


		#Surface
		@array = ();
		$pattern1 = '(<dl class="details">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				my $pattern1 = '(<dt.+?</dd>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						if ($_ =~ /Surface:/ui) {
							
							my $pattern1 = '(<dd.+?</dd>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									if ($_ eq '') {$_ = '-';}
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
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		


		#previous_names
		@array = ();
		$pattern1 = '(<dl class="details">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				my $pattern1 = '(<dt.+?</dd>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						if ($_ =~ /Previous Names:/ui) {
							
							my $pattern1 = '(<dd.+?</dd>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									if ($_ eq '') {$_ = '-';}
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
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#Facts
		@array = ();
		$pattern1 = '(<dl class="details">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				my $pattern1 = '(<dt.+?</dd>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						if ($_ =~ /Facts:/ui) {
							
							my $pattern1 = '(<dd.+?</dd>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									if ($_ eq '') {$_ = '-';}
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
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		


		#lat
		#X-coordinate
		@array = ();
		$pattern1 = '(<iframe.+?</iframe>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				# $_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	
				
				$pattern1 = 'src="(.+?)"';
				$work_for_content = work_for_content -> new ($_); 
				$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						# $_ = $clear_str -> delete_3_s ();
						$_ = $clear_str -> delete_4 ();
						
						$pattern1 = 'center=(.+?)&';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								# $_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
						
								$_ =~ s/^\s+//;
								$_ =~ s/\s+$//;
								$_ =~ s/^\s+$//;
								
								my @temp = split (/,/, $_);
								if (scalar (@temp) > 1) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
									}
									
									$_ =~ s/^\s+//;
									$_ =~ s/\s+$//;
									$_ =~ s/^\s+$//;
									
									if ($_ eq '') {$_ = '-';}
									push (@array, $temp[0]);
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
		
		
		#lon
		#xcoordinate
		@array = ();
		$pattern1 = '(<iframe.+?</iframe>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				# $_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	
				
				$pattern1 = 'src="(.+?)"';
				$work_for_content = work_for_content -> new ($_); 
				$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						# $_ = $clear_str -> delete_3_s ();
						$_ = $clear_str -> delete_4 ();
						
						$pattern1 = 'center=(.+?)&';
						$work_for_content = work_for_content -> new ($_); 
						$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
						if (defined $work_for_content_result -> [0]) {
							foreach (@$work_for_content_result) {		
								my $clear_str = clear_str -> new ($_);
								# $_ = $clear_str -> delete_3_s ();
								$_ = $clear_str -> delete_4 ();
						
								$_ =~ s/^\s+//;
								$_ =~ s/\s+$//;
								$_ =~ s/^\s+$//;
								
								my @temp = split (/,/, $_);
								if (scalar (@temp) > 1) {
									foreach (@temp) {
										my $clear_str = clear_str -> new ($_);
										$_ = $clear_str -> delete_4 ();
										$clear_str = undef;		
									}
									
									$_ =~ s/^\s+//;
									$_ =~ s/\s+$//;
									$_ =~ s/^\s+$//;
									
									if ($_ eq '') {$_ = '-';}
									push (@array, $temp[1]);
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

		#phone
		@array = ();
		$pattern1 = '(<dl class="details">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				my $pattern1 = '(<dt.+?</dd>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						if ($_ =~ /Phone:/ui) {
							
							my $pattern1 = '(<dd.+?</dd>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									if ($_ eq '') {$_ = '-';}
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
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		#fax
		@array = ();
		$pattern1 = '(<dl class="details">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				$_ = entities_decode ($_);	

				my $pattern1 = '(<dt.+?</dd>)';
				my $work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach (@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						if ($_ =~ /Fax:/ui) {
							
							my $pattern1 = '(<dd.+?</dd>)';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_3_s ();
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;		
									
									if ($_ eq '') {$_ = '-';}
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
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		#img
		$write_to_txt1 -> put ('-');
		
		
		#date
		$write_to_txt1 -> put (get_date_time2 (time()));
		
		
		
		
		
		my $str = $write_to_txt1 -> get ();
		$write_text_file_mode_rewrite1 -> put_str ($str ."\n");	
		$write_to_txt1 = undef;
				
	} else {
		# unlink ($file1) or die;
	}
	
	
} #читаем файлы из каталога
$write_text_file_mode_rewrite1 = undef;


foreach (sort (values (%s))) {
	if ($_ !~ /</) {
		print $_ ."\n";
	}
}



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
	# my $return = '<date>'.$date.'</date><time>'.$time.'</time><timestamp>'.$str.'</timestamp>';
	my $return = $date.' '.$time;
	
	return $return;
}

#!/usr/bin/env perl
#тренеры
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
#use utf8;

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

#—оздаем дескриптор на mysql соединение
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

my $workdir1 = get_base_path ().'/medic'; 
my $workdir2 = get_base_path ().'/txt'; 
my $workdir3 = get_base_path ().'/xls'; 

my $write_text_file_mode_rewrite1 = undef;
my $file1 = $workdir2.'/write_text_file_mode_rewrite1.xls'; 
my $file2 = $workdir2.'/write_text_file_mode_rewrite2.xls'; 
my $write_file1 = $workdir2.'/write_text_file_mode_rewrite4.xls'; 
$write_text_file_mode_rewrite1 = write_text_file_mode_rewrite -> new ($write_file1);

my $count = 0 ;
my %file1 = ();
# my $header = undef;
# my @read_text_file1 = ();

my %s = ();
my $dir_scan_recurce = dir_scan_recurce -> new ($workdir1);
while (my $file1 = $dir_scan_recurce -> get_file ()) {
	#print ++$count."\n";
	
	my $pattern = 'http_';
	if ($file1 =~ /$pattern/) {	
		
		my @file1 = ();	
		my $read_text_file = read_text_file -> new ($file1); 
		while (my $str1 = $read_text_file -> get_str ()) {
			push (@file1, $str1); 
		}
		$read_text_file = undef;
		
		
		my $content1 = join (' ', @file1); 
		# $content1 = entities_decode1 ($content1);
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
		
		
		my $write_to_txt1 = write_to_txt1 -> new ();				
		
		#урл из базы грабера
		#урл из базы грабера
		my $url = '-';
		my $str_for_content = '-';
		my $referer = '-';
		
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
					$str_for_content = $_ -> [7] ;
				}
			} 
		}		
		
		$write_to_txt1 -> put ($url);
		# $write_to_txt1 -> put ($referer);
							
		
		#Id
		my $id = undef;
		my @array = ();
		my $pattern1 = '/(\d+)/$';
		my $work_for_content = work_for_content -> new ($url); 
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
				push (@array , $_);
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
			$id = $array [0];
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		#id_team
		@array = ();
		$pattern1 = '/(\d+)/$';
		$work_for_content = work_for_content -> new ($referer); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach (@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
				
				$_ = entities_decode ($_);	
				
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				push (@array , $_);
			}
		}
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
			$id = $array [0];
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		#name
		@array = ();
		$pattern1 = '<dt>First name</dt>(.+?</dd>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach 	(@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				push (@array , $_);
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		#surname
		@array = ();
		$pattern1 = '<dt>Last name</dt>(.+?</dd>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach 	(@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				push (@array , $_);
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		#birthday
		@array = ();
		$pattern1 = '<dt>Date of birth</dt>(.+?</dd>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach 	(@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				$_ = str_to_date ($_);
				
				push (@array , $_);
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#Age
		@array = ();
		$pattern1 = '<dt>Age</dt>(.+?</dd>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach 	(@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				push (@array , $_);
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		#Country
		@array = ();
		$pattern1 = '<dt>Country of birth</dt>(.+?</dd>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach 	(@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				push (@array , $_);
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#Place of birth
		@array = ();
		$pattern1 = '<dt>Place of birth</dt>(.+?</dd>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach 	(@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				push (@array , $_);
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		

		#nationality
		@array = ();
		$pattern1 = '<dt>Nationality</dt>(.+?</dd>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach 	(@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				push (@array , $_);
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		#Height
		@array = ();
		$pattern1 = '<dt>Height</dt>(.+?</dd>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach 	(@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				push (@array , $_);
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		#Weight
		@array = ();
		$pattern1 = '<dt>Weight</dt>(.+?</dd>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach 	(@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				push (@array , $_);
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put ('-');
		}		
		
		
		
		#img
		@array = ();
		$pattern1 = '(<div class="yui-u">.+?</div>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach 	(@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				
				my $pattern1 = '<img.+?src.+?"(.+?)"';
				my$work_for_content = work_for_content -> new ($_); 
				my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				if (defined $work_for_content_result -> [0]) {
					foreach 	(@$work_for_content_result) {		
						my $clear_str = clear_str -> new ($_);
						$_ = $clear_str -> delete_4 ();
						$clear_str = undef;		
						
						$_ =~ s/^\s+//;
						$_ =~ s/\s+$//;
						$_ =~ s/^\s+$//;
						
						if ($_ !~ /http/) {
							$_ = 'http://'.$host.$_;
						}
				
						push (@array , $_);
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
		
		#dead
		@array = ();
		$pattern1 = '<dt>Age</dt>(.+?</dd>)';
		$work_for_content = work_for_content -> new ($content1); 
		$work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		if (defined $work_for_content_result -> [0]) {
			foreach 	(@$work_for_content_result) {		
				my $clear_str = clear_str -> new ($_);
				$_ = $clear_str -> delete_3_s ();
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;		
		
				$_ = entities_decode ($_);	
				$_ =~ s/^\s+//;
				$_ =~ s/\s+$//;
				$_ =~ s/^\s+$//;
				
				if ($_ =~ /Deceased/i) {
					push (@array , 1);
				}
			}
		} 
		
		if (scalar (@array) > 0) {
			my $str = join ('||', @array);
			$write_to_txt1 -> put ($array[0]);
		} else {
			$write_to_txt1 -> put (0);
		}				
		
		
		
		
		# #картинка
		# my %picture = ();
		# tie %picture, 'Tie::IxHash';
		# $pattern1 = '(<div class="product-card-gallery_.+?</div>)';
		# $work_for_content = work_for_content -> new ($content1); 
		# $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
		# if (defined $work_for_content_result -> [0]) {
			# foreach (@$work_for_content_result) {		
				# my $clear_str = clear_st	r -> new ($_);
				# $_ = $clear_str -> delete_4 ();
				# $clear_str = undef;								
				
				# my $pattern1 = '<img.+?src.+?"(.+?)"';
				# my $work_for_content = work_for_content -> new ($_); 
				# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
				# if (defined $work_for_content_result -> [0]) {
					# foreach (@$work_for_content_result) {		
						# my $clear_str = clear_str -> new ($_);
						# $_ = $clear_str -> delete_4 ();
						# $clear_str = undef;
						
						# $_ = entities_decode ($_);
						# $_ =~ s/\&size=.+$//;
						
						# if ($_ !~ /^http/) {
							# $_ = 'http:'.$_;
						# }
						
						# $picture {$_} = $_;
					# }
				# }
			# }
		# }
		
			
		# if (keys (%picture) > 0) {
			# my @file = ();
			
			# foreach (keys  (%picture)) {
				
				# my $uri = URI::URL-> new ($_, 'http://'.$host);
				# my $url = $uri->abs;
				# # print $url ."\n";
				
				# my $method = 'GET';
				# my $type = 'picture';
				# my $referer = $host;
				# my $str_for_content = 'href';
				
				# my $md5 = MD5 -> new ();
				# my $hash = $md5 -> hexhash ($url);
				# $md5 = undef;
				
				# my @hash = split ('', $hash);
				# while (scalar (@hash) > 10) {
					# pop (@hash);
				# }
				# my $file = join ('', @hash);
				# $file = $file .'.jpg';
				
				# # my $url_to_file = url_to_file -> new ($url);
				# # my $file = $url_to_file -> do ();
				# # $url_to_file = undef;
				
				# $work_mysql_graber -> insert_ignore_shift_file (
					# $method, 
					# $url,
					# $referer,
					# $type, 
					# $str_for_content,
					# $file
				# ); 							
				
				# push (@file, $file);
			# }
			
			# # my $file_str = join ('||', values (%picture));
			# my $file_str = join ('||', @file);
			# $write_to_txt1 -> put ($file_str);
			
		# } else {
			# $write_to_txt1 -> put ('-');
		# }
		
		
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

sub entities_decode1 {
	use HTML::Entities;
	my $str = shift;
	#перед отдачей модулю нужно сделать decode с любой кодировки
	$str = decode ('utf8', $str);
	$str = decode_entities ($str);
	$str = encode ('utf8', $str);
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


sub str_to_date {
	my $str = shift;
	my %month = (
		'January' => '01',
		'February' => '02',
		'March' => '03',
		'April' => '04',
		'May' => '05',
		'June' => '06',
		'July' => '07',
		'August' => '08',
		'September' => '09',
		'October' => '10',
		'November' => '11',
		'December' => '12',
	);
	
	
	my @str = split (/\s+/, $str);
	if (scalar (@str)) {
		foreach (@str) {
			my $clear_str = clear_str -> new ($_);
			$_ = $clear_str -> delete_4 ();
			$clear_str = undef;		
			if (exists ($month {$_})) {
				$_ = $month {$_};
			}
			
			while (length ($_) < 2) {
				$_ = '0'.$_;
			}
		}
		@str = reverse (@str);
		$str = join ('-', @str);
	}
	return $str;
}
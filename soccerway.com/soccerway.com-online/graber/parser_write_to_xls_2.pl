#!/usr/bin/env perl
#конвертор в XLS
use strict;
use warnings;
use locale;
use dir_scan_recurce;
use read_text_file; 
use write_text_file_mode_rewrite; 
use clear_str;
use delete_duplicate_from_array; 
use read_inifile;
use work_mysql;

use Encode qw (encode decode);
use Spreadsheet::WriteExcel;


my $read_inifile = read_inifile -> new ('graber.ini'); 
my $host = $read_inifile -> get ('host');

#Читаю установки из ини файла
my $workdir1 = get_base_path ().'/out'; 

my $file1 = $workdir1.'/write_text_file_mode_rewrite3.xls'; 
my $file2 = $workdir1.'/write_text_file_mode_rewrite4.xls'; 


my $count = 0; 

my $dir_scan_recurce = dir_scan_recurce -> new ($workdir1);
while (my $file1 = $dir_scan_recurce -> get_file ()) {
	print ++$count."\n";
	
	#создание XLS файла  
	my $file2 = $file1;
	$file2 =~ s/^.+\///;
	$file2 = '0'.$file2;
	$file2 = $workdir1 .'/'.$file2;
	
	my $workbook = Spreadsheet::WriteExcel->new($file2);
	my $worksheet = $workbook->add_worksheet();
	
	my $row = 0;
	my $read_text_file1 = read_text_file -> new ($file1); 
	while (my $str1 = $read_text_file1 -> get_str ()) {
		print ++$count."\n";
		
		my $col = 0; 
		if ($str1 =~ /\t/) {
			my $temp1 = []; my $pattern1 = "\t"; @$temp1 = split ($pattern1, $str1); 
			
			foreach (@$temp1) {
				my $clear_str = clear_str -> new ($_); 
				$_ = $clear_str -> delete_4 ();
				$clear_str = undef;
				
				$_ = decode ('cp1251', $_);
				$worksheet->write($row, $col, $_);
				$col++;				
			}
			$row++;
		}
	}
	$read_text_file1 = undef;
	$workbook = undef;
	unlink ($file1) or die ();
}


sub get_base_path {
	use Cwd; 
	my $cwd = getcwd ();
	return $cwd;
}



  



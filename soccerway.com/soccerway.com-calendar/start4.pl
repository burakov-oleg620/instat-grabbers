#!/usr/bin/env perl
use strict; 
use warnings;
use Cwd;
use lib getcwd().'/graber';
use clear_str;
use Date::Calc qw (Date_to_Time Time_to_Date);


my $workdir0 = getcwd (); 
my $workdir1 = getcwd (). '/graber'; 
my $workdir2 = getcwd (). '/city'; 


#счетчик дней назад
#6000

my $count =  3;
my $time = time ();

my $lockfile_graber = 'lock_graber.txt'; 
if (!-f $lockfile_graber) {
	open (FILE, '>'.$lockfile_graber) or die;
	print FILE 'запуск грабера произведен';
	close (FILE); 


	my @url = ();
	# do {
		# # http://int.soccerway.com/matches/2016/08/16/
		
		# my ($year,$month,$day, $hour,$min,$sec) = Time_to_Date ($time);
		# my @date = Time_to_Date($time);
		# foreach (@date) {
			# while (length ($_) < 2) {
				# $_ = '0'.$_;
			# }
		# }
		
		# my $url = 'http://int.soccerway.com/matches/'.$date[0].'/'.$date[1].'/'.$date[2].'/';
		# push (@url, $url);
		
		# $time = $time - 24*3600;
		# $count --;

	# } while ($count > 0);
	
	push (@url, 1);

	if (scalar (@url) > 0) {
		
		# my $file = getcwd () .'/city/001.xls';
		# open (FILE, '>'.$file) or die (print $!);
		# foreach (@url) {
			# print FILE $_ ."\t". 1 ."\n";
		# }
		# close (FILE);

		my @file1 = ();
		opendir (DIR, $workdir2) or die (print $!);
		while (my $file1 = readdir (DIR)) {
			# print ++$count ."\n";
			
			if ($file1 =~ /xls$/) {
				$file1 = $workdir2 .'/'.$file1;
				
				open (FILE, $file1) or die (print $!);
				while (<FILE>) {
					my $array = [];
					@$array = split ("\t", $_);
					foreach (@$array) {
						$_ =~ s/\n+//g;
						$_ =~ s/\r+//g;
					}
					if (scalar (@$array) > 1 and $array -> [0] =~ /^http/) {
						push (@file1, $array);
					}
				}
				close (FILE);
			}
		}
		closedir (DIR); 

		$count = 0;
		if (scalar (@file1) > 0) {
				
			foreach (@file1) {
				my $time = time ();
				
				my $log_file_stdout = getcwd ().'/log/'. get_date ($time) .'_stdout.xls';
				my $log_file_stderr = getcwd ().'/log/'. get_date ($time) .'_stderr.xls';
				
				chdir ($workdir1); 
				my $file_url = $workdir1  .'/xls/001.xls';
					
				open (FILE, '>'.$file_url) or die (print $!);
				print FILE $_-> [0] ."\t". $_ ->[1] ."\n";
				close (FILE);
				
				my $file2 = 'start3.cmd'; 
				if (-f $workdir1 .'/'. $file2 and -d 'c:/windows') {
					system $file2;
					#system $file2 . ' 1>'. $log_file_stdout .' 2>'.$log_file_stderr;
				}
				
				$file2 = './start3.pl' ; 
				if (-f $workdir1 .'/'. $file2 and !-d 'c:/windows') {
					system $file2;
					#system $file2 . ' 1>'. $log_file_stdout .' 2>'.$log_file_stderr;
				}
				
				chdir ($workdir0);
			}
		}
	}
	
	unlink ($lockfile_graber) or die (print $!);
	
}




sub get_date { 
	use  Date::Calc qw (Time_to_Date Date_to_Time);
	# my ($year,$month,$day, $hour,$min,$sec) = Time_to_Date(time());
	
	my $time = shift;
	my @date = Time_to_Date($time);
	foreach (@date) {
		while (length ($_) < 2) {
			$_ = '0'.$_;
		}
	}
	
	my $str = $date[0] .'-'.$date[1].'-'.$date[2] .'_'.$date[3].'-'.$date[4].'-'.$date[5];
	return $str;
}

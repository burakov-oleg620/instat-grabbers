#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;
use lib getcwd ();
use File::Path;
use clear_dir; 
use dir_scan_recurce;

my @workdir = ();
push (@workdir, get_base_path (). '/html'); 
push (@workdir, get_base_path (). '/media'); 
push (@workdir, get_base_path (). '/medim'); 
push (@workdir, get_base_path (). '/mediu'); 
push (@workdir, get_base_path (). '/medic'); 
push (@workdir, get_base_path (). '/medir'); 
push (@workdir, get_base_path (). '/picture'); 
push (@workdir, get_base_path (). '/pictura'); 
push (@workdir, get_base_path (). '/txt'); 
push (@workdir, get_base_path (). '/out'); 
push (@workdir, get_base_path (). '/outa'); 
push (@workdir, get_base_path (). '/pdf'); 

my $count = 0;
foreach (@workdir) {
	opendir (DIR, $_) or die;
	while (my $file = readdir (DIR)) {
		if ($file ne '.' and $file ne '..') {
			print ++$count ."\n";
			
			if (-f $_ .'/'. $file) {
				unlink ($_ .'/'. $file) or die;
			} else {
				if (-d $_ .'/'. $file) {
					rmtree ($_ .'/'. $file) or die;
				}
			}
		}
	}
}

sub get_base_path {
	use Cwd; 
	my $cwd = getcwd ();
	return $cwd;
}

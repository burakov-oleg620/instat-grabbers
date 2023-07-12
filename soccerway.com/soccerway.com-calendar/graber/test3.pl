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
use WWW::Mechanize;
use WWW::Mechanize::PhantomJS;


my $mech = WWW::Mechanize::PhantomJS->new();
my $url = 'http://mnogo-dok.ru/sitemap.xml';
$mech->get($url); 

print $mech->status() ."\t". $url ."\n";

if ($mech->success()) {
	# my $png_data = $mech->content_as_png();
	# put_content_to_file ($png_data, '1.png');
	
	
	# my $xpath = $mech -> xpath ('.//*[@id=\'content\']', single => 1);
	# my $png_data = $mech->element_as_png($xpath);
	put_content_to_file ($mech->content, '1.xml');
	
}





sub put_content_to_file {
	my $content = shift;
	my $file = shift;
	open (my $fh, '>'. $file) or die ($!);
	binmode ($fh);
	my $written = syswrite $fh, $content, length ($content);
	close ($fh) or die $!;		
}	

package date_time;
use strict;
use warnings;


sub date {
(my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday, my $isdst) = localtime ();
$year = $year + 1900;
$mon = $mon+1;
if ($mday < 10) {$mday = "0$mday";}
if ($mon  < 10) {$mon = "0$mon";}
my $date = "$mday.$mon.$year";
return $date;
}


sub time {
(my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday, my $isdst) = localtime ();
if ($hour < 10) {$hour = "0$hour";}
if ($min  < 10) {$min = "0$min";}
if ($sec  < 10) {$sec = "0$sec";}
my $time = "$hour.$min.$sec";
return $time;
}

1;
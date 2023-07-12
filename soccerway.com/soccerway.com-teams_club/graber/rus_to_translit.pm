package rus_to_translit;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $str = shift;
	my $self = {}; 
	$self->{str} = $str; 
	return bless $self;
}

sub do {
	my $self = shift;
	my $str = $self -> {str};
	$str = _k82tr ($str);
	return $str;
}



sub _k82tr  
    { ($_)=@_;  
  
#  
# Fonetic correct translit  
#  
  
s/��/S\'h/; s/��/s\'h/; s/��/S\'H/;  
s/�/Sh/g; s/�/sh/g;  
  
s/���/Sc\'h/; s/���/sc\'h/; s/���/SC\'H/;  
s/�/Sch/g; s/�/sch/g;  
  
s/��/C\'h/; s/��/c\'h/; s/��/C\'H/;  
s/�/Ch/g; s/�/ch/g;  
  
s/��/J\'a/; s/��/j\'a/; s/��/J\'A/;  
s/�/Ja/g; s/�/ja/g;  
  
s/��/J\'o/; s/��/j\'o/; s/��/J\'O/;  
s/�/Jo/g; s/�/jo/g;  
  
s/��/J\'u/; s/��/j\'u/; s/��/J\'U/;  
s/�/Ju/g; s/�/ju/g;  
  
s/�/E\'/g; s/�/e\'/g;  
s/�/E/g; s/�/e/g;  
  
s/��/Z\'h/g; s/��/z\'h/g; s/��/Z\'H/g;  
s/�/Zh/g; s/�/zh/g;  
  
tr/  
������������������������������������������������/  
abvgdzijklmnoprstufhc\"y\'ABVGDZIJKLMNOPRSTUFHC\"Y\'/;  
  
return $_;  
  
}  



1; 




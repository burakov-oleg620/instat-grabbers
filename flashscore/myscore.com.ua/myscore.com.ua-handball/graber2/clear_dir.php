<?php
set_time_limit(0);

include 'get_base_path_inc.php';
include 'clear_str_inc.php';
include 'work_for_content_inc.php';
include 'work_for_txt1_inc.php';
include 'write_text_file_rewrite_inc.php';
include 'simple_html_dom.php';
include 'work_ini_file_inc.php';
include 'work_mysql_graber_inc.php';
include 'get_file_from_url_inc.php';
include 'clear_dir_inc.php';
//include 'idna_convert.class.php';

// $work_ini_file = new work_ini_file ('graber.ini');
// $host_mysql = $work_ini_file -> get ('host_mysql');
// $user = $work_ini_file -> get ('user');
// $password = $work_ini_file -> get ('password');
// $table = $work_ini_file -> get ('table');
// $database = $work_ini_file -> get ('database');
// $host = $work_ini_file -> get ('host');
// $count_limit = $work_ini_file -> get ('count_limit');
// $count_start_from_ini = $work_ini_file -> get ('count_start_from_ini');

// $workdir = getcwd ();
// $pattern = '/\\\/';
// $replacement = '/';
// $workdir = preg_replace ($pattern, $replacement, $workdir);

// $clear_dir = new clear_dir ($workdir);
// $clear_dir -> clear_html ();
// $clear_dir -> clear_picture ();
// $clear_dir -> clear_media ();
// $clear_dir -> clear_txt ();
// $clear_dir -> clear_pdf ();

// $work_mysql_graber = new work_mysql_graber ($host_mysql, $user, $password, $table, $database);
// $work_mysql_graber -> drop_table (); //очистка таблиц
// $work_mysql_graber -> create_table ();

$array = array ();
array_push ($array, getcwd () .'/html');
array_push ($array, getcwd () .'/html2');
array_push ($array, getcwd () .'/html3');
array_push ($array, getcwd () .'/html4');
array_push ($array, getcwd () .'/media');
array_push ($array, getcwd () .'/txt');
array_push ($array, getcwd () .'/out');
array_push ($array, getcwd () .'/outa');
array_push ($array, getcwd () .'/picturc');
array_push ($array, getcwd () .'/picturr');
array_push ($array, getcwd () .'/picture');
array_push ($array, getcwd () .'/pdf');

$count = 0;
foreach ($array as $workdir) {
	print $count++ ."\n";
	
	$dh = opendir ($workdir) or die;
	while ($file = readdir ($dh)) {
		if ($file != '.' and $file != '..') {
			$file = $workdir .'/'.$file;
			if (is_file ($file)) {
				print $count++ ."\n";
				unlink ($file) or die ();
			}
		}
	}
	closedir ($dh);
}


?>
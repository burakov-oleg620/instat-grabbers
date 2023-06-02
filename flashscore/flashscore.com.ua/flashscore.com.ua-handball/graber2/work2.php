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

$work_ini_file = new work_ini_file ('graber.ini');
$host_mysql = $work_ini_file -> get ('host_mysql');
$user = $work_ini_file -> get ('user');
$password = $work_ini_file -> get ('password');
$table = $work_ini_file -> get ('table');
$database = $work_ini_file -> get ('database');
$host = $work_ini_file -> get ('host');
$count_limit = $work_ini_file -> get ('count_limit');
$count_start_from_ini = $work_ini_file -> get ('count_start_from_ini');

$workdir = getcwd ();
$pattern = '/\\\/';
$replacement = '/';
$workdir = preg_replace ($pattern, $replacement, $workdir);

$clear_dir = new clear_dir ($workdir);
$clear_dir -> clear_html ();
$clear_dir -> clear_picture ();
$clear_dir -> clear_media ();
$clear_dir -> clear_txt ();


$work_mysql_graber = new work_mysql_graber ($host_mysql, $user, $password, $table, $database);
$work_mysql_graber -> drop_table (); //очистка таблиц
$work_mysql_graber -> create_table ();

$workdir = getcwd () .'/xls';

$count = 0;
$dh = opendir ($workdir) or die;
while ($file = readdir ($dh)) {
	if ($file != '.' and $file != '..') {
		$file = $workdir.'/'.$file;
		$pattern = '/xls$/';
		preg_match ($pattern, $file, $array);
		if (count ($array) > 0) {
			$file_array = array ();
			$fh = fopen ($file, 'r') or die;
			while ($str = fgets ($fh)) {
				$clear_str = new clear_str ($str);
				$str = $clear_str -> delete_2 ();
				unset ($clear_str); 
				
				if (preg_match ('/\t/', $str)) {
					print ++$count ."\n";
					
					$temp1 = array ();
					$temp1 = preg_split ('/\t/', $str);				
					
					if (count ($temp1) == 5) {
						foreach ($temp1 as $key => $value) {
							$clear_str = new clear_str ($temp1 [$key]);
							$temp1 [$key] = $clear_str -> delete_2 ();
							unset ($clear_str); 
						}
						
						//print_r ($temp1) ;
						
						
						$temp1[0] = iconv ("windows-1251", "utf-8", $temp1[0]); 
						$select = urlencode ($temp1[0]);
						$url = $temp1[0];
						//print $url ."\n";
						
						$referer = $url;
						$content = '';
						
						$get_file_from_url = new get_file_from_url ($url);
						$file = $get_file_from_url -> get();
						$state = 'new';
						// $type = 'html'; 
						$type = 'media'; 
						$work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content, $state, $file, $type);						
						
					}
				}
			}
			
			fclose ($fh);
		}
	}
}
closedir ($dh);



function get_param ($str, $pattern) {
	preg_match_all ($pattern, $str, $array);
	return $array;
}

function strip_tags1 ($str) {
	$str = replace ('<.+?>', ' ', $str);
	return $str;
}

function replace ($pattern1, $pattern2, $content) { 
	$pattern1 = '/'.$pattern1.'/';
	$content = preg_replace ($pattern1, $pattern2, $content);
	return $content;
}	


?>
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

$work_ini_file = new work_ini_file ('graber.ini');
$host_mysql = $work_ini_file -> get ('host_mysql');
$user = $work_ini_file -> get ('user');
$password = $work_ini_file -> get ('password');
$table = $work_ini_file -> get ('table');
$database = $work_ini_file -> get ('database');
$host = $work_ini_file -> get ('host');
$count_limit = $work_ini_file -> get ('count_limit');
$count_start_from_ini = $work_ini_file -> get ('count_start_from_ini');

$work_mysql_graber = new work_mysql_graber ($host_mysql, $user, $password, $table, $database);

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
					
					
					// print '*count = ' . count ($temp) ."\n";
					
					if (count ($temp1) > 1) {
						foreach ($temp1 as $key => $value) {
							$clear_str = new clear_str ($temp1 [$key]);
							$temp1 [$key] = $clear_str -> delete_2 ();
							unset ($clear_str); 
						}
						
						//print_r ($temp1) ;
						
						// $temp1[3] = iconv ("windows-1251", "utf-8", $temp1[3]); 
						// $select = urlencode ($temp1[0]);
						
						// $idn = new idna_convert(array('idn_version'=>2008));
						// $temp1[3] = $idn -> encode ($temp1[3]);
						
						// $p = array (); 
						// $p = preg_split ('/\//', $temp1[0]);
						// $p[2] = $idn -> encode ($p[2]);
						// $temp1[0] = join ('/', $p);

						
						$url = $temp1[0];
						$referer = $url;
						$content = '';
						$select = $temp1[1];
						
						// $get_file_from_url = new get_file_from_url ($url);
						// $file = $get_file_from_url -> get();
						// $file = $file .'['.$temp1[1].']'.'['.$temp1[2].']';
						
						$file = 'http_'.MD5 ($url) .'.html';
						$state = 'new';
						
						//единичные матчи
						//$type = 'pdf'; 
						
						//основной запуск (начало)
						$type = 'html'; 
						
						//$type = 'html2'; 
						
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
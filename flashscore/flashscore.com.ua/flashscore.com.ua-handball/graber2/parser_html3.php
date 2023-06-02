<?php
ini_set('date.timezone', 'Europe/Moscow');
// setlocale(LC_ALL, 'ru_RU.CP1251', 'rus_RUS.CP1251', 'Russian_Russia.1251');
//setlocale(LC_ALL, 'ru_RU.utf8', 'rus_RUS.ut8', 'Russian_Russia.utf8');
// setlocale(LC_ALL,"russian");
setlocale(LC_ALL, 'ru_RU.UTF-8');

error_reporting(E_ALL | E_STRICT) ;
ini_set('display_errors', 'On');		
set_time_limit(0); //устанавливаем время на безлимит
flush ();


include 'get_base_path_inc.php';
include 'clear_str_inc.php';
include 'work_for_content_inc.php';
include 'work_for_txt1_inc.php';
include 'write_text_file_rewrite_inc.php';
include 'simple_html_dom.php';
include 'work_ini_file_inc.php';
include 'work_mysql_graber_inc.php';
include 'get_file_from_url_inc.php';


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


$get_base_path = new get_base_path;
$workdir = $get_base_path -> get ();
$workdir2 = $workdir .'/txt';
$file2 = $workdir2.'/write_text_file_rewrite3.xls';

$write_text_file_rewrite = new write_text_file_rewrite ($file2);
$workdir = $workdir .'/picturc';


$count = 0;


// $file_cat = getcwd () .'/xls/cat.xls';
// $cat_array = array ();
// $fh = fopen ($file_cat, 'r') or die;
// while ($str = fgets ($fh)) {
	// $clear_str = new clear_str ($str);
	// $str = $clear_str -> delete_2 ();
	// unset ($clear_str); 
	
	// //print $str ."\n";

	// if (preg_match ('/\t/', $str)) {
		// print ++$count ."\n";
		
		// $temp1 = array ();
		// $temp1 = preg_split ('/\t/', $str);
		
		// // print '*'. count ($temp1) ."\n";
		// if (count ($temp1) == 5) {
			// foreach ($temp1 as $key => $value) {
				// $clear_str = new clear_str ($temp1[$key]);
				// $temp1[$key] = $clear_str -> delete_2 ();
				// unset ($clear_str); 
			// }
			
			// $cat_array [$temp1[0]] = $temp1; 
			// //print_r ($temp1)."\n";
		// }
		
		// //$file_array [$temp1[1]] = $temp1;
		// //array_push ($file_array, $str);
	// }
// }
// fclose ($fh);


$dh = opendir ($workdir) or die;
while ($file = readdir ($dh)) {
	if ($file != '.' and $file != '..') {
		$file = $workdir.'/'.$file;
		$pattern = '/http_/';
		// preg_match ($pattern, $file, $array);
		// if (count ($array) > 0) {
		
		if (preg_match ($pattern, $file)) {
			print ++$count ."\n";
			
			$file_array = array ();
			$fh = fopen ($file, 'r') or die;
			while ($str = fgets ($fh)) {
				// $clear_str = new clear_str ($str);
				// $str = $clear_str -> delete_2 ();
				// unset ($clear_str); 
				
				
				// $str = preg_replace ('/\n+/u', ' ', $str);
				// $str = preg_replace ('/\r+/u', ' ', $str);
				
				$str = str_replace(array("\r","\n"), '', $str);
				array_push ($file_array, $str);
				// print $str ."\n";
				
			}
			fclose ($fh);
			
			$content = join (' ', $file_array);
			$content1 = join (' ', $file_array);
			$content1 = replace ('\s+', ' ', $content1);
			// print $content ."\n";
			
			//$content = iconv ("utf-8", "windows-1251", $content); 
			//$content = iconv ("utf-8", "windows-1251//IGNORE", $content); 
			//$content = iconv ("utf-8", "windows-1251//TRANSLIT//IGNORE", $content); 
			
			// print $content ."\n";
			
			
			
			// print $content ."\n";
			
			// $arTable = array ();
			// $html = new simple_html_dom (); 
			// $html->load ($content);
			// $element = $html->find('table[class="id_more"]');
			// //$element2 = $html->find('div[class="navig"]');
			// if(count($element) > 0) {
				// foreach($element as $table) {
					// //echo '1 = '.  $table->innertext ."\n";
					// array_push ($arTable, $table->innertext);
				// }
			// }
			// if (count ($arTable) > 0) {
				// foreach ($arTable as $arTableValue) {
					// // print $arTableValue ."\n";
					// // print $file ."\n";
					
			$work_for_txt1 = new work_for_txt1 (); 
			
			$file1 = $file;
			$file1 = replace ('^.+\/', '', $file1);
			$file1 = replace ('^http_', '', $file1);
			$file1 = replace ('\.html$', '', $file1);
			
			//URL
			$url = '';
			$referer = '';
			$select = '';
			$scontent = '';
			
			$array = array ();
			
			$result_select_url_po_file = $work_mysql_graber -> select_url_po_file ($file1);
			if (count ($result_select_url_po_file) > 0) {
				foreach ($result_select_url_po_file as $value1) {
					array_push ($array, $value1 ['url']);
					$url = $value1 ['url'];
					$referer = $value1 ['referer'];
					$select = $value1 ['select'];
					$scontent = $value1 ['content'];
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
				$url = $array[0];
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			//id;
			$id = '';
			$array = array ();					
			$pattern1 = '/^(.+?)$/'; 
			$work_for_content1 = new work_for_content ($url);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$value1 = strip_tags (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('\s+',' ', $value1);
				$value1 = preg_replace ('/^.+\//ui', '', $value1);
				
				array_push ($array, $value1);
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
				$id = $array[0];
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			// name
			$array = array ();
			$pattern1 = '/(<h1.+?<\/h1>)/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$value1 = strip_tags1 (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('^\s+$','', $value1);
				
				if ($value1 != '') {
					$value1 = preg_replace ('/basketball profile/ui', '', $value1);
					$value1 = preg_replace ('/^\s+/ui', '', $value1);
					$value1 = preg_replace ('/\s+$/ui', '', $value1);
					$value1 = strip_tags1(html_entity_decode($value1));
					array_push ($array, $value1);
				}
			}
			
			if (count ($array) > 0) {
				$str = join (' ', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}


			$work_for_txt1 -> put ('coach'); 
			
			
			//nationality_code
			$array = array ();
			$pattern1 = '/Nationality:(.+?)</'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$value1 = strip_tags1 (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('^\s+$','', $value1);
				if ($value1 != '') {
					array_push ($array, $value1);
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}

			
			
			// first_name			
			$array = array ();
			$pattern1 = '/(<h1.+?<\/span>)/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$value1 = strip_tags1 (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('^\s+$','', $value1);
				
				if ($value1 != '') {
					$value1 = preg_replace ('/basketball profile/ui', '', $value1);
					$value1 = trim (strip_tags(html_entity_decode($value1)));
					
					$a = preg_split ('/\s+/ui', $value1);
					if (count ($a) > 0) {
						array_push ($array, array_shift ($a));
					}
				}
			}
			
			if (count ($array) > 0) {
				$str = join (' ', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			// last_name
			$array = array ();
			$pattern1 = '/(<h1.+?<\/h1>)/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$value1 = strip_tags1 (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('^\s+$','', $value1);
				
				if ($value1 != '') {
					$value1 = preg_replace ('/basketball profile/ui', '', $value1);
					$value1 = trim (strip_tags(html_entity_decode($value1)));
					
					$a = preg_split ('/\s+/ui', $value1);
					if (count ($a) > 1) {
						array_shift ($a);
						array_push ($array, join (' ', $a));
					}
				}
			}
			
			if (count ($array) > 0) {
				$str = join (' ', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			// date_of_birth
			$array = array ();
			$pattern1 = '/Born:(.+?)</'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$value1 = strip_tags1 (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('^\s+$','', $value1);
				if ($value1 != '') {
					$time = strtotime ($value1);
					$date = date('Y-m-d H:i:s', $time);
					$date = preg_replace ('/\s.+$/ui', '', $date);
					array_push ($array, $date);
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			// place_of_birth
			$array = array ();
			$pattern1 = '/Birthplace:(.+?)</'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$value1 = strip_tags1 (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('^\s+$','', $value1);
				if ($value1 != '') {
					array_push ($array, $value1);
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			// height
			$array = array ();
			$pattern1 = '/Height:(.+?)cm/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$value1 = strip_tags1 (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('^\s+$','', $value1);
				if ($value1 != '') {
					array_push ($array, $value1);
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			// weight
			$array = array ();
			$pattern1 = '/Weight:(.+?)kg/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$value1 = strip_tags1 (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('^\s+$','', $value1);
				if ($value1 != '') {
					array_push ($array, $value1);
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			// teamid
			$array = array ();
			$json_decode = json_decode ($select);
			if (isset ($json_decode -> {'team_id'})) {
				$pattern1 = '/^(.+)$/'; 
				$work_for_content1 = new work_for_content ($json_decode -> {'team_id'});
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					$value1 = strip_tags1 (html_entity_decode ($value1));
					$value1 = replace ('^\s+','', $value1);
					$value1 = replace ('\s+$','', $value1);
					$value1 = replace ('^\s+$','', $value1);
					if ($value1 != '') {
						array_push ($array, $value1);
					}
				}
				
			} else {
			
				$pattern1 = '/Team:(.+?)<\/div>/'; 
				$work_for_content1 = new work_for_content ($content);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					//$value1 = strip_tags1 (html_entity_decode ($value1));
					$value1 = replace ('^\s+','', $value1);
					$value1 = replace ('\s+$','', $value1);
					$value1 = replace ('^\s+$','', $value1);
					
					$pattern2 = '/href="(.+?)"/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$value2 = strip_tags1 (html_entity_decode ($value2));
						$value2 = replace ('^\s+','', $value2);
						$value2 = replace ('\s+$','', $value2);
						$value2 = replace ('^\s+$','', $value2);

						$value2 = preg_replace ('/^.+\//ui', '', $value2);
						
						if ($value2 != '') {
							array_push ($array, $value2);
						}
					}
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			//img
			$array = array ();
			$pattern1 = '/<\/h1>.+?<img.+?src.+?"(.+?)"/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				
				if (preg_match ('/coach/ui', $value1)) {
				
					$pattern2 = '/^(.+)$/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$value2 = strip_tags1 (html_entity_decode ($value2));
						$value2 = replace ('^\s+','', $value2);
						$value2 = replace ('\s+$','', $value2);
						$value2 = replace ('^\s+$','', $value2);
						
						if (!preg_match ('/^http/', $value2)) {
							$value2 = 'https://'.$this -> host . $value2;
						}
						
						if ($value2 != '') {
							array_push ($array, $value2);
						}
					}
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			//actual_date
			$array = array ();
			$json_decode = json_decode ($select);
			if (isset ($json_decode -> {'actual_date'})) {
				array_push ($array, $json_decode -> {'actual_date'});	
			}	
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
				
			
			$str = $work_for_txt1 -> get ();
			$write_text_file_rewrite -> put_str ($str ."\n");
			unset ($work_for_txt1);
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
	$pattern1 = '/'.$pattern1.'/ui';
	$content = preg_replace ($pattern1, $pattern2, $content);
	return $content;
}	


?>
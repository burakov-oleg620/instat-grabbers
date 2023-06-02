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
$file2 = $workdir2.'/write_text_file_rewrite6.xls';

$write_text_file_rewrite = new write_text_file_rewrite ($file2);
$workdir = $workdir .'/out';


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
			$content1 = replace ('><', '> <', $content1);
			$content1 = replace ('\'', '"', $content1);
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
			$array = array ();
			
			$result_select_url_po_file = $work_mysql_graber -> select_url_po_file ($file1);
			if (count ($result_select_url_po_file) > 0) {
				foreach ($result_select_url_po_file as $value1) {
					array_push ($array, $value1 ['url']);
					$url = $value1 ['url'];
					$referer = $value1 ['referer'];
					$select = $value1 ['select'];
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
				$url = $array[0];
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			//id
			$array = array ();
			$pattern3 = '/Game=(.+?)-/'; 
			$work_for_content3 = new work_for_content ($url);
			$array3 = $work_for_content3 -> get_pattern ($pattern3);
			foreach ($array3[1] as $value3) {
				$value3 = strip_tags1 (html_entity_decode ($value3));
				$value3 = replace ('^\s+','', $value3);
				$value3 = replace ('\s+$','', $value3);
				$value3 = replace ('^\s+$','', $value3);
				if ($value3 != '') {

					$a = preg_split ('/_/ui', $value3);
					if (count ($a) == 4) {
						
						array_shift ($a);
						array_shift ($a);
						$value3 = join ('', $a);
						
						array_push ($array, $value3);
						
					}	
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			//date
			$array = array ();
			$pattern3 = '/Game=(.+?)-/'; 
			$work_for_content3 = new work_for_content ($url);
			$array3 = $work_for_content3 -> get_pattern ($pattern3);
			foreach ($array3[1] as $value3) {
				$value3 = strip_tags1 (html_entity_decode ($value3));
				$value3 = replace ('^\s+','', $value3);
				$value3 = replace ('\s+$','', $value3);
				$value3 = replace ('^\s+$','', $value3);
				if ($value3 != '') {

					$a = preg_split ('/_/ui', $value3);
					if (count ($a) == 4) {
						
						array_pop ($a);
						array_pop ($a);
						$value3 = join ('', $a);
						$d = preg_split ('//ui', $value3);
						if (count ($d) > 0) {
							array_shift ($d);
							$date = $d[0].$d[1].$d[2].$d[3].'-'.$d[4].$d[5].'-'.$d[6].$d[7];
							array_push ($array, $date);
							
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
			
			$arTable = array ();
			$html = new simple_html_dom (); 
			$html->load ($content);
			$element = $html->find('table[id="adm-nav-page"]');
			if(count($element) > 0) {
				foreach($element as $table) {
					//echo '1 = '.  $table->innertext ."\n";
					array_push ($arTable, $table->innertext);
				}
			}
						

			
			//team_a
			$count_table = 0;
			$team_id_a = '';
			$array = array ();
			$pattern1 = '/(<TABLE cellSpacing=0 cellPadding=5 width=100% border=0 id="aa.+?<\/TABLE>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$count_table++;
			
				if ($count_table == 1) {
					
					$pattern2 = '/(<a.+?<\/a>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						if (preg_match ('/\/team\//ui', $value2)) {
						
							$pattern3 = '/(<a.+?<\/a>)/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$str = '<team_name>'.$value3.'</team_name>';
								array_push ($array, $str);
							}
						}
					}					
					
					$pattern2 = '/(<a.+?<\/a>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						if (preg_match ('/\/team\//ui', $value2)) {
						
							$pattern3 = '/href="(.+?)"/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = preg_replace ('/^.+\//ui', '', $value3);
								$str = '<team_id>'.$value3.'</team_id>';
								array_push ($array, $str);
								$team_id_a = $value3;
							}
						}
					}					
				}
			}
			
			$pattern1 = '/(<table cellspacing="0" cellpadding="5" width="100%" border="0" id="aa.+?<\/table>)/';
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$count_table++;
			
				if ($count_table == 1) {
					
					$pattern2 = '/(<a.+?<\/a>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						if (preg_match ('/\/team\//ui', $value2)) {
						
							$pattern3 = '/(<a.+?<\/a>)/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$str = '<team_name>'.$value3.'</team_name>';
								array_push ($array, $str);
							}
						}
					}					
					
					$pattern2 = '/(<a.+?<\/a>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						if (preg_match ('/\/team\//ui', $value2)) {
						
							$pattern3 = '/href="(.+?)"/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = preg_replace ('/^.+\//ui', '', $value3);
								$str = '<team_id>'.$value3.'</team_id>';
								array_push ($array, $str);
								$team_id_a = $value3;
							}
						}
					}					
				}
			}
			
					
			if (count ($array) > 0) {
				$str = join ('', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
					
			//team_b
			$count_table = 0;
			$team_id_b = '';
			$array = array ();
			$pattern1 = '/(<TABLE cellSpacing=0 cellPadding=5 width=100% border=0 id="aa.+?<\/TABLE>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$count_table++;
			
				if ($count_table == 2) {
					
					$pattern2 = '/(<a.+?<\/a>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						if (preg_match ('/\/team\//ui', $value2)) {
						
							$pattern3 = '/(<a.+?<\/a>)/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$str = '<team_name>'.$value3.'</team_name>';
								array_push ($array, $str);
							}
						}
					}					
					
					$pattern2 = '/(<a.+?<\/a>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						if (preg_match ('/\/team\//ui', $value2)) {
						
							$pattern3 = '/href="(.+?)"/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = preg_replace ('/^.+\//ui', '', $value3);
								$str = '<team_id>'.$value3.'</team_id>';
								array_push ($array, $str);
								$team_id_b = $value3;
							}
						}
					}					
				}
			}
			
			$pattern1 = '/(<table cellspacing="0" cellpadding="5" width="100%" border="0" id="aa.+?<\/table>)/';
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$count_table++;
			
				if ($count_table == 2) {
					
					$pattern2 = '/(<a.+?<\/a>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						if (preg_match ('/\/team\//ui', $value2)) {
						
							$pattern3 = '/(<a.+?<\/a>)/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$str = '<team_name>'.$value3.'</team_name>';
								array_push ($array, $str);
							}
						}
					}					
					
					$pattern2 = '/(<a.+?<\/a>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						if (preg_match ('/\/team\//ui', $value2)) {
						
							$pattern3 = '/href="(.+?)"/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = preg_replace ('/^.+\//ui', '', $value3);
								$str = '<team_id>'.$value3.'</team_id>';
								array_push ($array, $str);
								$team_id_a = $value3;
							}
						}
					}					
				}
			}
			
					
			if (count ($array) > 0) {
				$str = join ('', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
					
			//счет1
			$array = array ();
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			//счет2
			$array = array ();
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			//graph team_a
			$array = array ();
			$pattern1 = '/(<table id="graph">.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<div id="pt1".+?<div.+?<div.+?<div.+?<\/div>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
					
					$td = array ();
					$pattern3 = '/(<div.+?<\/div>)/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						// $str = '<team_name>'.$value3.'</team_name>';
						// array_push ($array, $str);
						array_push ($td, $value3);
						
					}
					array_shift ($td);
					$str = '<team_id>'.$team_id_a .'<team_id>'.'<label>'.$td[1].'</label>'.'<value>'.$td[0].'</value>';
					array_push ($array, $str);
				}					
			}
					
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			//graph team_b
			$array = array ();
			$pattern1 = '/(<table id="graph">.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<div id="pt1".+?<div.+?<div.+?<div.+?<\/div>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
					
					$td = array ();
					$pattern3 = '/(<div.+?<\/div>)/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						// $str = '<team_name>'.$value3.'</team_name>';
						// array_push ($array, $str);
						array_push ($td, $value3);
						
					}
					array_shift ($td);
					$str = '<team_id>'.$team_id_b .'<team_id>'.'<label>'.$td[1].'</label>'.'<value>'.$td[2].'</value>';
					array_push ($array, $str);
				}					
			}
					
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			$arTable = array ();
			$html = new simple_html_dom (); 
			$html->load ($content);
			$element = $html->find('table[id="aannew"]');
			//$element = $html->find('/');
			if(count($element) > 0) {
				foreach($element as $table) {
					echo '1 = '.  $table->innertext ."\n";
					array_push ($arTable, $table->innertext);
				}
			}
				
			
			//teama_players
			$count_table = 0;
			$array = array ();
			$pattern1 = '/(<TABLE cellSpacing=0 cellPadding=5 width=100% border=0 id="aa.+?<TABLE class=my_Title.+?<\/TABLE>)/'; 
			//$pattern1 = '/(<table cellspacing="0" cellpadding="5" width="100%" border="0" id="aa.+?<\/table>)/';
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$count_table++;
			
				if ($count_table == 1) {
					
					$team_id = '';
					$pattern2 = '/href="(.+?)"/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						
						if (preg_match ('/\/team\//ui', $value2)) {
							$team_id = preg_replace ('/^.+\//ui', '', $value2);
						}
					}
					
					$pattern2 = '/(<A.+?<\/A>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						
						if (preg_match ('/\/player\//ui', $value2)) {
							
							$player_id = '';
							$player_name = '';
							
							$pattern3 = '/href="(.+?)"/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$player_id = preg_replace ('/^.+\//ui', '', $value3);
							}
							
							$pattern3 = '/^(.+)$/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$player_name = $value3;
							}
							
							$str = '<team_id>'.$team_id.'</team_id>'.'<player_name>'.$player_name.'</player_name>'.'<player_id>'.$player_id.'</player_id>';
							array_push ($array, $str);
						}
					}
				}
			}
			
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			

			//teamb_players
			$count_table = 0;
			$array = array ();
			$pattern1 = '/(<TABLE cellSpacing=0 cellPadding=5 width=100% border=0 id="aa.+?<TABLE class=my_Title.+?<\/TABLE>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$count_table++;
			
				if ($count_table == 2) {
					
					$team_id = '';
					$pattern2 = '/href="(.+?)"/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						
						if (preg_match ('/\/team\//ui', $value2)) {
							$team_id = preg_replace ('/^.+\//ui', '', $value2);
						}
					}
					
					$pattern2 = '/(<A.+?<\/A>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						
						if (preg_match ('/\/player\//ui', $value2)) {
							
							$player_id = '';
							$player_name = '';
							
							$pattern3 = '/href="(.+?)"/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$player_id = preg_replace ('/^.+\//ui', '', $value3);
							}
							
							$pattern3 = '/^(.+)$/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$player_name = $value3;
							}
							
							$str = '<team_id>'.$team_id.'</team_id>'.'<player_name>'.$player_name.'</player_name>'.'<player_id>'.$player_id.'</player_id>';
							array_push ($array, $str);
						}
					}
				}
			}


			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			
			//teama_players_stat
			$th = array ();
			$count_table = 0;
			$array = array ();
			$pattern1 = '/(<TABLE cellSpacing=0 cellPadding=5 width=100% border=0 id="aa.+?<TABLE class=my_Title.+?<\/TABLE>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$count_table++;
			
				if ($count_table == 1) {
					
					$team_id = '';
					$pattern2 = '/href="(.+?)"/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						if (preg_match ('/\/team\//ui', $value2)) {
							$team_id = preg_replace ('/^.+\//ui', '', $value2);
						}
					}
					
					$pattern2 = '/(<TABLE class=my_Title.+?<\/TABLE>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						
						$pattern3 = '/(<TR class=my_Headers vAlign=center.+?<\/TR>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							
							$td = array ();
							$pattern4 = '/(<TD.+?<\/TD>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
								
								
								$value4 = strip_tags1 (html_entity_decode ($value4));
								$value4 = replace ('^\s+','', $value4);
								$value4 = replace ('\s+$','', $value4);
								$value4 = replace ('\s+',' ', $value4);
								$value4 = strtolower ($value4);
								if ($value4 == '#') {
									$value4 = 'shirtnumber';
								}
								if ($value4 == 'name') {
									$value4 = 'player_name';
								}
								
								array_push ($th, $value4);
							}	
						}
						
						$pattern3 = '/(<TR class=my_pStats1.+?<\/TR>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							
							
							$player_id = '';
							$player_name = '';
							
							$pattern4 = '/href="(.+?)"/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
								$player_id = preg_replace ('/^.+\//ui', '', $value4);
							}
							
							$pattern4 = '/^(.+)$/'; 
							$work_for_content3 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
								$value4 = strip_tags1 (html_entity_decode ($value4));
								$value4 = replace ('^\s+','', $value4);
								$value4 = replace ('\s+$','', $value4);
								$value4 = replace ('\s+',' ', $value4);
								$player_name = $value4;
							}
							
							
							$count_td = 0;
							$td = array ();
							$pattern4 = '/(<TD.+?<\/TD>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
								$value4 = strip_tags1 (html_entity_decode ($value4));
								$value4 = replace ('^\s+','', $value4);
								$value4 = replace ('\s+$','', $value4);
								$value4 = replace ('\s+',' ', $value4);
								
								//array_push ($th, $value4);
								$td [$th[$count_td]] = $value4;
								$td ['player_id'] = $player_id;
								
								$count_td++;
							}	
							
							//print_r ($td) ."\n";
							$array[$team_id][$player_id] = $td;
						}
					}	
				}
			}
			
			
			if (count ($array) > 0) {
				//$str = join ('||', $array);
				$str = json_encode ($array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			//teamb_players_stat
			$th = array ();
			$count_table = 0;
			$array = array ();
			$pattern1 = '/(<TABLE cellSpacing=0 cellPadding=5 width=100% border=0 id="aa.+?<TABLE class=my_Title.+?<\/TABLE>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$count_table++;
			
				if ($count_table == 2) {
					
					$team_id = '';
					$pattern2 = '/href="(.+?)"/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						if (preg_match ('/\/team\//ui', $value2)) {
							$team_id = preg_replace ('/^.+\//ui', '', $value2);
						}
					}
					
					$pattern2 = '/(<TABLE class=my_Title.+?<\/TABLE>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
						
						$pattern3 = '/(<TR class=my_Headers vAlign=center.+?<\/TR>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							
							$td = array ();
							$pattern4 = '/(<TD.+?<\/TD>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
								
								
								$value4 = strip_tags1 (html_entity_decode ($value4));
								$value4 = replace ('^\s+','', $value4);
								$value4 = replace ('\s+$','', $value4);
								$value4 = replace ('\s+',' ', $value4);
								$value4 = strtolower ($value4);
								if ($value4 == '#') {
									$value4 = 'shirtnumber';
								}
								if ($value4 == 'name') {
									$value4 = 'player_name';
								}
								
								array_push ($th, $value4);
							}	
						}
						
						$pattern3 = '/(<TR class=my_pStats1.+?<\/TR>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							
							
							$player_id = '';
							$player_name = '';
							
							$pattern4 = '/href="(.+?)"/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
								$player_id = preg_replace ('/^.+\//ui', '', $value4);
							}
							
							$pattern4 = '/^(.+)$/'; 
							$work_for_content3 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
								$value4 = strip_tags1 (html_entity_decode ($value4));
								$value4 = replace ('^\s+','', $value4);
								$value4 = replace ('\s+$','', $value4);
								$value4 = replace ('\s+',' ', $value4);
								$player_name = $value4;
							}
							
							
							$count_td = 0;
							$td = array ();
							$pattern4 = '/(<TD.+?<\/TD>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
								$value4 = strip_tags1 (html_entity_decode ($value4));
								$value4 = replace ('^\s+','', $value4);
								$value4 = replace ('\s+$','', $value4);
								$value4 = replace ('\s+',' ', $value4);
								
								//array_push ($th, $value4);
								$td [$th[$count_td]] = $value4;
								$td ['player_id'] = $player_id;
								
								$count_td++;
							}	
							
							//print_r ($td) ."\n";
							$array[$team_id][$player_id] = $td;
						}
					}	
				}
			}
			
			
			if (count ($array) > 0) {
				//$str = join ('||', $array);
				$str = json_encode ($array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			//competition
			$array = array ();
			$pattern3 = '/(<div id="divBoxScore">.+?<\/span>)/'; 
			$pattern3 = '/^(.+)$/'; 
			$work_for_content3 = new work_for_content ($url);
			$array3 = $work_for_content3 -> get_pattern ($pattern3);
			foreach ($array3[1] as $value3) {
				$value3 = strip_tags1 (html_entity_decode ($value3));
				$value3 = replace ('^\s+','', $value3);
				$value3 = replace ('\s+$','', $value3);
				$value3 = replace ('^\s+$','', $value3);
				if ($value3 != '') {
					$value3 = preg_replace ('/^.+-/ui', '', $value3);
					$value3 = urldecode ($value3);
					array_push ($array, trim(strip_tags (html_entity_decode($value3))));
				}
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
	$pattern1 = '/'.$pattern1.'/u';
	$content = preg_replace ($pattern1, $pattern2, $content);
	return $content;
}	


?>
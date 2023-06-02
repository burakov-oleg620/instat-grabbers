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
$file2 = $workdir2.'/write_text_file_rewrite1.xls';

$write_text_file_rewrite = new write_text_file_rewrite ($file2);
$workdir = $workdir .'/html';


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
					
			// $work_for_txt1 = new work_for_txt1 (); 
			
			// $file1 = $file;
			// $file1 = replace ('^.+\/', '', $file1);
			// $file1 = replace ('^http_', '', $file1);
			// $file1 = replace ('\.html$', '', $file1);
			
			// //URL
			// $url = '';
			// $referer = '';
			// $select = '';
			// $array = array ();
			
			// $result_select_url_po_file = $work_mysql_graber -> select_url_po_file ($file1);
			// if (count ($result_select_url_po_file) > 0) {
				// foreach ($result_select_url_po_file as $value1) {
					// array_push ($array, $value1 ['url']);
					// $url = $value1 ['url'];
					// $referer = $value1 ['referer'];
					// $select = $value1 ['select'];
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
				// $url = $array[0];
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			
			// $select_str = json_decode ($select);
			//print var_dump ($select_str) ."\n";
			
			$pattern1 = '/(<ul class="submenu hidden".+?<\/ul>)/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/href="(.+?)"/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {

					if (preg_match ('/hockey/', $value2)) {

						if (!preg_match ('/^http/', $value2)) {
							//$value2 = 'https://'.$this -> host . '/'.$value2;
							$value2 = 'https://'.$host . $value2;
						}
						
						$url = $value2; 
						print $url ."\n";
					}
				}
			}
			
			
			$array = array ();
			if (preg_match ('/\{"commands"/', $content1)) {
				$json_decode = json_decode ($content1);
				// print var_dump ($json_decode) ."\n";
				
				//print $json_decode -> {'commands'} [0] -> {'parameters'} -> {'content'}."\n";
				
				$ccontent = $json_decode -> {'commands'} [0] -> {'parameters'} -> {'content'};
				
				$ccontent = preg_replace ('/\n+/', '', $ccontent);
				$ccontent = preg_replace ('/\r+/', '', $ccontent);
				$ccontent = preg_replace ('/\t+/', '', $ccontent);
				$ccontent = html_entity_decode ($ccontent);
				
				 //print $ccontent ."\n";
				 
				$pattern1 = '/(<table class="matches.+?<\/table>)/'; 
				$work_for_content1 = new work_for_content ($ccontent);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
				
					$pattern2 = '/(<tr.+?<\/tr>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$time_global = '';
						$pattern3 = '/data-timestamp="(.+?)"/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							$time_global = $value3;
						}
					
				
						$td = array ();
						$pattern3 = '/(<td.+?<\/td>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							
							//$value3 = strip_tags1 (html_entity_decode ($value3));
							$value3 = replace ('^\s+','', $value3);
							$value3 = replace ('\s+$','', $value3);
							$value3 = replace ('\s+',' ', $value3);
						
							//print $value3 ."\n";
							array_push ($td, $value3);
						}
						
						//print 'count ($td) = '. count ($td) ."\n";
						if (count ($td) == 7) {
						
							//print $td[1] ."\n";
							if (!preg_match ('/data-value=/',$td[1])) {
								$td[1] =  'data-value=\''.$time_global.'\'';
							}
							//print $td[1] ."\n";
						
						
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
							
							
							$select_str = json_decode ($select);
							
							
							$array = array ();					
							foreach ($select_str -> {'competition'} as $key => $value) {
								
								
								$pattern1 = '/^(.+)$/'; 
								$work_for_content1 = new work_for_content ($value);
								$array1 = $work_for_content1 -> get_pattern ($pattern1);
								foreach ($array1[1] as $value1) {
								
									//$value1 = strip_tags (html_entity_decode ($value1));
									$value1 = replace ('^\s+','', $value1);
									$value1 = replace ('\s+$','', $value1);
									$value1 = replace ('\s+',' ', $value1);
									
									array_push ($array, $value1);
								}
							}
							
							if (count ($array) > 0) {
								$str = join ('', $array);
								$work_for_txt1 -> put ($str); 
							} else {
								$work_for_txt1 -> put ('-'); 
							}
							
							$array = array ();					
							foreach ($select_str -> {'season'} as $key => $value) {
								
								$pattern1 = '/^(.+)$/'; 
								$work_for_content1 = new work_for_content ($value);
								$array1 = $work_for_content1 -> get_pattern ($pattern1);
								foreach ($array1[1] as $value1) {
								
									//$value1 = strip_tags (html_entity_decode ($value1));
									$value1 = replace ('^\s+','', $value1);
									$value1 = replace ('\s+$','', $value1);
									$value1 = replace ('\s+',' ', $value1);
									
									array_push ($array, $value1);
								}
							}
							
							if (count ($array) > 0) {
								$str = join ('', $array);
								$work_for_txt1 -> put ($str); 
							} else {
								$work_for_txt1 -> put ('-'); 
							}
							
							
							//print_r ($td) ."\n";
							
							
							
							$array_global = array ();


							//match_url
							$array = array ();
							$pattern3 = '/href="(.+?)"/'; 
							$work_for_content3 = new work_for_content ($td[3]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								
								$pattern4 = '/^(.+)$/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
									
									$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
									$value4 = 'http://'.$host.$value4;
							
									array_push ($array, $value4);
								}
							}
							
							if (count ($array) > 0) {
								$str = '<url>'.$array[0].'</url>';
								array_push ($array_global, $str);
							} 
							
							
							//match_id
							$array = array ();
							$pattern3 = '/href="(.+?)"/'; 
							$work_for_content3 = new work_for_content ($td[3]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								
								$pattern4 = '/id=(\d+)$/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
									
									$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
							
									array_push ($array, $value4);
								}
							}
							
							if (count ($array) > 0) {
								$str = '<id>'.$array[0].'</id>';
								array_push ($array_global, $str);
							} 
							
							

							//team_a_id
							$array = array ();
							$pattern3 = '/href="(.+?)"/'; 
							$work_for_content3 = new work_for_content ($td[2]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								
								$pattern4 = '/id=(\d+)$/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
									
									$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
							
									array_push ($array, $value4);
								}
							}
							
							if (count ($array) > 0) {
								$str = '<first_team_id>'.$array[0].'</first_team_id>';
								array_push ($array_global, $str);
							} 
							
							//team_a_name
							$array = array ();
							$pattern3 = '/(<td.+?<\/td>)/'; 
							$work_for_content3 = new work_for_content ($td[2]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
							
								array_push ($array, $value3);
							}
							
							if (count ($array) > 0) {
								$str = '<first_team_name>'.$array[0].'</first_team_name>';
								array_push ($array_global, $str);
							} 
							
							//team_b_id
							$array = array ();
							$pattern3 = '/href="(.+?)"/'; 
							$work_for_content3 = new work_for_content ($td[4]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								
								$pattern4 = '/id=(\d+)$/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
									
									$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
							
									array_push ($array, $value4);
								}
							}
							
							if (count ($array) > 0) {
								$str = '<second_team_id>'.$array[0].'</second_team_id>';
								array_push ($array_global, $str);
							} 
							
							//team_b_name
							$array = array ();
							$pattern3 = '/(<td.+?<\/td>)/'; 
							$work_for_content3 = new work_for_content ($td[4]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
							
								array_push ($array, $value3);
							}
							
							if (count ($array) > 0) {
								$str = '<second_team_name>'.$array[0].'</second_team_name>';
								array_push ($array_global, $str);
								//print $str ."\n";
							} 
							

							
							//time
							$array = array ();
							$pattern3 = '/data-value=\'(.+?)\'/'; 
							$work_for_content3 = new work_for_content ($td[1]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
							
								array_push ($array, $value3);
							}
							
							if (count ($array) > 0) {
								$str = '<match_time>'.$array[0].'</match_time>';
								array_push ($array_global, $str);
								//print $str ."\n";
							} 
							
							
							//print $file ."\n";
							//date
							$array = array ();
							$pattern3 = '/data-value=\'(.+?)\'/'; 
							$work_for_content3 = new work_for_content ($td[1]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = date('Y-m-d H:i:s',$value3);
							
								array_push ($array, $value3);
							}
							
							if (count ($array) > 0) {
								$str = '<match_date>'.$array[0].'</match_date>';
								array_push ($array_global, $str);
								//print $str ."\n";
							} 
							
							//score
							$array = array ();
							$pattern3 = '/(<td.+?<\/td>)/'; 
							$work_for_content3 = new work_for_content ($td[3]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
							
								array_push ($array, $value3);
							}
							
							if (count ($array) > 0) {
								$str = '<score>'.$array[0].'</score>';
								array_push ($array_global, $str);
							} 
							
							if (count ($array_global) > 0) {
								$str = join ('', $array_global);
								$work_for_txt1 -> put ($str); 
							} else {
								$work_for_txt1 -> put ('-'); 
							}
							
							
							$work_for_txt1 -> put (1); 
										
										
							$str = $work_for_txt1 -> get ();
							$write_text_file_rewrite -> put_str ($str ."\n");
							unset ($work_for_txt1);
							
						}
					}
				}
			}	 
				
				
			
			
							
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
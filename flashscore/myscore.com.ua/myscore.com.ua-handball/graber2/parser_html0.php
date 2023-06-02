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
$file2 = $workdir2.'/write_text_file_rewrite0.xls';

$write_text_file_rewrite = new write_text_file_rewrite ($file2);

$workdir = $workdir .'/html';

$count = 0;

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
				$clear_str = new clear_str ($str);
				$str = $clear_str -> delete_2 ();
				unset ($clear_str); 
				array_push ($file_array, $str);
			}
			fclose ($fh);
			
			$content = join (' ', $file_array);
			
			
			// $content2 = json_decode ($content);
			// // print var_dump ($content2) ."\n";
			// //print var_dump ($content2 -> {'team'} -> {'squad'}) ."\n";
			
			// foreach ($content2 -> {'team'} -> {'squad'} as $key => $value) {
				// print $value -> {'id'} ."\n";
			// }
			
			
			
			// print $content ."\n";
			//$content = iconv ("utf-8", "windows-1251", $content); 
			// $content = iconv ("utf-8", "windows-1251//IGNORE", $content); 
			// $content = iconv ("utf-8", "windows-1251//TRANSLIT//IGNORE", $content); 
			// print $content ."\n";
			
			// $arTable = array ();
			// $html = new simple_html_dom (); 
			// $html->load ($content);
			// $element = $html->find('table[class="offers_box_table"]');
			// //$element2 = $html->find('div[class="navig"]');
			// if(count($element) > 0) {
				// foreach($element as $table) {
					// //echo '1 = '.  $table->innertext ."\n";
					// array_push ($arTable, $table->innertext);
				// }
			// }
			
			// $table = array ();
			// if (count ($arTable) > 0) {
				// foreach ($arTable as $arTableValue) {
					// print $arTableValue ."\n";
					// print $file ."\n";
					

			$round  = '';
			$pattern0 = '/(<table class="authorstable".+?<\/table>)/';
			$work_for_content0 = new work_for_content ($content);
			$array0 = $work_for_content0 -> get_pattern ($pattern0);
			foreach ($array0[1] as $value0) {
				$value0 = html_entity_decode ($value0);
				$value0 = str_replace ('\'', '"', $value0);
				
				if (preg_match ('/Game=/ui', $value0)) {
					//print $value0 ."\n";	
					
					$array = array ();					
					$pattern1 = '/(<tr.+?<\/tr>)/'; 
					$work_for_content1 = new work_for_content ($value0);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						//$value1 = strip_tags (html_entity_decode ($value1));
						// $value1 = replace ('^\s+','', $value1);
						// $value1 = replace ('\s+$','', $value1);
						// $value1 = replace ('\s+',' ', $value1);
						//array_push ($array, $value1);
						//print $value1 ."\n";
						
						$td = array ();
						$pattern2 = '/(<td.+?<\/td>)/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
							
							//print $value2 ."\n";
							array_push ($td, $value2);
						}	
						
						if (count ($td)  == 1) {
							$s = strip_tags1 (html_entity_decode ($value1));
							$s = preg_replace ('/^\s+/ui', '', $s);
							$s = preg_replace ('/\s+$/ui', '', $s);
							if (mb_strlen ($s) > 0) {
								$round = $s;
							}
						}
						
						if ($round == '') {
							print $value1 ."\n";
							
						}
						
						if (count ($td) == 3) {
							
							$work_for_txt1 = new work_for_txt1 (); 
							
							
							//url
							$url = '';
							$array = array ();
							$pattern3 = '/href="(.+?)"/'; 
							$work_for_content3 = new work_for_content ($td[2]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('^\s+$','', $value3);
								if ($value3 != '') {
									array_push ($array, $value3);
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
							
							
							//score_home
							$array = array ();
							$pattern3 = '/^(.+)$/'; 
							$work_for_content3 = new work_for_content ($td[2]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('^\s+$','', $value3);
								if ($value3 != '') {
									
									$a1 = preg_split ('/\s+/ui', $value3);
									if (count ($a1) > 0) {
										$a2 = preg_split ('/-/ui', $a1[0]);
										if (count ($a2) > 0) {
											$str = trim (strip_tags (html_entity_decode ($a2[0])));
											array_push ($array, $str);
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
							
							//score_away
							$array = array ();
							$pattern3 = '/^(.+)$/'; 
							$work_for_content3 = new work_for_content ($td[2]);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('^\s+$','', $value3);
								
								if ($value3 != '') {
									
									$a1 = preg_split ('/\s+/ui', $value3);
									if (count ($a1) > 0) {
										$a2 = preg_split ('/-/ui', $a1[0]);
										if (count ($a2) > 0) {
											
											$str = trim (strip_tags (html_entity_decode ($a2[1])));
											array_push ($array, $str);
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
							
							$work_for_txt1 -> put ($round); 
							
							$str = $work_for_txt1 -> get ();
							$write_text_file_rewrite -> put_str ($str ."\n");
							unset ($work_for_txt1);
							
						}
						
					}
					
					// if (count ($array) > 0) {
						// $str = join ('||', $array);
						// $work_for_txt1 -> put ($array[0]); 
						// $id = $array[0];
					// } else {
						// $work_for_txt1 -> put ('-'); 
					// }
					
				}

			}		
					
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
			
			// $array = array ();					
			// $pattern1 = '/(<squad>.+?<\/squad>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
			
				// // $value1 = strip_tags (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('\s+',' ', $value1);
				
				// array_push ($array, $value1);
			// }
			
			
			// //id;
			// $id = '';
			// $array = array ();					
			// $pattern1 = '/&id=(.+?)$/'; 
			// $work_for_content1 = new work_for_content ($url);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
			
				// $value1 = strip_tags (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('\s+',' ', $value1);
				
				// array_push ($array, $value1);
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
				// $id = $array[0];
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // teamtype - тип (default/women/youth)
			// $array = array ();					
			// array_push ($array, 'default');
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // name
			// $array = array ();
			// $pattern1 = '/(<h1.+?<\/h1>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				// $value1 = strip_tags1 (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('^\s+$','', $value1);
				// if ($value1 != '') {
					// array_push ($array, $value1);
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // name_eng
			// $array = array ();
			// $pattern1 = '/(<h1.+?<\/h1>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				// $value1 = strip_tags1 (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('^\s+$','', $value1);
				// if ($value1 != '') {
					// array_push ($array, $value1);
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // country_code
			// $array = array ();
			// $pattern1 = '/<dt>Country<\/dt>(.+?<\/dd>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				// $value1 = strip_tags1 (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('^\s+$','', $value1);
				// if ($value1 != '') {
					// array_push ($array, $value1);
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }

			// // official_name
			// $array = array ();
			// $pattern1 = '/(<h1.+?<\/h1>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				// $value1 = strip_tags1 (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('^\s+$','', $value1);
				// if ($value1 != '') {
					// array_push ($array, $value1);
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // city
			// $array = array ();
			// $pattern1 = '/<dt>City:<\/dt>(.+?<\/dd>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				// $value1 = strip_tags1 (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('^\s+$','', $value1);
				// if ($value1 != '') {
					// array_push ($array, $value1);
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // address
			// $array = array ();
			// $pattern1 = '/<dt>Address<\/dt>(.+?<\/dd>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				// $value1 = strip_tags1 (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('^\s+$','', $value1);
				// if ($value1 != '') {
					// array_push ($array, $value1);
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // address_zip
			// $array = array ();
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // postal_address
			// $array = array ();
			// $pattern1 = '/<dt>Address<\/dt>(.+?<\/dd>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				// $value1 = strip_tags1 (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('^\s+$','', $value1);
				// if ($value1 != '') {
					// array_push ($array, $value1);
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }

			
			// // postal_zip
			// $array = array ();
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // telephone
			// $array = array ();
			// $pattern1 = '/<dt>Phone<\/dt>(.+?<\/dd>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				// $value1 = strip_tags1 (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('^\s+$','', $value1);
				// if ($value1 != '') {
					// array_push ($array, $value1);
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // fax
			// $array = array ();
			// $pattern1 = '/<dt>Fax<\/dt>(.+?<\/dd>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				// $value1 = strip_tags1 (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('^\s+$','', $value1);
				// if ($value1 != '') {
					// array_push ($array, $value1);
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // site
			// $array = array ();
			// $pattern1 = '/<p class="center website">(.+?)<\/p>/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
			
				// $pattern2 = '/href="(.+?)"/'; 
				// $work_for_content2 = new work_for_content ($value1);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
				
					// $value2 = strip_tags1 (html_entity_decode ($value2));
					// $value2 = replace ('^\s+','', $value2);
					// $value2 = replace ('\s+$','', $value2);
					// $value2 = replace ('^\s+$','', $value2);
					// if ($value2 != '') {
						// array_push ($array, $value2);
					// }
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // email
			// $array = array ();
			// $pattern1 = '/<dt>E-mail<\/dt>(.+?<\/dd>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				// $value1 = strip_tags1 (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('^\s+$','', $value1);
				// if ($value1 != '') {
					// array_push ($array, $value1);
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // founded (год образования)
			// $array = array ();
			// $pattern1 = '/<dt>Founded<\/dt>(.+?<\/dd>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				// $value1 = strip_tags1 (html_entity_decode ($value1));
				// $value1 = replace ('^\s+','', $value1);
				// $value1 = replace ('\s+$','', $value1);
				// $value1 = replace ('^\s+$','', $value1);
				// if ($value1 != '') {
					// array_push ($array, $value1);
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // club_colors (в виде "Light Blue / White / Light Blue", но не обязательно, т.к. пока не юзается)
			// $array = array ();
			// if (count ($array) > 0) {
				// $str = join ('/', $array);
				// $work_for_txt1 -> put ($str); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // type - (club/national)
			// $array = array ();
			// array_push ($array, 'club');
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // "source_name" сюда хост.
			// $array = array ();
			// array_push ($array, $host);
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			// // shield шилдик команды
			// $array = array ();
			// $pattern1 = '/(<div class="logo">.+?<\/div>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				
				// $pattern2 = '/<img.+?src.+?"(.+?)"/'; 
				// $work_for_content2 = new work_for_content ($value1);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
				
					// $value2 = strip_tags1 (html_entity_decode ($value2));
					// $value2 = replace ('^\s+','', $value2);
					// $value2 = replace ('\s+$','', $value2);
					// $value2 = replace ('^\s+$','', $value2);
					
					// if (!preg_match ('/^http/', $value2)) {
						// $value2 = 'http://'.$this -> host . $value2;
					// }
					
					// if ($value2 != '') {
						// array_push ($array, $value2);
					// }
				// }
			// }
			
			// if (count ($array) > 0) {
				// $str = join ('||', $array);
				// $work_for_txt1 -> put ($array[0]); 
			// } else {
				// $work_for_txt1 -> put ('-'); 
			// }
			
			
			// //"source_data" и всю инфу в раздел 
			// // $array = array ();
			// // array_push ($array, $content);
			// // if (count ($array) > 0) {
				// // $str = join ('||', $array);
				// // $work_for_txt1 -> put ($array[0]); 
			// // } else {
				// // $work_for_txt1 -> put ('-'); 
			// // }
			
			
			// // $array = array ();
			// // $pattern1 = '/(<p class="list-item-title">.+?<\/p>)/'; 
			// // $work_for_content1 = new work_for_content ($table_value[1]);
			// // $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// // foreach ($array1[1] as $value1) {
				// // //print $value1 ."\n";
				
				// // $pattern2 = '/href="(.+?)"/'; 
				// // $work_for_content2 = new work_for_content ($value1);
				// // $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// // foreach ($array2[1] as $value2) {
				
					// // if (!preg_match ('/^http/', $value2)) {
						// // $value2 = 'http://'.$this -> host . $value2;
					// // }
					// // array_push ($array, $value2);
				// // }
			// // }
			
			// // if (count ($array) > 0) {
				// // $str = join ('||', $array);
				// // $work_for_txt1 -> put ($str); 
				
			// // } else {
				// // $work_for_txt1 -> put ('-'); 
			// // }
			
			// $str = $work_for_txt1 -> get ();
			// $write_text_file_rewrite -> put_str ($str ."\n");
			// unset ($work_for_txt1);
			
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
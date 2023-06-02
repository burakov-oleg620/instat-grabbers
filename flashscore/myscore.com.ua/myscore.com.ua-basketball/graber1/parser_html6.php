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
			
			
			//id;
			$id = '';
			$array = array ();					
			$pattern1 = '/id=(\d+)$/'; 
			$work_for_content1 = new work_for_content ($url);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$value1 = strip_tags (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('\s+',' ', $value1);
				
				array_push ($array, $value1);
			}
			
			$pattern1 = '/id=(\d+)&/'; 
			$work_for_content1 = new work_for_content ($url);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$value1 = strip_tags (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('\s+',' ', $value1);
				
				array_push ($array, $value1);
			}
			
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
				$id = $array[0];
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			//unixtime;
			$array = array ();					
			$pattern1 = '/(<div class="details.+?<\/div>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<dt>Date<\/dt>.+?<\/dd>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
					$pattern3 = '/<span class=\'timestamp\' data-value=\'(\d+)\'/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
				
						$value3 = strip_tags (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						
						// $value2 = strtotime ($value2);
						// $value2 = $value2 + 8*3600;
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
			$pattern1 = '/(<div class="details.+?<\/div>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<dt>Date<\/dt>.+?<\/dd>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
					$pattern3 = '/<span class=\'timestamp\' data-value=\'(\d+)\'/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
				
						$value3 = strip_tags (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
					
						//$value3 = strtotime ($value3);
						// $value3 = $value2 + 3600*8;
						
						$date = getdate ($value3);
						$date_a = array ();
						array_push ($date_a, $date['year']);
						array_push ($date_a, $date['mon']);
						array_push ($date_a, $date['mday']);
						
						foreach ($date_a as $date_a_key => $date_a_value) {
							if (strlen ($date_a_value) < 2) {
								$date_a [$date_a_key] = '0'.$date_a [$date_a_key];
							}
						}
						$date = join ('-', $date_a);
						array_push ($array, $date);
					}
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			//time
			$array = array ();					
			$pattern1 = '/(<div class="details.+?<\/div>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<dt>Date<\/dt>.+?<\/dd>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
					$pattern3 = '/<span class=\'timestamp\' data-value=\'(\d+)\'/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
				
						$value3 = strip_tags (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
					
						//$value3 = strtotime ($value3);
						// $value3 = $value2 + 3600*8;
						
						$date = getdate ($value3);
					
						$date_a = array ();
						array_push ($date_a, $date['hours']);
						array_push ($date_a, $date['minutes']);
						
						foreach ($date_a as $date_a_key => $date_a_value) {
							if (strlen ($date_a_value) < 2) {
								$date_a [$date_a_key] = '0'.$date_a [$date_a_key];
							}
						}
						$date = join (':', $date_a);
						array_push ($array, $date);
					}
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}

			//team_a
			$team_id_a = '';
			$array = array ();
			$pattern1 = '/<span>Info<\/span>.+?<div class="content">.+?(<div class="container left">.+?<\/div>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<a.+?<\/a>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
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
				
				$pattern2 = '/(<a.+?<\/a>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
					
					$pattern3 = '/&page=team&id=(\d+)"/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						$str = '<team_id>'.$value3.'</team_id>';
						array_push ($array, $str);
						$team_id_a = $value3;
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
			$team_id_b = '';
			$array = array ();
			$pattern1 = '/<span>Info<\/span>.+?<div class="content">.+?(<div class="container right">.+?<\/div>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<a.+?<\/a>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
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
				
				$pattern2 = '/(<a.+?<\/a>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
					
					$pattern3 = '/&page=team&id=(\d+)"/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						$str = '<team_id>'.$value3.'</team_id>';
						array_push ($array, $str);
						$team_id_b = $value3;
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
			$pattern1 = '/<div class="container middle">.+?(<h3 class="thick scoretime.+?<\/h3>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				
				$value1 = replace ('<span class="score-addition.+?<\/span>', '', $value1);
				
				$value1 = strip_tags1 (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('\s+',' ', $value1);
			
				$temp = preg_split ('/-/', $value1);
				if (count ($temp) > 1) {
					foreach ($temp as $temp_value) {
						$temp_value = strip_tags (html_entity_decode ($temp_value));
						$temp_value = replace ('^\s+','', $temp_value);
						$temp_value = replace ('\s+$','', $temp_value);
						$temp_value = replace ('\s+',' ', $temp_value);
					}
					array_push ($array, $temp [0]);
				}
			}

			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			//счет2
			$array = array ();
			$pattern1 = '/(<h3 class="thick scoretime.+?<\/div>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				
				$value1 = replace ('<span class="score-addition.+?<\/span>', '', $value1);
				
				$value1 = strip_tags1 (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('\s+',' ', $value1);
			
				$temp = preg_split ('/-/', $value1);
				if (count ($temp) > 1) {
					foreach ($temp as $temp_value) {
						$temp_value = strip_tags (html_entity_decode ($temp_value));
						$temp_value = replace ('^\s+','', $temp_value);
						$temp_value = replace ('\s+$','', $temp_value);
						$temp_value = replace ('\s+',' ', $temp_value);
					}
					array_push ($array, $temp[1]);
				}
			}

			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			

			$th = array (
				// // Field players
				// 'shirtnumber' => 'player_number',
				// 'name' => 'player_name', 
				// 'position_pos' => 'pos',
				// 'goals_g' => 'g',
				// 'assists_assists_a' => 'a',
				// 'points_points_p' => 'p',
				// 'points_p' => 'p',
				// 'plus_minus' => 'plus_minus',
				// 'penalties_pmi' => 'pmi',
				// 'pmi' => 'pmi',
				// 'minutes_time_on_ice_toi' => 'toi',
				// 'hockey_minutes_fixed_size_power_play_time_on_ice_pp_toi' => 'pp_toi',
				// 'hockey_minutes_fixed_size_short_handed_time_on_ice_sh_toi' => 'sh_toi',
				// 'hockey_minutes_fixed_size_even_strength_time_on_ice_ev_toi' => 'ev_toi',
				// 'last_people_match_stat_fixed_size_shots_on_goal_sog' => 'sog',
				// 'minutes_last_people_match_stat_fixed_size_time_on_ice_toi' => 'toi',
				
				
				// #это заголовки
				// 'goals_pos' => 'g',
				// 'assists_g' => 'a',
				// 'assists_points_a' => 'p',
				// 'points_plus_minus_p' => 'plus_minus',
				// 'penalties' => 'pmi',
				// 'time_on_ice_pmi' => 'toi',
				// 'minutes_power_play_time_on_ice_toi' => 'pp_toi',
				// 'hockey_minutes_fixed_size_short_handed_time_on_ice_pp_toi' => 'pp_toi',
				// 'hockey_minutes_fixed_size_even_strength_time_on_ice_sh_toi' => 'sh_toi',
				// 'hockey_minutes_fixed_size_shots_on_goal_ev_toi' => 'ev_toi',
				// ###########
				
				
				
				// //Goalkeepers
				// 'total_ev_pp_sh_total' => 'total',
				// 'save_attempted_percent_saved_by_against_goals_percent_sv' =>  'percent_sv',
				// 'gk_ev_saves_gk_ev_against_shots_saved_against_even_strength_ev' => 'ev',
				// 'gk_pp_saves_gk_pp_against_shot_saves_against_power_play_pp' => 'pp',
				// 'gk_sh_saves_gk_sh_against_shot_saves_againts_short_handed_sh' => 'sh',
				// 'minutes_time_on_ice_toi' => 'toi',
				// 'gk_penalties_penalties_pen' => 'pen',
				// 'gk_goals_goals_g' => 'g',
				// 'gk_assists_assists_a' => 'a',
				// 'gk_points_last_people_match_stat_fixed_size_points_p' => 'p',
				// 'shots_on_goal_sog' => 'sog',
				// 'last_people_match_stat_fixed_size_penalties_pmi' => 'pmi',
				// 'gk_goals_last_people_match_stat_fixed_size_goals_g' => 'g',
				// 'gk_goals_last_people_match_stat_fixed_size_goals_g' => 'g',
				// // 'gk_points_points_p' => '',
				
				// //new#burakov
				// #таблица1
				// 'ab' => 'ab',
				// 'r' => 'r',
				// 'h' => 'h',
				// 'sh' => 'sh',
				// 'rbi' => 'rbi',
				// 'bb' => 'bb',
				// 'sf' => 'sf',
				// 'so' => 'so',
				// 'lob' => 'lob',
				// 'gidp' => 'gidp',
				// 'avg' => 'avg',
				
				// #таблица2
				// 'wp' => 'wp',
				// 'ip' => 'ip',
				// 'h' => 'h',
				// 'r' => 'r',
				// 'er' => 'er',
				// 'go' => 'go',
				// 'fo' => 'fo',
				// 'bb' => 'bb',
				// 'so' => 'so',
				// 'bf' => 'bf',
				// 'hr' => 'hr',
				// 'era' => 'era',
			);
			
			//print $url ."\n";

			
			#team_a_players_line
			$th_global = array ();
			$count_table = 0;
			$table = array ();
			$pattern1 = '/(<table class="table match-stat.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				//print $value1 ."\n";
				
				$value1 = replace ('""', '" "', $value1);
				$value1 = replace ('><', '> <', $value1);
				
				$count_table++;
				
				if ($count_table == 1) {
				
					//заголовки
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$sub_head_count = 0;
						
						$sub_head_1 = array ();
						$sub_head_2 = array ();
						
						$pattern3 = '/(<tr class="sub-head.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							$sub_head_count++;
							
							//print $value3 ."\n";
							
							$td = array ();
							$colspan = 1;
							
							$pattern4 = '/(<th.+?<\/th>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
							
								// print $value4 ."\n";
							
								$pattern5 = '/colspan="(\d+)"/'; 
								$work_for_content5 = new work_for_content ($value4);
								$array5 = $work_for_content5 -> get_pattern ($pattern5);
								foreach ($array5[1] as $value5) {
									$value5 = replace ('^\s+','', $value5);
									$value5 = replace ('\s+$','', $value5);
									$value5 = replace ('\s+',' ', $value5);
									$colspan = $value5;
								}
								
								if ($colspan == 0) {$colspan =1;}
								//print '$colspan = '. $colspan ."\n";
								
								while ($colspan > 0) {
									
									$pattern5 = '/(<th.+?<\/th>)/'; 
									$work_for_content5 = new work_for_content ($value4);
									$array5 = $work_for_content5 -> get_pattern ($pattern5);
									foreach ($array5[1] as $value5) {
										$value4 = strip_tags (html_entity_decode ($value4));
										
										$value5 = replace ('^\s+','', $value5);
										$value5 = replace ('\s+$','', $value5);
										$value5 = replace ('\s+',' ', $value5);
										array_push ($td, $value5);
									}
									$colspan--;
								}
							}
							
							if ($sub_head_count == 1) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_1, $td_value);
								}
							}
							
							if ($sub_head_count == 2) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_2, $td_value);
									//print $td_value ."\n";
								}
							}
						}	
						
						// print_r ($sub_head_1) ."\n";
						// print_r ($sub_head_2) ."\n";
						
						foreach ($sub_head_1 as $sub_head_1_key => $sub_head_1_value) {
							$sub_head_1 [$sub_head_1_key] = trim (strip_tags (html_entity_decode ($sub_head_1 [$sub_head_1_key])));
						}

						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
							$sub_head_2 [$sub_head_2_key] = trim (strip_tags (html_entity_decode ($sub_head_2 [$sub_head_2_key])));
						}

						$sub_head_2_count = 0;
						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
						
							$str = $sub_head_1[$sub_head_2_count].'_'.$sub_head_2[$sub_head_2_count];
							$str = strtolower ($str);
							$str = preg_replace ('/_$/ui', '', $str);
							$str = preg_replace ('/^_/ui', '', $str);
							$str = preg_replace ('/\//ui', '_', $str);
							$str = preg_replace ('/_+/ui', '_', $str);
							$str = preg_replace ('/\#/ui', 'shirtnumber', $str);
							$str = preg_replace ('/shirtnumber/ui', 'player_number', $str);
							$str = preg_replace ('/name/ui', 'player_name', $str);
							
							//принудитульно формируем $th
							$th [$str] = $str;
							
							if (isset ($th [$str])) {
								array_push ($th_global, $th [$str]);
								
							} else {
								die (print '$th [$str] not exists' ."\n".$str);
							}
							
							$sub_head_2_count++;
						}		
					}
						

					$value1 = replace ('<thead.+?<\/thead>', '', $value1);
				
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$pattern3 = '/(<tr.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
						
							if (!preg_match ('/<tr class="total-row">/', $value3)) {
						
								$td = array ();
								$pattern4 = '/(<td.+?<\/td>)/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
										
									//$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
									array_push ($td, $value4);
								}
								
								// print 'count ($td) = ' . count ($td) ."\n";
								if (count ($td) > 1) {
									array_pop ($td); //удаляю пустую строку
									array_push ($table, $td);
									//print_r ($td) ."\n";
								}
							}
						}
					}
				}
			}
			
			//print_r ($th_global) ."\n";
			
			$th_global_copy = $th_global;
			$array = array ();
			if (count ($table)> 0) {
				
				foreach ($table as $table_value1) {
				
					$array_a = array ();
					
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					//number
					$pattern1 = '/^(.+)$/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$value1 = strip_tags1 (html_entity_decode ($value1));
						$value1 = replace ('^\s+','', $value1);
						$value1 = replace ('\s+$','', $value1);
						$value1 = replace ('\s+',' ', $value1);
						$value1 = replace ('^\s+$','', $value1);
						
						if ($value1 != '') {
							$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
							array_push ($array_a, $str);
							//print $str ."\n";
						}
					}
			
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/(<a.+?<\/a>)/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
							
							$pattern3 = '/(<a.+?<\/a>)/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('\*','', $value3);
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								$value3 = trim ($value3);
								
								if ($value3 != '') {
									$str = '<'.$cth.'>'.$value3.'</'.$cth.'>';
									array_push ($array_a, $str);
									//print $str ."\n";
								}
							}
						}
					}
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/href="(.+?)"/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
						
							$pattern3 = '/id=(\d+)$/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								
								if ($value3 != '') {
									$str = '<player_id>'.$value3.'</player_id>';
									array_push ($array_a, $str);
								}
							}
						}
					}
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/href="(.+?)"/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
						
							if (!preg_match ('/^http/', $value2)) {
								$value2 = 'http://'.$host.$value2;
							}
						
							$pattern3 = '/^(.+)$/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								
								if ($value3 != '') {
									$str = '<player_url>'.$value3.'</player_url>';
									array_push ($array_a, $str);
								}
							}
						}
					}
					
					
					while (count ($table_value1) > 0) {
					
						$ctd = array_shift ($table_value1);
						$cth = array_shift ($th_global);
					
						$pattern1 = '/^(.+)$/'; 
						$work_for_content1 = new work_for_content ($ctd);
						$array1 = $work_for_content1 -> get_pattern ($pattern1);
						foreach ($array1[1] as $value1) {
						
							$value1 = strip_tags1 (html_entity_decode ($value1));
							$value1 = replace ('^\s+','', $value1);
							$value1 = replace ('\s+$','', $value1);
							$value1 = replace ('\s+',' ', $value1);
							$value1 = replace ('^\s+$','', $value1);
							
							if ($value1 != '') {
								$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
								array_push ($array_a, $str);
							}
						}
					}
					
					$th_global = $th_global_copy;
					
					$str = '<team_id>'.$team_id_a.'</team_id>';
					array_push ($array_a, $str);
					
					if (count ($array_a) > 0) {
						$str = join ('', $array_a);
						array_push ($array, $str);
						//print $str ."\n";
					}
				}
			}

			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			

			#team_a_players_line_pitching
			$th_global = array ();
			$count_table = 0;
			$table = array ();
			$pattern1 = '/(<table class="table match-stat.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				//print $value1 ."\n";
				
				$value1 = replace ('""', '" "', $value1);
				$value1 = replace ('><', '> <', $value1);
				
				$count_table++;
				
				if ($count_table == 3) {
				
					//заголовки
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$sub_head_count = 0;
						
						$sub_head_1 = array ();
						$sub_head_2 = array ();
						
						$pattern3 = '/(<tr class="sub-head.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							$sub_head_count++;
							
							//print $value3 ."\n";
							
							$td = array ();
							$colspan = 1;
							
							$pattern4 = '/(<th.+?<\/th>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
							
								$pattern5 = '/colspan="(\d+)"/'; 
								$work_for_content5 = new work_for_content ($value4);
								$array5 = $work_for_content5 -> get_pattern ($pattern5);
								foreach ($array5[1] as $value5) {
									$value5 = replace ('^\s+','', $value5);
									$value5 = replace ('\s+$','', $value5);
									$value5 = replace ('\s+',' ', $value5);
									$colspan = $value5;
									
									//print $value5 ."\n";
								}
								
								if ($colspan == 0) {$colspan =1;}
								//print '$colspan = '. $colspan ."\n";
								
								while ($colspan > 0) {
									
									$pattern5 = '/(<th.+?<\/th>)/'; 
									$work_for_content5 = new work_for_content ($value4);
									$array5 = $work_for_content5 -> get_pattern ($pattern5);
									foreach ($array5[1] as $value5) {
										// $value4 = strip_tags (html_entity_decode ($value4));
										$value5 = replace ('^\s+','', $value5);
										$value5 = replace ('\s+$','', $value5);
										$value5 = replace ('\s+',' ', $value5);
										array_push ($td, $value5);
									}
									$colspan--;
								}
							}
							
							if ($sub_head_count == 1) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_1, $td_value);
								}
							}
							
							if ($sub_head_count == 2) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_2, $td_value);
								}
							}
						}	
						
						// print_r ($sub_head_1) ."\n";
						// print_r ($sub_head_2) ."\n";
						
						foreach ($sub_head_1 as $sub_head_1_key => $sub_head_1_value) {
							$sub_head_1 [$sub_head_1_key] = trim (strip_tags (html_entity_decode ($sub_head_1 [$sub_head_1_key])));
						}

						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
							$sub_head_2 [$sub_head_2_key] = trim (strip_tags (html_entity_decode ($sub_head_2 [$sub_head_2_key])));
						}

						$sub_head_2_count = 0;
						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
						
							$str = $sub_head_1[$sub_head_2_count].'_'.$sub_head_2[$sub_head_2_count];
							$str = strtolower ($str);
							$str = preg_replace ('/_$/ui', '', $str);
							$str = preg_replace ('/^_/ui', '', $str);
							$str = preg_replace ('/\//ui', '_', $str);
							$str = preg_replace ('/_+/ui', '_', $str);
							$str = preg_replace ('/\#/ui', 'shirtnumber', $str);
							$str = preg_replace ('/shirtnumber/ui', 'player_number', $str);
							$str = preg_replace ('/name/ui', 'player_name', $str);
							
							//принудитульно формируем $th
							$th [$str] = $str;
							
							if (isset ($th [$str])) {
								array_push ($th_global, $th [$str]);
								
							} else {
								die (print '$th [$str] not exists' ."\n".$str);
							}
							
							$sub_head_2_count++;
						}		
					}
					
					$value1 = replace ('<thead.+?<\/thead>', '', $value1);
				
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$pattern3 = '/(<tr.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
						
							if (!preg_match ('/<tr class="total-row">/', $value3)) {
						
								$td = array ();
								$pattern4 = '/(<td.+?<\/td>)/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
										
									//$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
									array_push ($td, $value4);
								}
								
								// print 'count ($td) = ' . count ($td) ."\n";
								if (count ($td) > 1) {
									array_pop ($td); //удаляю пустую строку
									array_push ($table, $td);
									//print_r ($td) ."\n";
								}
							}
						}
					}
				}
			}
			
			//print_r ($th_global) ."\n";
			
			$th_global_copy = $th_global;
			$array = array ();
			if (count ($table)> 0) {
				
				foreach ($table as $table_value1) {
				
					// print $url ."\n";
					//print_r ($table_value1) ."\n";
					
					$array_a = array ();
					
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					//number
					$pattern1 = '/^(.+)$/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$value1 = strip_tags1 (html_entity_decode ($value1));
						$value1 = replace ('^\s+','', $value1);
						$value1 = replace ('\s+$','', $value1);
						$value1 = replace ('\s+',' ', $value1);
						$value1 = replace ('^\s+$','', $value1);
						
						if ($value1 != '') {
							$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
							array_push ($array_a, $str);
							//print $str ."\n";
						}
					}
			
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/(<a.+?<\/a>)/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
							
							$pattern3 = '/(<a.+?<\/a>)/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('\*','', $value3);
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								$value3 = trim ($value3);
								
								if ($value3 != '') {
									$str = '<'.$cth.'>'.$value3.'</'.$cth.'>';
									array_push ($array_a, $str);
									//print $str ."\n";
								}
							}
						}
					}
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/href="(.+?)"/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
						
							$pattern3 = '/id=(\d+)$/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								
								if ($value3 != '') {
									$str = '<player_id>'.$value3.'</player_id>';
									array_push ($array_a, $str);
								}
							}
						}
					}
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/href="(.+?)"/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
						
							if (!preg_match ('/^http/', $value2)) {
								$value2 = 'http://'.$host.$value2;
							}
						
							$pattern3 = '/^(.+)$/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								
								if ($value3 != '') {
									$str = '<player_url>'.$value3.'</player_url>';
									array_push ($array_a, $str);
								}
							}
						}
					}
					
					
					while (count ($table_value1) > 0) {
					
						$ctd = array_shift ($table_value1);
						$cth = array_shift ($th_global);
					
						$pattern1 = '/^(.+)$/'; 
						$work_for_content1 = new work_for_content ($ctd);
						$array1 = $work_for_content1 -> get_pattern ($pattern1);
						foreach ($array1[1] as $value1) {
						
							$value1 = strip_tags1 (html_entity_decode ($value1));
							$value1 = replace ('^\s+','', $value1);
							$value1 = replace ('\s+$','', $value1);
							$value1 = replace ('\s+',' ', $value1);
							$value1 = replace ('^\s+$','', $value1);
							
							if ($value1 != '') {
								$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
								array_push ($array_a, $str);
							}
						}
					}
					
					$th_global = $th_global_copy;
					
					$str = '<team_id>'.$team_id_a.'</team_id>';
					array_push ($array_a, $str);
					
					if (count ($array_a) > 0) {
						$str = join ('', $array_a);
						array_push ($array, $str);
						//print $str ."\n";
					}
				}
			}

			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}

			
			
			#team_b_players_line
			$th_global = array ();
			$count_table = 0;
			$table = array ();
			$pattern1 = '/(<table class="table match-stat.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				//print $value1 ."\n";
				
				$value1 = replace ('""', '" "', $value1);
				$value1 = replace ('><', '> <', $value1);
				
				$count_table++;
				
				if ($count_table == 2) {
				
					//заголовки
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$sub_head_count = 0;
						
						$sub_head_1 = array ();
						$sub_head_2 = array ();
						
						$pattern3 = '/(<tr class="sub-head.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							$sub_head_count++;
							
							$td = array ();
							$colspan = 1;
							
							$pattern4 = '/(<th.+?<\/th>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
							
								$pattern5 = '/colspan="(\d+)"/'; 
								$work_for_content5 = new work_for_content ($value4);
								$array5 = $work_for_content5 -> get_pattern ($pattern5);
								foreach ($array5[1] as $value5) {
									$value5 = replace ('^\s+','', $value5);
									$value5 = replace ('\s+$','', $value5);
									$value5 = replace ('\s+',' ', $value5);
									$colspan = $value5;
								}
								
								if ($colspan == 0) {$colspan =1;}
								//print '$colspan = '. $colspan ."\n";
								
								while ($colspan > 0) {
									
									$pattern5 = '/(<th.+?<\/th>)/'; 
									$work_for_content5 = new work_for_content ($value4);
									$array5 = $work_for_content5 -> get_pattern ($pattern5);
									foreach ($array5[1] as $value5) {
										// $value4 = strip_tags (html_entity_decode ($value4));
										$value5 = replace ('^\s+','', $value5);
										$value5 = replace ('\s+$','', $value5);
										$value5 = replace ('\s+',' ', $value5);
										array_push ($td, $value5);
									}
									$colspan--;
								}
							}
							
							if ($sub_head_count == 1) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_1, $td_value);
								}
							}
							
							if ($sub_head_count == 2) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_2, $td_value);
								}
							}
						}	
						
						foreach ($sub_head_1 as $sub_head_1_key => $sub_head_1_value) {
							$sub_head_1 [$sub_head_1_key] = trim (strip_tags (html_entity_decode ($sub_head_1 [$sub_head_1_key])));
						}

						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
							$sub_head_2 [$sub_head_2_key] = trim (strip_tags (html_entity_decode ($sub_head_2 [$sub_head_2_key])));
						}

						$sub_head_2_count = 0;
						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
						
							$str = $sub_head_1[$sub_head_2_count].'_'.$sub_head_2[$sub_head_2_count];
							$str = strtolower ($str);
							$str = preg_replace ('/_$/ui', '', $str);
							$str = preg_replace ('/^_/ui', '', $str);
							$str = preg_replace ('/\//ui', '_', $str);
							$str = preg_replace ('/_+/ui', '_', $str);
							$str = preg_replace ('/\#/ui', 'shirtnumber', $str);
							$str = preg_replace ('/shirtnumber/ui', 'player_number', $str);
							$str = preg_replace ('/name/ui', 'player_name', $str);
							
							//принудитульно формируем $th
							$th [$str] = $str;
							
							if (isset ($th [$str])) {
								array_push ($th_global, $th [$str]);
								
							} else {
								die (print '$th [$str] not exists' ."\n".$str);
							}
							
							$sub_head_2_count++;
						}		
					}
					
					$value1 = replace ('<thead.+?<\/thead>', '', $value1);
				
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$pattern3 = '/(<tr.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
						
							if (!preg_match ('/<tr class="total-row">/', $value3)) {
						
								$td = array ();
								$pattern4 = '/(<td.+?<\/td>)/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
										
									//$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
									array_push ($td, $value4);
								}
								
								// print 'count ($td) = ' . count ($td) ."\n";
								if (count ($td) > 1) {
									array_pop ($td); //удаляю пустую строку
									array_push ($table, $td);
									//print_r ($td) ."\n";
								}
							}
						}
					}
				}
			}
			
			// print_r ($th_global) ."\n";
			
			$th_global_copy = $th_global;
			$array = array ();
			if (count ($table)> 0) {
				
				foreach ($table as $table_value1) {
				
					// print $url ."\n";
					//print_r ($table_value1) ."\n";
					
					$array_a = array ();
					
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					//number
					$pattern1 = '/^(.+)$/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$value1 = strip_tags1 (html_entity_decode ($value1));
						$value1 = replace ('^\s+','', $value1);
						$value1 = replace ('\s+$','', $value1);
						$value1 = replace ('\s+',' ', $value1);
						$value1 = replace ('^\s+$','', $value1);
						
						if ($value1 != '') {
							$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
							array_push ($array_a, $str);
							//print $str ."\n";
						}
					}
			
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/(<a.+?<\/a>)/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
							
							$pattern3 = '/(<a.+?<\/a>)/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('\*','', $value3);
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								$value3 = trim ($value3);
								
								if ($value3 != '') {
									$str = '<'.$cth.'>'.$value3.'</'.$cth.'>';
									array_push ($array_a, $str);
									//print $str ."\n";
								}
							}
						}
					}
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/href="(.+?)"/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
						
							$pattern3 = '/id=(\d+)$/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								
								if ($value3 != '') {
									$str = '<player_id>'.$value3.'</player_id>';
									array_push ($array_a, $str);
								}
							}
						}
					}
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/href="(.+?)"/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
						
							if (!preg_match ('/^http/', $value2)) {
								$value2 = 'http://'.$host.$value2;
							}
						
							$pattern3 = '/^(.+)$/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								
								if ($value3 != '') {
									$str = '<player_url>'.$value3.'</player_url>';
									array_push ($array_a, $str);
								}
							}
						}
					}
					
					while (count ($table_value1) > 0) {
					
						$ctd = array_shift ($table_value1);
						$cth = array_shift ($th_global);
					
						$pattern1 = '/^(.+)$/'; 
						$work_for_content1 = new work_for_content ($ctd);
						$array1 = $work_for_content1 -> get_pattern ($pattern1);
						foreach ($array1[1] as $value1) {
						
							$value1 = strip_tags1 (html_entity_decode ($value1));
							$value1 = replace ('^\s+','', $value1);
							$value1 = replace ('\s+$','', $value1);
							$value1 = replace ('\s+',' ', $value1);
							$value1 = replace ('^\s+$','', $value1);
							
							if ($value1 != '') {
								$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
								array_push ($array_a, $str);
							}
						}
					}
					
					$th_global = $th_global_copy;
					
					$str = '<team_id>'.$team_id_b.'</team_id>';
					array_push ($array_a, $str);
					
					if (count ($array_a) > 0) {
						$str = join ('', $array_a);
						array_push ($array, $str);
						//print $str ."\n";
					}
				}
			}

			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			

			#team_b_players_line_pitching
			$th_global = array ();
			$count_table = 0;
			$table = array ();
			$pattern1 = '/(<table class="table match-stat.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				//print $value1 ."\n";
				
				$value1 = replace ('""', '" "', $value1);
				$value1 = replace ('><', '> <', $value1);
				
				$count_table++;
				
				if ($count_table == 4) {
				
					//заголовки
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$sub_head_count = 0;
						
						$sub_head_1 = array ();
						$sub_head_2 = array ();
						
						$pattern3 = '/(<tr class="sub-head.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							$sub_head_count++;
							
							//print $value3 ."\n";
							
							$td = array ();
							$colspan = 1;
							
							$pattern4 = '/(<th.+?<\/th>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
							
								$pattern5 = '/colspan="(\d+)"/'; 
								$work_for_content5 = new work_for_content ($value4);
								$array5 = $work_for_content5 -> get_pattern ($pattern5);
								foreach ($array5[1] as $value5) {
									$value5 = replace ('^\s+','', $value5);
									$value5 = replace ('\s+$','', $value5);
									$value5 = replace ('\s+',' ', $value5);
									$colspan = $value5;
									
									//print $value5 ."\n";
								}
								
								if ($colspan == 0) {$colspan =1;}
								//print '$colspan = '. $colspan ."\n";
								
								while ($colspan > 0) {
									
									$pattern5 = '/(<th.+?<\/th>)/'; 
									$work_for_content5 = new work_for_content ($value4);
									$array5 = $work_for_content5 -> get_pattern ($pattern5);
									foreach ($array5[1] as $value5) {
										// $value4 = strip_tags (html_entity_decode ($value4));
										$value5 = replace ('^\s+','', $value5);
										$value5 = replace ('\s+$','', $value5);
										$value5 = replace ('\s+',' ', $value5);
										array_push ($td, $value5);
									}
									$colspan--;
								}
							}
							
							if ($sub_head_count == 1) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_1, $td_value);
								}
							}
							
							if ($sub_head_count == 2) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_2, $td_value);
								}
							}
						}	
						
						foreach ($sub_head_1 as $sub_head_1_key => $sub_head_1_value) {
							$sub_head_1 [$sub_head_1_key] = trim (strip_tags (html_entity_decode ($sub_head_1 [$sub_head_1_key])));
						}

						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
							$sub_head_2 [$sub_head_2_key] = trim (strip_tags (html_entity_decode ($sub_head_2 [$sub_head_2_key])));
						}

						$sub_head_2_count = 0;
						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
						
							$str = $sub_head_1[$sub_head_2_count].'_'.$sub_head_2[$sub_head_2_count];
							$str = strtolower ($str);
							$str = preg_replace ('/_$/ui', '', $str);
							$str = preg_replace ('/^_/ui', '', $str);
							$str = preg_replace ('/\//ui', '_', $str);
							$str = preg_replace ('/_+/ui', '_', $str);
							$str = preg_replace ('/\#/ui', 'shirtnumber', $str);
							$str = preg_replace ('/shirtnumber/ui', 'player_number', $str);
							$str = preg_replace ('/name/ui', 'player_name', $str);
							
							//принудитульно формируем $th
							$th [$str] = $str;
							
							if (isset ($th [$str])) {
								array_push ($th_global, $th [$str]);
								
							} else {
								die (print '$th [$str] not exists' ."\n".$str);
							}
							
							$sub_head_2_count++;
						}		
					}

					
					$value1 = replace ('<thead.+?<\/thead>', '', $value1);
				
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$pattern3 = '/(<tr.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
						
							if (!preg_match ('/<tr class="total-row">/', $value3)) {
						
								$td = array ();
								$pattern4 = '/(<td.+?<\/td>)/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
										
									//$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
									array_push ($td, $value4);
								}
								
								// print 'count ($td) = ' . count ($td) ."\n";
								if (count ($td) > 1) {
									array_pop ($td); //удаляю пустую строку
									array_push ($table, $td);
									//print_r ($td) ."\n";
								}
							}
						}
					}
				}
			}
			
			//print_r ($th_global) ."\n";
			
			$th_global_copy = $th_global;
			$array = array ();
			if (count ($table)> 0) {
				
				foreach ($table as $table_value1) {
				
					// print $url ."\n";
					//print_r ($table_value1) ."\n";
					
					$array_a = array ();
					
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					//number
					$pattern1 = '/^(.+)$/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$value1 = strip_tags1 (html_entity_decode ($value1));
						$value1 = replace ('^\s+','', $value1);
						$value1 = replace ('\s+$','', $value1);
						$value1 = replace ('\s+',' ', $value1);
						$value1 = replace ('^\s+$','', $value1);
						
						if ($value1 != '') {
							$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
							array_push ($array_a, $str);
							//print $str ."\n";
						}
					}
			
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/(<a.+?<\/a>)/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
							
							$pattern3 = '/(<a.+?<\/a>)/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('\*','', $value3);
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								$value3 = trim ($value3);
								
								if ($value3 != '') {
									$str = '<'.$cth.'>'.$value3.'</'.$cth.'>';
									array_push ($array_a, $str);
									//print $str ."\n";
								}
							}
						}
					}
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/href="(.+?)"/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
						
							$pattern3 = '/id=(\d+)$/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								
								if ($value3 != '') {
									$str = '<player_id>'.$value3.'</player_id>';
									array_push ($array_a, $str);
								}
							}
						}
					}
					
					$pattern1 = '/(<a.+?<\/a>)/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$pattern2 = '/href="(.+?)"/'; 
						$work_for_content2 = new work_for_content ($value1);
						$array2 = $work_for_content2 -> get_pattern ($pattern2);
						foreach ($array2[1] as $value2) {
						
							if (!preg_match ('/^http/', $value2)) {
								$value2 = 'http://'.$host.$value2;
							}
						
							$pattern3 = '/^(.+)$/'; 
							$work_for_content3 = new work_for_content ($value2);
							$array3 = $work_for_content3 -> get_pattern ($pattern3);
							foreach ($array3[1] as $value3) {
								$value3 = strip_tags1 (html_entity_decode ($value3));
								$value3 = replace ('^\s+','', $value3);
								$value3 = replace ('\s+$','', $value3);
								$value3 = replace ('\s+',' ', $value3);
								$value3 = replace ('^\s+$','', $value3);
								
								if ($value3 != '') {
									$str = '<player_url>'.$value3.'</player_url>';
									array_push ($array_a, $str);
								}
							}
						}
					}
					
					
					while (count ($table_value1) > 0) {
					
						$ctd = array_shift ($table_value1);
						$cth = array_shift ($th_global);
					
						$pattern1 = '/^(.+)$/'; 
						$work_for_content1 = new work_for_content ($ctd);
						$array1 = $work_for_content1 -> get_pattern ($pattern1);
						foreach ($array1[1] as $value1) {
						
							$value1 = strip_tags1 (html_entity_decode ($value1));
							$value1 = replace ('^\s+','', $value1);
							$value1 = replace ('\s+$','', $value1);
							$value1 = replace ('\s+',' ', $value1);
							$value1 = replace ('^\s+$','', $value1);
							
							if ($value1 != '') {
								$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
								array_push ($array_a, $str);
							}
						}
					}
					
					$th_global = $th_global_copy;
					
					$str = '<team_id>'.$team_id_b.'</team_id>';
					array_push ($array_a, $str);
					
					if (count ($array_a) > 0) {
						$str = join ('', $array_a);
						array_push ($array, $str);
						//print $str ."\n";
					}
				}
			}

			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}



			///////////////////////////////////

			
			//coach_team_a
			$array = array ();
			$pattern1 = '/(<div class="block\.match_coach_team_a.+?<\/a>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<a.+?<\/a>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
					$pattern3 = '/(<a.+?<\/a>)/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						$str = '<coach_name>'.$value3.'</coach_name>';
						array_push ($array, $str);
					}
				}					
				
				$pattern2 = '/(<a.+?<\/a>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
					
					$pattern3 = '/id=(\d+)"/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						$str = '<coach_id>'.$value3.'</coach_id>';
						array_push ($array, $str);
					}
				}
				$str = '<team_id>'.$team_id_a.'</team_id>';
				array_push ($array, $str);
			}
					
			if (count ($array) > 0) {
				$str = join ('', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			//coach_team_b
			$array = array ();
			$pattern1 = '/(<div class="block\.match_coach_team_a.+?<\/a>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<a.+?<\/a>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
					$pattern3 = '/(<a.+?<\/a>)/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						$str = '<coach_name>'.$value3.'</coach_name>';
						array_push ($array, $str);
					}
				}					
				
				$pattern2 = '/(<a.+?<\/a>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
					
					$pattern3 = '/id=(\d+)"/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						$str = '<coach_id>'.$value3.'</coach_id>';
						array_push ($array, $str);
					}
				}
				$str = '<team_id>'.$team_id_b.'</team_id>';
				array_push ($array, $str);
			}
					
			if (count ($array) > 0) {
				$str = join ('', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			//referee
			$dt = '';
			$array = array ();
			$pattern1 = '/(<div class="referee.+?<\/div>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<div.+?<\/div>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
					$array1 = array();
					
					$pattern3 = '/(<dd.+?<\/dd>)/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						$value3 = replace ('^\s+$','', $value3);
						
						if 	($value3 != '') {$dt = $value3;}
						
						if 	($dt != '') {
							$str = '<referee_type>'.$dt.'</referee_type>';
							array_push ($array1, $str);
						}
					}
				
					$pattern3 = '/(<a.+?<\/a>)/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						$str = '<referee_name>'.$value3.'</referee_name>';
						array_push ($array1, $str);
					}
					
					$pattern3 = '/id=(\d+)"/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						$str = '<referee_id>'.$value3.'</referee_id>';
						array_push ($array1, $str);
					}
					
					if (count ($array1) > 0) {
						$str = join ('', $array1);
						array_push ($array, $str);
					}
				}
			}
					
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}

			
			//счет по четвертям
			$array = array ();
			$pattern1 = '/(<table class="box_score-board-table">.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$count_tr = 0;
				$pattern2 = '/(<tr.+?<\/tr>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
					$count_tr++;	
					$tr = $value2;
					$array1 = array();
					
					$pattern3 = '/(<a.+?<\/a>)/'; 
					$work_for_content3 = new work_for_content ($tr);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
					
						$pattern4 = '/(<a.+?<\/a>)/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							$str = '<team_name>'.$value4.'</team_name>';
							array_push ($array1, $str);
						}
						
						$pattern4 = '/id=(\d+)"/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							$str = '<team_id>'.$value4.'</team_id>';
							array_push ($array1, $str);
						}
					}
					
					$td = array ();
					$pattern3 = '/(<td class=" scores.+?<\/td>)/'; 
					$work_for_content3 = new work_for_content ($tr);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
					
						// $value4 = strip_tags (html_entity_decode ($value4));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						//array_push ($td, $value3);
						
						$label = '';
						$value = '';
						
						$pattern4 = '/class="(.+?)"/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							$label = $value4;
						}
						
						$pattern4 = '/^(.+)$/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							$value = $value4;
						}
						
						if ($label != '' and $value != '') {
							$str = '<'.$label.'>'.$value.'</'.$label.'>';
							array_push ($array1, $str);
						}
					}
					
					if (count ($array1) > 0) {
						$str = join ('', $array1);
						array_push ($array, $str);
					}
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
				
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			//competition
			$array = array ();					
			$pattern1 = '/(<li class="leaf expanded.+?<\/li>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<a class="item-link selected".+?<\/a>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
					
					$array_a = array ();
					$pattern3 = '/competition&id=(\d+)"/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
				
						$value3 = strip_tags (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						
						$str = '<competition_id>'.$value3.'</competition_id>';
						array_push ($array_a, $str);
					}	
					
					$pattern3 = '/^(.+)$/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
				
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						
						$str = '<competition_name>'.$value3.'</competition_name>';
						array_push ($array_a, $str);
					}	
					
					
					if (count ($array_a) > 0) {
						$str = join ('', $array_a);
						array_push ($array, $str);
					}
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			//season
			$array = array ();					
			$pattern1 = '/(<div class="details.+?<\/div>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<dt>Date<\/dt>.+?<\/dd>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
					$pattern3 = '/<span class=\'timestamp\' data-value=\'(\d+)\'/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
				
						$value3 = strip_tags (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
					
						//$value3 = strtotime ($value3);
						// $value3 = $value2 + 3600*8;
						
						$date = getdate ($value3);
						$date_a = array ();
						array_push ($date_a, $date['year']);
						array_push ($date_a, $date['mon']);
						array_push ($date_a, $date['mday']);
						
						foreach ($date_a as $date_a_key => $date_a_value) {
							if (strlen ($date_a_value) < 2) {
								$date_a [$date_a_key] = '0'.$date_a [$date_a_key];
							}
						}
						
						//print_r ($date_a) ."\n";
						$date = join ('-', $date_a);
						//array_push ($array, $date);
						//array_push ($array, $date_a['0']);
						
						
						$array_a = array ();
						
						$str = '<season_id>'.$date_a['0'].'</season_id>';
						array_push ($array_a, $str);
						
						$str = '<season_name>'.$date_a['0'].'</season_name>';
						array_push ($array_a, $str);
						
						if (count ($array_a) > 0) {
							$str = join ('', $array_a);
							array_push ($array, $str);
						}
					}
				}
			}
			
			$array = array (); //отключили сезон.
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			//round
			$array = array ();					
			$pattern1 = '/<dt>Competition<\/dt>(.+?<\/dd>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<a.+?<\/a>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
					
					$array_a = array ();
					$pattern3 = '/round&id=(\d+)"/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
				
						$value3 = strip_tags (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						
						$str = '<round_id>'.$value3.'</round_id>';
						array_push ($array_a, $str);
					}	
					
					$pattern3 = '/^(.+)$/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
				
						$value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						
						$str = '<round_name>'.$value3.'</round_name>';
						array_push ($array_a, $str);
					}	
					
					
					if (count ($array_a) > 0) {
						$str = join ('', $array_a);
						array_push ($array, $str);
					}
				}
			}
			
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($array[0]); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			//scores_teama
			$array = array ();
			$pattern1 = '/(<div class="block.match_scorers.+?<table class="matches events">.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<tr.+?<\/tr>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
					$td = array ();
					$pattern3 = '/(<td class="player player-a".+?<\/td>)/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						// $value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						$value3 = replace ('^\s+$','', $value3);
						
						$array_a = array();
						
						$pattern4 = '/(<div>.+?<\/a>)/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							//$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							
							$pattern5 = '/(<a.+?<\/a>)/'; 
							$work_for_content5 = new work_for_content ($value4);
							$array5 = $work_for_content5 -> get_pattern ($pattern5);
							foreach ($array5[1] as $value5) {
								$value5 = strip_tags1 (html_entity_decode ($value5));
								$value5 = replace ('^\s+','', $value5);
								$value5 = replace ('\s+$','', $value5);
								$value5 = replace ('\s+',' ', $value5);
								
								$str = '<team_id>'.$team_id_a.'</team_id>';
								array_push ($array_a, $str);

								$str = '<player_name>'.$value5.'</player_name>';
								array_push ($array_a, $str);
							}	
							
							$pattern5 = '/href="(.+?)"/'; 
							$work_for_content5 = new work_for_content ($value4);
							$array5 = $work_for_content5 -> get_pattern ($pattern5);
							foreach ($array5[1] as $value5) {
								$value5 = strip_tags1 (html_entity_decode ($value5));
								$value5 = replace ('^\s+','', $value5);
								$value5 = replace ('\s+$','', $value5);
								$value5 = replace ('\s+',' ', $value5);
								if (!preg_match ('/^http/', $value5)) {
									$value5 = 'http://'.$host.$value5;
								}
								$str = '<player_url>'.$value5.'</player_url>';
								array_push ($array_a, $str);
							}	
							
							$pattern5 = '/id=(\d+)"/'; 
							$work_for_content5 = new work_for_content ($value4);
							$array5 = $work_for_content5 -> get_pattern ($pattern5);
							foreach ($array5[1] as $value5) {
								$value5 = strip_tags1 (html_entity_decode ($value5));
								$value5 = replace ('^\s+','', $value5);
								$value5 = replace ('\s+$','', $value5);
								$value5 = replace ('\s+',' ', $value5);
								$str = '<player_id>'.$value5.'</player_id>';
								array_push ($array_a, $str);
							}	
						}
						
						$pattern4 = '/(<span class="additional-info">.+?<\/span>)/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							$str = '<additional_info>'.$value4.'</additional_info>';
							array_push ($array_a, $str);
						}
						
						$pattern4 = '/(<span class="extra">.+?<\/span>)/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('\(+','', $value4);
							$value4 = replace ('\)+','', $value4);
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							$str = '<extra>'.$value4.'</extra>';
							array_push ($array_a, $str);
						}
						
						
						$pattern4 = '/(<span class="minute">.+?<\/span>)/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('\(+','', $value4);
							$value4 = replace ('\)+','', $value4);
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							$str = '<minute>'.$value4.'</minute>';
							array_push ($array_a, $str);
						}
						
						
						//assist
						$pattern4 = '/(<span class="assists">.+?<\/span>)/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							//$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							
							$a_count = 0;
							$pattern5 = '/(<a.+?<\/a>)/'; 
							$work_for_content5 = new work_for_content ($value4);
							$array5 = $work_for_content5 -> get_pattern ($pattern5);
							foreach ($array5[1] as $value5) {
								//$value5 = strip_tags1 (html_entity_decode ($value5));
								$value5 = replace ('^\s+','', $value5);
								$value5 = replace ('\s+$','', $value5);
								$value5 = replace ('\s+',' ', $value5);
								$a_count++;
								
								$pattern6 = '/(<a.+?<\/a>)/'; 
								$work_for_content6 = new work_for_content ($value5);
								$array6 = $work_for_content6 -> get_pattern ($pattern6);
								foreach ($array6[1] as $value6) {
									//$value6 = strip_tags1 (html_entity_decode ($value6));
									$value6 = replace ('^\s+','', $value6);
									$value6 = replace ('\s+$','', $value6);
									$value6 = replace ('\s+',' ', $value6);
								
									$str = '<assist>'.$value6.'</assist>';
									array_push ($array_a, $str);
								}
							}	
						}
						
						
						if (count ($array_a) > 0) {
							$str = join ('', $array_a);
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
				
			//scores_teamb
			$array = array ();
			$pattern1 = '/(<div class="block.match_scorers.+?<table class="matches events">.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/(<tr.+?<\/tr>)/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
				
					$td = array ();
					$pattern3 = '/(<td class="player player-b".+?<\/td>)/'; 
					$work_for_content3 = new work_for_content ($value2);
					$array3 = $work_for_content3 -> get_pattern ($pattern3);
					foreach ($array3[1] as $value3) {
						// $value3 = strip_tags1 (html_entity_decode ($value3));
						$value3 = replace ('^\s+','', $value3);
						$value3 = replace ('\s+$','', $value3);
						$value3 = replace ('\s+',' ', $value3);
						$value3 = replace ('^\s+$','', $value3);
						
						$array_a = array();
						
						$pattern4 = '/(<div>.+?<\/a>)/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							//$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							
							$pattern5 = '/(<a.+?<\/a>)/'; 
							$work_for_content5 = new work_for_content ($value4);
							$array5 = $work_for_content5 -> get_pattern ($pattern5);
							foreach ($array5[1] as $value5) {
								$value5 = strip_tags1 (html_entity_decode ($value5));
								$value5 = replace ('^\s+','', $value5);
								$value5 = replace ('\s+$','', $value5);
								$value5 = replace ('\s+',' ', $value5);
								
								$str = '<team_id>'.$team_id_b.'</team_id>';
								array_push ($array_a, $str);

								$str = '<player_name>'.$value5.'</player_name>';
								array_push ($array_a, $str);
							}	
							
							$pattern5 = '/href="(.+?)"/'; 
							$work_for_content5 = new work_for_content ($value4);
							$array5 = $work_for_content5 -> get_pattern ($pattern5);
							foreach ($array5[1] as $value5) {
								$value5 = strip_tags1 (html_entity_decode ($value5));
								$value5 = replace ('^\s+','', $value5);
								$value5 = replace ('\s+$','', $value5);
								$value5 = replace ('\s+',' ', $value5);
								if (!preg_match ('/^http/', $value5)) {
									$value5 = 'http://'.$host.$value5;
								}
								$str = '<player_url>'.$value5.'</player_url>';
								array_push ($array_a, $str);
							}	
							
							$pattern5 = '/id=(\d+)"/'; 
							$work_for_content5 = new work_for_content ($value4);
							$array5 = $work_for_content5 -> get_pattern ($pattern5);
							foreach ($array5[1] as $value5) {
								$value5 = strip_tags1 (html_entity_decode ($value5));
								$value5 = replace ('^\s+','', $value5);
								$value5 = replace ('\s+$','', $value5);
								$value5 = replace ('\s+',' ', $value5);
								$str = '<player_id>'.$value5.'</player_id>';
								array_push ($array_a, $str);
							}	
						}
						
						$pattern4 = '/(<span class="additional-info">.+?<\/span>)/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							$str = '<additional_info>'.$value4.'</additional_info>';
							array_push ($array_a, $str);
						}
						
						$pattern4 = '/(<span class="extra">.+?<\/span>)/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('\(+','', $value4);
							$value4 = replace ('\)+','', $value4);
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							$str = '<extra>'.$value4.'</extra>';
							array_push ($array_a, $str);
						}
						
						
						$pattern4 = '/(<span class="minute">.+?<\/span>)/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('\(+','', $value4);
							$value4 = replace ('\)+','', $value4);
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							$str = '<minute>'.$value4.'</minute>';
							array_push ($array_a, $str);
						}
						
						
						//assist
						$pattern4 = '/(<span class="assists">.+?<\/span>)/'; 
						$work_for_content4 = new work_for_content ($value3);
						$array4 = $work_for_content4 -> get_pattern ($pattern4);
						foreach ($array4[1] as $value4) {
							//$value4 = strip_tags1 (html_entity_decode ($value4));
							$value4 = replace ('^\s+','', $value4);
							$value4 = replace ('\s+$','', $value4);
							$value4 = replace ('\s+',' ', $value4);
							
							$a_count = 0;
							$pattern5 = '/(<a.+?<\/a>)/'; 
							$work_for_content5 = new work_for_content ($value4);
							$array5 = $work_for_content5 -> get_pattern ($pattern5);
							foreach ($array5[1] as $value5) {
								//$value5 = strip_tags1 (html_entity_decode ($value5));
								$value5 = replace ('^\s+','', $value5);
								$value5 = replace ('\s+$','', $value5);
								$value5 = replace ('\s+',' ', $value5);
								$a_count++;
								
								$pattern6 = '/(<a.+?<\/a>)/'; 
								$work_for_content6 = new work_for_content ($value5);
								$array6 = $work_for_content6 -> get_pattern ($pattern6);
								foreach ($array6[1] as $value6) {
									//$value6 = strip_tags1 (html_entity_decode ($value6));
									$value6 = replace ('^\s+','', $value6);
									$value6 = replace ('\s+$','', $value6);
									$value6 = replace ('\s+',' ', $value6);
								
									$str = '<assist>'.$value6.'</assist>';
									array_push ($array_a, $str);
								}
							}	
						}
						
						if (count ($array_a) > 0) {
							$str = join ('', $array_a);
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
			
			
			//penalties_team_a
			$array = array ();
			// $pattern1 = '/(<div class="block.match_penalties.+?<table class="matches events">.+?<\/table>)/'; 
			// $work_for_content1 = new work_for_content ($content1);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				
				// $pattern2 = '/(<tr.+?<\/tr>)/'; 
				// $work_for_content2 = new work_for_content ($value1);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
				
					// $tr = $value2;
				
					// $td = array ();
					// $pattern3 = '/(<td class="player player-a".+?<\/td>)/'; 
					// $work_for_content3 = new work_for_content ($value2);
					// $array3 = $work_for_content3 -> get_pattern ($pattern3);
					// foreach ($array3[1] as $value3) {
						// // $value3 = strip_tags1 (html_entity_decode ($value3));
						// $value3 = replace ('^\s+','', $value3);
						// $value3 = replace ('\s+$','', $value3);
						// $value3 = replace ('\s+',' ', $value3);
						// $value3 = replace ('^\s+$','', $value3);
						
						// $value33 = $value3;
						// $value33 = strip_tags1 (html_entity_decode ($value33));
						// $value33 = replace ('^\s+','', $value33);
						// $value33 = replace ('\s+$','', $value33);
						// $value33 = replace ('\s+',' ', $value33);
						// $value33 = replace ('^\s+$','', $value33);
						
						
						// if ($value33 != '') {
						
							// $array_a = array();
							// $str = '<team_id>'.$team_id_a.'</team_id>';
							// array_push ($array_a, $str);
							
							// $pattern4 = '/(<div>.+?<\/a>)/'; 
							// $work_for_content4 = new work_for_content ($value3);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// //$value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+$','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								
								// $pattern5 = '/(<a.+?<\/a>)/'; 
								// $work_for_content5 = new work_for_content ($value4);
								// $array5 = $work_for_content5 -> get_pattern ($pattern5);
								// foreach ($array5[1] as $value5) {
									// $value5 = strip_tags1 (html_entity_decode ($value5));
									// $value5 = replace ('^\s+','', $value5);
									// $value5 = replace ('\s+$','', $value5);
									// $value5 = replace ('\s+',' ', $value5);
									
									// $str = '<player_name>'.$value5.'</player_name>';
									// array_push ($array_a, $str);
								// }	
								
								// $pattern5 = '/href="(.+?)"/'; 
								// $work_for_content5 = new work_for_content ($value4);
								// $array5 = $work_for_content5 -> get_pattern ($pattern5);
								// foreach ($array5[1] as $value5) {
									// $value5 = strip_tags1 (html_entity_decode ($value5));
									// $value5 = replace ('^\s+','', $value5);
									// $value5 = replace ('\s+$','', $value5);
									// $value5 = replace ('\s+',' ', $value5);
									// if (!preg_match ('/^http/', $value5)) {
										// $value5 = 'http://'.$host.$value5;
									// }
									// $str = '<player_url>'.$value5.'</player_url>';
									// array_push ($array_a, $str);
								// }	
								
								// $pattern5 = '/id=(\d+)"/'; 
								// $work_for_content5 = new work_for_content ($value4);
								// $array5 = $work_for_content5 -> get_pattern ($pattern5);
								// foreach ($array5[1] as $value5) {
									// $value5 = strip_tags1 (html_entity_decode ($value5));
									// $value5 = replace ('^\s+','', $value5);
									// $value5 = replace ('\s+$','', $value5);
									// $value5 = replace ('\s+',' ', $value5);
									// $str = '<player_id>'.$value5.'</player_id>';
									// array_push ($array_a, $str);
								// }	
							// }
							
							// $pattern4 = '/(<span class="additional-info">.+?<\/span>)/'; 
							// $work_for_content4 = new work_for_content ($value3);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// $value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+$','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								// if ($value4 != '') {							
									// $str = '<additional_info>'.$value4.'</additional_info>';
									// array_push ($array_a, $str);
								// }
							// }
							
							// $pattern4 = '/(<span class="extra">.+?<\/span>)/'; 
							// $work_for_content4 = new work_for_content ($value3);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// $value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('\(+','', $value4);
								// $value4 = replace ('\)+','', $value4);
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								// $value4 = replace ('\s+$','', $value4);
								
								// if ($value4 != '') {
									// $str = '<extra>'.$value4.'</extra>';
									// array_push ($array_a, $str);
								// }
							// }
							
							// $pattern4 = '/(<span class="event-type-name">.+?<\/span>)/'; 
							// $work_for_content4 = new work_for_content ($value3);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// $value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('\(+','', $value4);
								// $value4 = replace ('\)+','', $value4);
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								// $value4 = replace ('\s+$','', $value4);
								
								// if ($value4 != '') {
									// $str = '<event_type_name>'.$value4.'</event_type_name>';
									// array_push ($array_a, $str);
								// }
							// }
							
							// $pattern4 = '/(<span class="minute">.+?<\/span>)/'; 
							// $work_for_content4 = new work_for_content ($value3);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// $value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('\(+','', $value4);
								// $value4 = replace ('\)+','', $value4);
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								// $value4 = replace ('\s+$','', $value4);
								
								// if ($value4 != '') {
									// $str = '<minute>'.$value4.'</minute>';
									// array_push ($array_a, $str);
								// }
							// }
							
							// $pattern4 = '/(<td class="event-icon">.+?<\/td>)/'; 
							// $work_for_content4 = new work_for_content ($tr);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// $value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('\(+','', $value4);
								// $value4 = replace ('\)+','', $value4);
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								// $value4 = replace ('\s+$','', $value4);
								
								// if ($value4 != '') {
									// $str = '<event_icon>'.$value4.'</event_icon>';
									// array_push ($array_a, $str);
								// }
							// }
							
							// if (count ($array_a) > 0) {
								// $str = join ('', $array_a);
								// array_push ($array, $str);
							// }
						// }
					// }
				// }
			// }
					
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			


			//penalties_team_b
			$array = array ();
			// $pattern1 = '/(<div class="block.match_penalties.+?<table class="matches events">.+?<\/table>)/'; 
			// $work_for_content1 = new work_for_content ($content1);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				
				// $pattern2 = '/(<tr.+?<\/tr>)/'; 
				// $work_for_content2 = new work_for_content ($value1);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
				
					// $tr = $value2;
				
					// $td = array ();
					// $pattern3 = '/(<td class="player player-b".+?<\/td>)/'; 
					// $work_for_content3 = new work_for_content ($value2);
					// $array3 = $work_for_content3 -> get_pattern ($pattern3);
					// foreach ($array3[1] as $value3) {
						// // $value3 = strip_tags1 (html_entity_decode ($value3));
						// $value3 = replace ('^\s+','', $value3);
						// $value3 = replace ('\s+$','', $value3);
						// $value3 = replace ('\s+',' ', $value3);
						// $value3 = replace ('^\s+$','', $value3);
						
						// $value33 = $value3;
						// $value33 = strip_tags1 (html_entity_decode ($value33));
						// $value33 = replace ('^\s+','', $value33);
						// $value33 = replace ('\s+$','', $value33);
						// $value33 = replace ('\s+',' ', $value33);
						// $value33 = replace ('^\s+$','', $value33);
						
						
						// if ($value33 != '') {
						
							// $array_a = array();
							// $str = '<team_id>'.$team_id_b.'</team_id>';
							// array_push ($array_a, $str);
							
							// $pattern4 = '/(<div>.+?<\/a>)/'; 
							// $work_for_content4 = new work_for_content ($value3);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// //$value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+$','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								
								// $pattern5 = '/(<a.+?<\/a>)/'; 
								// $work_for_content5 = new work_for_content ($value4);
								// $array5 = $work_for_content5 -> get_pattern ($pattern5);
								// foreach ($array5[1] as $value5) {
									// $value5 = strip_tags1 (html_entity_decode ($value5));
									// $value5 = replace ('^\s+','', $value5);
									// $value5 = replace ('\s+$','', $value5);
									// $value5 = replace ('\s+',' ', $value5);
									
									// $str = '<player_name>'.$value5.'</player_name>';
									// array_push ($array_a, $str);
								// }	
								
								// $pattern5 = '/href="(.+?)"/'; 
								// $work_for_content5 = new work_for_content ($value4);
								// $array5 = $work_for_content5 -> get_pattern ($pattern5);
								// foreach ($array5[1] as $value5) {
									// $value5 = strip_tags1 (html_entity_decode ($value5));
									// $value5 = replace ('^\s+','', $value5);
									// $value5 = replace ('\s+$','', $value5);
									// $value5 = replace ('\s+',' ', $value5);
									// if (!preg_match ('/^http/', $value5)) {
										// $value5 = 'http://'.$host.$value5;
									// }
									// $str = '<player_url>'.$value5.'</player_url>';
									// array_push ($array_a, $str);
								// }	
								
								// $pattern5 = '/id=(\d+)"/'; 
								// $work_for_content5 = new work_for_content ($value4);
								// $array5 = $work_for_content5 -> get_pattern ($pattern5);
								// foreach ($array5[1] as $value5) {
									// $value5 = strip_tags1 (html_entity_decode ($value5));
									// $value5 = replace ('^\s+','', $value5);
									// $value5 = replace ('\s+$','', $value5);
									// $value5 = replace ('\s+',' ', $value5);
									// $str = '<player_id>'.$value5.'</player_id>';
									// array_push ($array_a, $str);
								// }	
							// }
							
							// $pattern4 = '/(<span class="additional-info">.+?<\/span>)/'; 
							// $work_for_content4 = new work_for_content ($value3);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// $value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+$','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								// if ($value4 != '') {							
									// $str = '<additional_info>'.$value4.'</additional_info>';
									// array_push ($array_a, $str);
								// }
							// }
							
							// $pattern4 = '/(<span class="extra">.+?<\/span>)/'; 
							// $work_for_content4 = new work_for_content ($value3);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// $value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('\(+','', $value4);
								// $value4 = replace ('\)+','', $value4);
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								// $value4 = replace ('\s+$','', $value4);
								
								// if ($value4 != '') {
									// $str = '<extra>'.$value4.'</extra>';
									// array_push ($array_a, $str);
								// }
							// }
							
							// $pattern4 = '/(<span class="event-type-name">.+?<\/span>)/'; 
							// $work_for_content4 = new work_for_content ($value3);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// $value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('\(+','', $value4);
								// $value4 = replace ('\)+','', $value4);
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								// $value4 = replace ('\s+$','', $value4);
								
								// if ($value4 != '') {
									// $str = '<event_type_name>'.$value4.'</event_type_name>';
									// array_push ($array_a, $str);
								// }
							// }
							
							// $pattern4 = '/(<span class="minute">.+?<\/span>)/'; 
							// $work_for_content4 = new work_for_content ($value3);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// $value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('\(+','', $value4);
								// $value4 = replace ('\)+','', $value4);
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								// $value4 = replace ('\s+$','', $value4);
								
								// if ($value4 != '') {
									// $str = '<minute>'.$value4.'</minute>';
									// array_push ($array_a, $str);
								// }
							// }
							
							// $pattern4 = '/(<td class="event-icon">.+?<\/td>)/'; 
							// $work_for_content4 = new work_for_content ($tr);
							// $array4 = $work_for_content4 -> get_pattern ($pattern4);
							// foreach ($array4[1] as $value4) {
								// $value4 = strip_tags1 (html_entity_decode ($value4));
								// $value4 = replace ('\(+','', $value4);
								// $value4 = replace ('\)+','', $value4);
								// $value4 = replace ('^\s+','', $value4);
								// $value4 = replace ('\s+',' ', $value4);
								// $value4 = replace ('\s+$','', $value4);
								
								// if ($value4 != '') {
									// $str = '<event_icon>'.$value4.'</event_icon>';
									// array_push ($array_a, $str);
								// }
							// }
							
							// if (count ($array_a) > 0) {
								// $str = join ('', $array_a);
								// array_push ($array, $str);
							// }
						// }
					// }
				// }
			// }
					
			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			$work_for_txt1 -> put (1); 


			#team_a_players_line_total
			$th_global = array ();
			$count_table = 0;
			$table = array ();
			$pattern1 = '/(<table class="table match-stat.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				//print $value1 ."\n";
				
				$value1 = replace ('""', '" "', $value1);
				$value1 = replace ('><', '> <', $value1);
				
				$count_table++;
				
				if ($count_table == 1) {
				
					//заголовки
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$sub_head_count = 0;
						
						$sub_head_1 = array ();
						$sub_head_2 = array ();
						
						$pattern3 = '/(<tr class="sub-head.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							$sub_head_count++;
							
							$td = array ();
							$colspan = 1;
							
							$pattern4 = '/(<th.+?<\/th>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
							
								$pattern5 = '/colspan="(\d+)"/'; 
								$work_for_content5 = new work_for_content ($value4);
								$array5 = $work_for_content5 -> get_pattern ($pattern5);
								foreach ($array5[1] as $value5) {
									$value5 = replace ('^\s+','', $value5);
									$value5 = replace ('\s+$','', $value5);
									$value5 = replace ('\s+',' ', $value5);
									$colspan = $value5;
								}
								
								if ($colspan == 0) {$colspan =1;}
								//print '$colspan = '. $colspan ."\n";
								
								while ($colspan > 0) {
									
									$pattern5 = '/(<th.+?<\/th>)/'; 
									$work_for_content5 = new work_for_content ($value4);
									$array5 = $work_for_content5 -> get_pattern ($pattern5);
									foreach ($array5[1] as $value5) {
										// $value4 = strip_tags (html_entity_decode ($value4));
										$value5 = replace ('^\s+','', $value5);
										$value5 = replace ('\s+$','', $value5);
										$value5 = replace ('\s+',' ', $value5);
										array_push ($td, $value5);
									}
									$colspan--;
								}
							}
							
							if ($sub_head_count == 1) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_1, $td_value);
								}
							}
							
							if ($sub_head_count == 2) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_2, $td_value);
								}
							}
						}	
						
						
						foreach ($sub_head_1 as $sub_head_1_key => $sub_head_1_value) {
							$sub_head_1 [$sub_head_1_key] = trim (strip_tags (html_entity_decode ($sub_head_1 [$sub_head_1_key])));
						}

						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
							$sub_head_2 [$sub_head_2_key] = trim (strip_tags (html_entity_decode ($sub_head_2 [$sub_head_2_key])));
						}

						$sub_head_2_count = 0;
						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
						
							$str = $sub_head_1[$sub_head_2_count].'_'.$sub_head_2[$sub_head_2_count];
							$str = strtolower ($str);
							$str = preg_replace ('/_$/ui', '', $str);
							$str = preg_replace ('/^_/ui', '', $str);
							$str = preg_replace ('/\//ui', '_', $str);
							$str = preg_replace ('/_+/ui', '_', $str);
							$str = preg_replace ('/\#/ui', 'shirtnumber', $str);
							$str = preg_replace ('/shirtnumber/ui', 'player_number', $str);
							$str = preg_replace ('/name/ui', 'player_name', $str);
							
							//принудитульно формируем $th
							$th [$str] = $str;
							
							if (isset ($th [$str])) {
								array_push ($th_global, $th [$str]);
								
							} else {
								die (print '$th [$str] not exists' ."\n".$str);
							}
							
							$sub_head_2_count++;
						}		
					}
					
					
					$value1 = replace ('<thead.+?<\/thead>', '', $value1);
				
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$pattern3 = '/(<tr.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							
							if (preg_match ('/<tr class="total-row">/', $value3)) {
							
								$value3 = preg_replace ('/<td colspan="3" class="phrase total">Totals<\/td>/', '<td colspan="3" class="phrase total">Totals</td> <td>0</td>', $value3);
							
								$td = array ();
								$pattern4 = '/(<td.+?<\/td>)/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
										
									//$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
									array_push ($td, $value4);
								}
								
								// print 'count ($td) = ' . count ($td) ."\n";
								if (count ($td) > 1) {
									array_push ($table, $td);
									//print_r ($td) ."\n";
								}
							}
						}
					}
				}
			}
			
			// print_r ($th_global) ."\n";
			// print_r ($table) ."\n";
			
			array_shift ($th_global);
			
			
			
			$th_global_copy = $th_global;
			$array = array ();
			if (count ($table)> 0) {
				
				// print_r ($table) ."\n";
				
				// $t= array_shift ($table);
				// // if (preg_match ('/colspan="3"/', $t)) {
					// // array_unshift ($table, '<td>0</td>');
					// // array_unshift ($table, $t);
				// // } else {
					// // array_unshift ($table, $t);
				// // }
				
				// print "\n\n";
				// print_r ($table) ."\n";
				
				
				foreach ($table as $table_value1) {
				
					// print $url ."\n";
					// print_r ($table_value1) ."\n";
					
					$array_a = array ();
					
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					//player_name
					$pattern1 = '/^(.+)$/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$value1 = strip_tags1 (html_entity_decode ($value1));
						$value1 = replace ('^\s+','', $value1);
						$value1 = replace ('\s+$','', $value1);
						$value1 = replace ('\s+',' ', $value1);
						$value1 = replace ('^\s+$','', $value1);
						
						if ($value1 != '') {
							$str = '<'.$cth.'>'.$value1.'_teama'.'</'.$cth.'>';
							array_push ($array_a, $str);
							//print $str ."\n";
						}
					}
			
					
					while (count ($table_value1) > 0) {
					
						$ctd = array_shift ($table_value1);
						$cth = array_shift ($th_global);
					
						$pattern1 = '/^(.+)$/'; 
						$work_for_content1 = new work_for_content ($ctd);
						$array1 = $work_for_content1 -> get_pattern ($pattern1);
						foreach ($array1[1] as $value1) {
						
							$value1 = strip_tags1 (html_entity_decode ($value1));
							$value1 = replace ('^\s+','', $value1);
							$value1 = replace ('\s+$','', $value1);
							$value1 = replace ('\s+',' ', $value1);
							$value1 = replace ('^\s+$','', $value1);
							
							if ($value1 != '') {
								$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
								array_push ($array_a, $str);
							}
						}
					}
					
					$th_global = $th_global_copy;
					
					$str = '<team_id>'.$team_id_a.'</team_id>';
					array_push ($array_a, $str);
					
					if (count ($array_a) > 0) {
						$str = join ('', $array_a);
						array_push ($array, $str);
					}
				}
			}

			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}
			
			
			
			#team_a_players_line_total_pitching
			$th_global = array ();
			$count_table = 0;
			$table = array ();
			$pattern1 = '/(<table class="table match-stat.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				//print $value1 ."\n";
				
				$value1 = replace ('""', '" "', $value1);
				$value1 = replace ('><', '> <', $value1);
				
				$count_table++;
				
				if ($count_table == 3) {
				
					//заголовки
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$sub_head_count = 0;
						
						$sub_head_1 = array ();
						$sub_head_2 = array ();
						
						$pattern3 = '/(<tr class="sub-head.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							$sub_head_count++;
							
							$td = array ();
							$colspan = 1;
							
							$pattern4 = '/(<th.+?<\/th>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
							
								$pattern5 = '/colspan="(\d+)"/'; 
								$work_for_content5 = new work_for_content ($value4);
								$array5 = $work_for_content5 -> get_pattern ($pattern5);
								foreach ($array5[1] as $value5) {
									$value5 = replace ('^\s+','', $value5);
									$value5 = replace ('\s+$','', $value5);
									$value5 = replace ('\s+',' ', $value5);
									$colspan = $value5;
								}
								
								if ($colspan == 0) {$colspan =1;}
								//print '$colspan = '. $colspan ."\n";
								
								while ($colspan > 0) {
									
									$pattern5 = '/(<th.+?<\/th>)/'; 
									$work_for_content5 = new work_for_content ($value4);
									$array5 = $work_for_content5 -> get_pattern ($pattern5);
									foreach ($array5[1] as $value5) {
										// $value4 = strip_tags (html_entity_decode ($value4));
										$value5 = replace ('^\s+','', $value5);
										$value5 = replace ('\s+$','', $value5);
										$value5 = replace ('\s+',' ', $value5);
										array_push ($td, $value5);
									}
									$colspan--;
								}
							}
							
							if ($sub_head_count == 1) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_1, $td_value);
								}
							}
							
							if ($sub_head_count == 2) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_2, $td_value);
								}
							}
						}	
						
						
						foreach ($sub_head_1 as $sub_head_1_key => $sub_head_1_value) {
							$sub_head_1 [$sub_head_1_key] = trim (strip_tags (html_entity_decode ($sub_head_1 [$sub_head_1_key])));
						}

						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
							$sub_head_2 [$sub_head_2_key] = trim (strip_tags (html_entity_decode ($sub_head_2 [$sub_head_2_key])));
						}

						$sub_head_2_count = 0;
						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
						
							$str = $sub_head_1[$sub_head_2_count].'_'.$sub_head_2[$sub_head_2_count];
							$str = strtolower ($str);
							$str = preg_replace ('/_$/ui', '', $str);
							$str = preg_replace ('/^_/ui', '', $str);
							$str = preg_replace ('/\//ui', '_', $str);
							$str = preg_replace ('/_+/ui', '_', $str);
							$str = preg_replace ('/\#/ui', 'shirtnumber', $str);
							$str = preg_replace ('/shirtnumber/ui', 'player_number', $str);
							$str = preg_replace ('/name/ui', 'player_name', $str);
							
							//принудитульно формируем $th
							$th [$str] = $str;
							
							if (isset ($th [$str])) {
								array_push ($th_global, $th [$str]);
								
							} else {
								die (print '$th [$str] not exists' ."\n".$str);
							}
							
							$sub_head_2_count++;
						}		
					}

					
					$value1 = replace ('<thead.+?<\/thead>', '', $value1);
				
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$pattern3 = '/(<tr.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
						
							if (preg_match ('/<tr class="total-row">/', $value3)) {
						
								$td = array ();
								$pattern4 = '/(<td.+?<\/td>)/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
										
									//$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
									array_push ($td, $value4);
								}
								
								// print 'count ($td) = ' . count ($td) ."\n";
								if (count ($td) > 1) {
									array_push ($table, $td);
									//print_r ($td) ."\n";
								}
							}
						}
					}
				}
			}
			
			//print_r ($th_global) ."\n";
			array_shift ($th_global);
			
			
			$th_global_copy = $th_global;
			$array = array ();
			if (count ($table)> 0) {
				
				//print_r ($table) ."\n";
				
				foreach ($table as $table_value1) {
				
					// print $url ."\n";
					// print_r ($table_value1) ."\n";
					
					$array_a = array ();
					
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					//player_name
					$pattern1 = '/^(.+)$/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$value1 = strip_tags1 (html_entity_decode ($value1));
						$value1 = replace ('^\s+','', $value1);
						$value1 = replace ('\s+$','', $value1);
						$value1 = replace ('\s+',' ', $value1);
						$value1 = replace ('^\s+$','', $value1);
						
						if ($value1 != '') {
							$str = '<'.$cth.'>'.$value1.'_pitching_teama'.'</'.$cth.'>';
							array_push ($array_a, $str);
							//print $str ."\n";
						}
					}
			
					
					while (count ($table_value1) > 0) {
					
						$ctd = array_shift ($table_value1);
						$cth = array_shift ($th_global);
					
						$pattern1 = '/^(.+)$/'; 
						$work_for_content1 = new work_for_content ($ctd);
						$array1 = $work_for_content1 -> get_pattern ($pattern1);
						foreach ($array1[1] as $value1) {
						
							$value1 = strip_tags1 (html_entity_decode ($value1));
							$value1 = replace ('^\s+','', $value1);
							$value1 = replace ('\s+$','', $value1);
							$value1 = replace ('\s+',' ', $value1);
							$value1 = replace ('^\s+$','', $value1);
							
							if ($value1 != '') {
								$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
								array_push ($array_a, $str);
							}
						}
					}
					
					$th_global = $th_global_copy;
					
					$str = '<team_id>'.$team_id_a.'</team_id>';
					array_push ($array_a, $str);
					
					if (count ($array_a) > 0) {
						$str = join ('', $array_a);
						array_push ($array, $str);
						//print $str ."\n";
					}
				}
			}

			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}

			
			#team_b_players_line_total
			$th_global = array ();
			$count_table = 0;
			$table = array ();
			$pattern1 = '/(<table class="table match-stat.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				
				$value1 = replace ('""', '" "', $value1);
				$value1 = replace ('><', '> <', $value1);
				
				$count_table++;
				
				if ($count_table == 2) {
				
					//заголовки
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$sub_head_count = 0;
						
						$sub_head_1 = array ();
						$sub_head_2 = array ();
						
						$pattern3 = '/(<tr class="sub-head.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							$sub_head_count++;
							
							$td = array ();
							$colspan = 1;
							
							$pattern4 = '/(<th.+?<\/th>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
							
								$pattern5 = '/colspan="(\d+)"/'; 
								$work_for_content5 = new work_for_content ($value4);
								$array5 = $work_for_content5 -> get_pattern ($pattern5);
								foreach ($array5[1] as $value5) {
									$value5 = replace ('^\s+','', $value5);
									$value5 = replace ('\s+$','', $value5);
									$value5 = replace ('\s+',' ', $value5);
									$colspan = $value5;
								}
								
								if ($colspan == 0) {$colspan =1;}
								//print '$colspan = '. $colspan ."\n";
								
								while ($colspan > 0) {
									
									$pattern5 = '/(<th.+?<\/th>)/'; 
									$work_for_content5 = new work_for_content ($value4);
									$array5 = $work_for_content5 -> get_pattern ($pattern5);
									foreach ($array5[1] as $value5) {
										// $value4 = strip_tags (html_entity_decode ($value4));
										$value5 = replace ('^\s+','', $value5);
										$value5 = replace ('\s+$','', $value5);
										$value5 = replace ('\s+',' ', $value5);
										array_push ($td, $value5);
									}
									$colspan--;
								}
							}
							
							if ($sub_head_count == 1) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_1, $td_value);
								}
							}
							
							if ($sub_head_count == 2) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_2, $td_value);
								}
							}
						}	
						
						// print_r ($sub_head_1) ."\n";
						// print_r ($sub_head_2) ."\n";
						
						foreach ($sub_head_1 as $sub_head_1_key => $sub_head_1_value) {
							$sub_head_1 [$sub_head_1_key] = trim (strip_tags (html_entity_decode ($sub_head_1 [$sub_head_1_key])));
						}

						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
							$sub_head_2 [$sub_head_2_key] = trim (strip_tags (html_entity_decode ($sub_head_2 [$sub_head_2_key])));
						}

						$sub_head_2_count = 0;
						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
						
							$str = $sub_head_1[$sub_head_2_count].'_'.$sub_head_2[$sub_head_2_count];
							$str = strtolower ($str);
							$str = preg_replace ('/_$/ui', '', $str);
							$str = preg_replace ('/^_/ui', '', $str);
							$str = preg_replace ('/\//ui', '_', $str);
							$str = preg_replace ('/_+/ui', '_', $str);
							$str = preg_replace ('/\#/ui', 'shirtnumber', $str);
							$str = preg_replace ('/shirtnumber/ui', 'player_number', $str);
							$str = preg_replace ('/name/ui', 'player_name', $str);
							
							//принудитульно формируем $th
							$th [$str] = $str;
							
							if (isset ($th [$str])) {
								array_push ($th_global, $th [$str]);
								
							} else {
								die (print '$th [$str] not exists' ."\n".$str);
							}
							
							$sub_head_2_count++;
						}		
					}

					
					$value1 = replace ('<thead.+?<\/thead>', '', $value1);
				
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$pattern3 = '/(<tr.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
						
							if (preg_match ('/<tr class="total-row">/', $value3)) {
								$value3 = preg_replace ('/<td colspan="3" class="phrase total">Totals<\/td>/', '<td colspan="3" class="phrase total">Totals</td> <td>0</td>', $value3);
								
						
								$td = array ();
								$pattern4 = '/(<td.+?<\/td>)/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
										
									//$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
									array_push ($td, $value4);
									
								}
								
								// print 'count ($td) = ' . count ($td) ."\n";
								if (count ($td) > 1) {
									//array_pop ($td); //удаляю пустую строку
									array_push ($table, $td);
								}
							}
						}
					}
				}
			}
			
			
			$th_global_copy = $th_global;
			array_shift ($th_global);
			
			// print_r ($th_global) ."\n";
			// print_r ($table) ."\n";
			
			$array = array ();
			if (count ($table)> 0) {
				
				foreach ($table as $table_value1) {
				
					$array_a = array ();
					
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					//player_name
					$pattern1 = '/^(.+)$/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$value1 = strip_tags1 (html_entity_decode ($value1));
						$value1 = replace ('^\s+','', $value1);
						$value1 = replace ('\s+$','', $value1);
						$value1 = replace ('\s+',' ', $value1);
						$value1 = replace ('^\s+$','', $value1);
						
						if ($value1 != '') {
							$str = '<'.$cth.'>'.$value1.'_teamb'.'</'.$cth.'>';
							array_push ($array_a, $str);
							//print $str ."\n";
						}
					}
			
					
					while (count ($table_value1) > 0) {
					
						$ctd = array_shift ($table_value1);
						$cth = array_shift ($th_global);
					
						$pattern1 = '/^(.+)$/'; 
						$work_for_content1 = new work_for_content ($ctd);
						$array1 = $work_for_content1 -> get_pattern ($pattern1);
						foreach ($array1[1] as $value1) {
						
							$value1 = strip_tags1 (html_entity_decode ($value1));
							$value1 = replace ('^\s+','', $value1);
							$value1 = replace ('\s+$','', $value1);
							$value1 = replace ('\s+',' ', $value1);
							$value1 = replace ('^\s+$','', $value1);
							
							if ($value1 != '') {
								$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
								array_push ($array_a, $str);
							}
						}
					}
					
					$th_global = $th_global_copy;
					
					$str = '<team_id>'.$team_id_b.'</team_id>';
					array_push ($array_a, $str);
					
					if (count ($array_a) > 0) {
						$str = join ('', $array_a);
						array_push ($array, $str);
						
					}
				}
			}

			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
			} else {
				$work_for_txt1 -> put ('-'); 
			}

			
			#team_b_players_line_total_pitching
			$th_global = array ();
			$count_table = 0;
			$table = array ();
			$pattern1 = '/(<table class="table match-stat.+?<\/table>)/'; 
			$work_for_content1 = new work_for_content ($content1);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				//print $value1 ."\n";
				
				$value1 = replace ('""', '" "', $value1);
				$value1 = replace ('><', '> <', $value1);
				
				$count_table++;
				
				if ($count_table == 4) {
				
					//заголовки
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$sub_head_count = 0;
						
						$sub_head_1 = array ();
						$sub_head_2 = array ();
						
						$pattern3 = '/(<tr class="sub-head.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
							$sub_head_count++;
							
							$td = array ();
							$colspan = 1;
							
							$pattern4 = '/(<th.+?<\/th>)/'; 
							$work_for_content4 = new work_for_content ($value3);
							$array4 = $work_for_content4 -> get_pattern ($pattern4);
							foreach ($array4[1] as $value4) {
							
								$pattern5 = '/colspan="(\d+)"/'; 
								$work_for_content5 = new work_for_content ($value4);
								$array5 = $work_for_content5 -> get_pattern ($pattern5);
								foreach ($array5[1] as $value5) {
									$value5 = replace ('^\s+','', $value5);
									$value5 = replace ('\s+$','', $value5);
									$value5 = replace ('\s+',' ', $value5);
									$colspan = $value5;
								}
								
								if ($colspan == 0) {$colspan =1;}
								//print '$colspan = '. $colspan ."\n";
								
								while ($colspan > 0) {
									
									$pattern5 = '/(<th.+?<\/th>)/'; 
									$work_for_content5 = new work_for_content ($value4);
									$array5 = $work_for_content5 -> get_pattern ($pattern5);
									foreach ($array5[1] as $value5) {
										// $value4 = strip_tags (html_entity_decode ($value4));
										$value5 = replace ('^\s+','', $value5);
										$value5 = replace ('\s+$','', $value5);
										$value5 = replace ('\s+',' ', $value5);
										array_push ($td, $value5);
									}
									$colspan--;
								}
							}
							
							if ($sub_head_count == 1) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_1, $td_value);
								}
							}
							
							if ($sub_head_count == 2) {
								foreach ($td as $td_key => $td_value) {
									array_push ($sub_head_2, $td_value);
								}
							}
						}	
						
						// print_r ($sub_head_1) ."\n";
						// print_r ($sub_head_2) ."\n";
						
						foreach ($sub_head_1 as $sub_head_1_key => $sub_head_1_value) {
							$sub_head_1 [$sub_head_1_key] = trim (strip_tags (html_entity_decode ($sub_head_1 [$sub_head_1_key])));
						}

						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
							$sub_head_2 [$sub_head_2_key] = trim (strip_tags (html_entity_decode ($sub_head_2 [$sub_head_2_key])));
						}

						$sub_head_2_count = 0;
						foreach ($sub_head_2 as $sub_head_2_key => $sub_head_2_value) {
						
							$str = $sub_head_1[$sub_head_2_count].'_'.$sub_head_2[$sub_head_2_count];
							$str = strtolower ($str);
							$str = preg_replace ('/_$/ui', '', $str);
							$str = preg_replace ('/^_/ui', '', $str);
							$str = preg_replace ('/\//ui', '_', $str);
							$str = preg_replace ('/_+/ui', '_', $str);
							$str = preg_replace ('/\#/ui', 'shirtnumber', $str);
							$str = preg_replace ('/shirtnumber/ui', 'player_number', $str);
							$str = preg_replace ('/name/ui', 'player_name', $str);
							
							//принудитульно формируем $th
							$th [$str] = $str;
							
							if (isset ($th [$str])) {
								array_push ($th_global, $th [$str]);
								
							} else {
								die (print '$th [$str] not exists' ."\n".$str);
							}
							
							$sub_head_2_count++;
						}		
					}
					
					$value1 = replace ('<thead.+?<\/thead>', '', $value1);
				
					$pattern2 = '/(<table.+?<\/table>)/'; 
					$work_for_content2 = new work_for_content ($value1);
					$array2 = $work_for_content2 -> get_pattern ($pattern2);
					foreach ($array2[1] as $value2) {
					
						$pattern3 = '/(<tr.+?<\/tr>)/'; 
						$work_for_content3 = new work_for_content ($value2);
						$array3 = $work_for_content3 -> get_pattern ($pattern3);
						foreach ($array3[1] as $value3) {
						
							if (preg_match ('/<tr class="total-row">/', $value3)) {
						
								$td = array ();
								$pattern4 = '/(<td.+?<\/td>)/'; 
								$work_for_content4 = new work_for_content ($value3);
								$array4 = $work_for_content4 -> get_pattern ($pattern4);
								foreach ($array4[1] as $value4) {
										
									//$value4 = strip_tags1 (html_entity_decode ($value4));
									$value4 = replace ('^\s+','', $value4);
									$value4 = replace ('\s+$','', $value4);
									$value4 = replace ('\s+',' ', $value4);
									array_push ($td, $value4);
								}
								
								// print 'count ($td) = ' . count ($td) ."\n";
								if (count ($td) > 1) {
									//array_pop ($td); //удаляю пустую строку
									array_push ($table, $td);
									//print_r ($td) ."\n";
								}
							}
						}
					}
				}
			}
			
			
			$th_global_copy = $th_global;
			array_shift ($th_global);
			
			
			$array = array ();
			if (count ($table)> 0) {
				
				foreach ($table as $table_value1) {
				
					$array_a = array ();
					
					$ctd = array_shift ($table_value1);
					$cth = array_shift ($th_global);
					
					//player_name
					$pattern1 = '/^(.+)$/'; 
					$work_for_content1 = new work_for_content ($ctd);
					$array1 = $work_for_content1 -> get_pattern ($pattern1);
					foreach ($array1[1] as $value1) {
					
						$value1 = strip_tags1 (html_entity_decode ($value1));
						$value1 = replace ('^\s+','', $value1);
						$value1 = replace ('\s+$','', $value1);
						$value1 = replace ('\s+',' ', $value1);
						$value1 = replace ('^\s+$','', $value1);
						
						if ($value1 != '') {
							$str = '<'.$cth.'>'.$value1.'_pitching_teamb'.'</'.$cth.'>';
							array_push ($array_a, $str);
							//print $str ."\n";
						}
					}
			
					
					while (count ($table_value1) > 0) {
					
						$ctd = array_shift ($table_value1);
						$cth = array_shift ($th_global);
					
						$pattern1 = '/^(.+)$/'; 
						$work_for_content1 = new work_for_content ($ctd);
						$array1 = $work_for_content1 -> get_pattern ($pattern1);
						foreach ($array1[1] as $value1) {
						
							$value1 = strip_tags1 (html_entity_decode ($value1));
							$value1 = replace ('^\s+','', $value1);
							$value1 = replace ('\s+$','', $value1);
							$value1 = replace ('\s+',' ', $value1);
							$value1 = replace ('^\s+$','', $value1);
							
							if ($value1 != '') {
								$str = '<'.$cth.'>'.$value1.'</'.$cth.'>';
								array_push ($array_a, $str);
							}
						}
					}
					
					$th_global = $th_global_copy;
					
					$str = '<team_id>'.$team_id_b.'</team_id>';
					array_push ($array_a, $str);
					
					if (count ($array_a) > 0) {
						$str = join ('', $array_a);
						array_push ($array, $str);
						//print $str ."\n";
					}
				}
			}

			if (count ($array) > 0) {
				$str = join ('||', $array);
				$work_for_txt1 -> put ($str); 
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
<?php
//получение ссылок


class get_url_from_content {

	public $content;
	public $work_mysql_graber;
	public $referer;
	public $host;
	public $work_ini_file_result;
	

	function __construct ($content, $work_mysql_graber, $referer, $select, $host, $work_ini_file_result, $job) {
		$this->content = $content;
		$this->work_mysql_graber = $work_mysql_graber;
		$this->referer = $referer;
		$this->select = $select;
		$this->host = $host;
		$this->work_ini_file_result = $work_ini_file_result;
		$this ->job = $job;
	}

	
	function get () {
		
		$content = $this -> content;
		$pattern = '/\n+/';
		$replacement = ' ';
		$content = preg_replace ($pattern, $replacement, $content);
		$pattern = '/\r+/';
		$replacement = ' ';
		$content = preg_replace ($pattern, $replacement, $content);
		
		$pattern = '/\'/';
		$replacement = '"';
		$content = preg_replace ($pattern, $replacement, $content);

		//объявления
		// $arTable = array ();
		// $html = new simple_html_dom (); 
		// $html->load ($content);
		// $element = $html->find('table[class="offers_box_table"]');
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
		
		if ($this ->job ['type'] == 'html') {
			
		
			$select = '';
			$pattern1 = '/(<a.+?<\/a>)/'; 
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
					//$value2 = strip_tags1 (html_entity_decode ($value2));
					$value2 = replace ('^\s+','', $value2);
					$value2 = replace ('\s+$','', $value2);
					$value2 = replace ('^\s+$','', $value2);
					
					if (preg_match ('/\/match\/(.+?)\//ui', $value2, $a1)) {
						$text = trim (strip_tags(html_entity_decode ($a1[1])));
						
						$url = 'https://flashscore.com.ua/match/'.$text.'/#match-summary';
						$referer = $this->referer;
						$select = $this->select;
						$content1 = '';
						$file = 'http_'.MD5 ($url) .'.html';
						$state = 'new';
						$type = 'out'; 
						//$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
						
						$url = 'https://flashscore.com/match/'.$text.'/#match-summary';
						$referer = $this->referer;
						$select = $this->select;
						$content1 = '';
						$file = 'http_'.MD5 ($url) .'.html';
						$state = 'new';
						$type = 'pdf'; 
						$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					}
				}	
			}
		}	
			
		
		/*
		if ($this ->job ['type'] == 'html') {

			$select = '';
			$pattern1 = '/(<div class="teamHeader__name">.+?<\/div>)/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				$value1 = strip_tags1 (html_entity_decode ($value1));
				$value1 = replace ('^\s+','', $value1);
				$value1 = replace ('\s+$','', $value1);
				$value1 = replace ('^\s+$','', $value1);
				$select = $value1;
			}
			
			
			$pattern1 = '/AA÷(.+?)¬AD÷/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				// $url = 'https://www.myscore.com.ua/match/'.$value1.'/#match-summary'; 
				
				// $referer = $this->referer;
				// $select = $this->select;
				// $content1 = '';
				// $file = 'http_'.MD5 ($url) .'.html';
				// $state = 'new';
				// $type = 'out'; 
				
				// //$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
				
				
				//будущие матчи (нет результата)
				$url = $this -> job ['url'] .'fixtures/'; 
				//$url = preg_replace ('/https:/ui', 'http:', $url);
				
				$referer = $this->referer;
				//$select = $this->select;
				$content1 = '';
				$file = 'http_'.MD5 ($url) .'.html';
				$state = 'new';
				$type = 'html2'; 
				
				$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
				
				
				//прошлые матчи (результаты)
				$url = $this -> job ['url'] .'results/';
				//$url = preg_replace ('/https:/ui', 'http:', $url);
				
				$referer = $this->referer;
				//$select = $this->select;
				$content1 = '';
				$file = 'http_'.MD5 ($url) .'.html';
				$state = 'new';
				$type = 'html2'; 
				
				$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
				
			}
		}	
			
			
			
		
		if ($this ->job ['type'] == 'html2') {
			
			$pattern1 = '/AA÷(.+?)¬AD÷/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$url = 'https://'.$this->host.'/match/'.$value1.'/#match-summary'; 
				
				$referer = $this->referer;
				$select = $this->select;
				$content1 = '';
				$file = 'http_'.MD5 ($url) .'.html';
				$state = 'new';
				$type = 'out'; 
				
				$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
			}
			
			
			
			if (preg_match ('/fixtures/ui', $this ->job['url'])) {
				
				$tournament_id = 0;
				$pattern1 = '/<div id="tournament-page-season-fixtures">(\d+)<\/div>/'; 
				$work_for_content1 = new work_for_content ($content);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					$tournament_id = $value1;
				}	
				
				$tournament_data_mt = '';
				$pattern1 = '/_cjs.myLeagues.getToggleIcon\(null, `(.+?)`/'; 
				$work_for_content1 = new work_for_content ($content);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					$tournament_data_mt = $value1;
				}	
				
				
				$matchcount_on_page = 108;
				$allmatchcount = 1;
				$pattern1 = '/<div id="tournament-page-allmatchcount-fixtures">(\d+)<\/div>/'; 
				$work_for_content1 = new work_for_content ($content);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					$allmatchcount = $value1;
				}	
				
				$all_page = ceil ($allmatchcount / $matchcount_on_page);
				
				print '$tournament_id  = ' . $tournament_id  ."\n";
				print '$allmatchcount = '. $allmatchcount ."\n";
				print '$all_page  = ' . $all_page  ."\n";
				print '$tournament_data_mt  = ' . $tournament_data_mt  ."\n";
				
				
				if ($all_page > 1) {
					for ($i = 1; $i <= $all_page; $i++) {
		
						//$url = 'https://d.myscore.com.ua/x/feed/tf_3_200_IBmris38_170_2_3_ru_1'; 
						$url = 'http://d.myscore.com.ua/x/feed/tf_'.$tournament_data_mt.'_'.$tournament_id.'_'.$i.'_3_ru_1'; 
						
						$referer = $this->referer;
						$select = $this->select;
						$content1 = '';
						$file = 'http_'.MD5 ($url) .'.html';
						$state = 'new';
						$type = 'html3'; 
						
						$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					}
				}
			}
			
			
			if (preg_match ('/results/ui', $this ->job['url'])) {
				
				$tournament_id = 0;
				$pattern1 = '/<div id="tournament-page-season-results">(\d+)<\/div>/'; 
				$work_for_content1 = new work_for_content ($content);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					$tournament_id = $value1;
				}	
				
				$tournament_data_mt = '';
				$pattern1 = '/_cjs.myLeagues.getToggleIcon\(null, `(.+?)`/'; 
				$work_for_content1 = new work_for_content ($content);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					$tournament_data_mt = $value1;
				}	
				
				
				$matchcount_on_page = 108;
				$allmatchcount = 1;
				$pattern1 = '/<div id="tournament-page-allmatchcount-results">(\d+)<\/div>/'; 
				$work_for_content1 = new work_for_content ($content);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					$allmatchcount = $value1;
				}	
				
				$all_page = ceil ($allmatchcount / $matchcount_on_page);
				
				print '$tournament_id  = ' . $tournament_id  ."\n";
				print '$allmatchcount = '. $allmatchcount ."\n";
				print '$all_page  = ' . $all_page  ."\n";
				print '$tournament_data_mt  = ' . $tournament_data_mt  ."\n";
				
				
				if ($all_page > 1) {
					for ($i = 1; $i <= $all_page; $i++) {
		
						//https://d.myscore.com.ua/x/feed/tr_3_200_0zUTspOn_169_1_3_ru_1
						$url = 'http://d.myscore.com.ua/x/feed/tr_'.$tournament_data_mt.'_'.$tournament_id.'_'.$i.'_3_ru_1'; 
						
						$referer = $this->referer;
						$select = $this->select;
						$content1 = '';
						$file = 'http_'.MD5 ($url) .'.html';
						$state = 'new';
						$type = 'html3'; 
						
						$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					}
				}
			}
			
			
		}	
			
			
		if ($this ->job ['type'] == 'html3') {
			
			$pattern1 = '/AA÷(.+?)¬AD÷/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$url = 'https://www.myscore.com.ua/match/'.$value1.'/#match-summary'; 
				
				$referer = $this->referer;
				$select = $this->select;
				$content1 = '';
				$file = 'http_'.MD5 ($url) .'.html';
				$state = 'new';
				$type = 'out'; 
				
				$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
				
				
				$url = 'https://d.myscore.com.ua/x/feed/d_su_'.$value1.'_ru_1';
				//$referer = $this->referer;
				$referer = 'https://www.myscore.com.ua/match/'.$value1.'/#match-summary';
				$select = $this->select;
				$content1 = '';
				//$file = 'http_'.MD5 ($url) .'.html';
				$file = $value1;
				$state = 'new';
				$type = 'outa'; 
				
				$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
				
			}
		}	
		

		
		if ($this ->job ['type'] == 'out') {
		
			// //игроки
			// $array = array ();					
			// $pattern1 = '/(<TABLE cellSpacing=0 cellPadding=5 width=100% border=0 id="aannew">.+?<\/div>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
			
				// $pattern2 = '/(<dt>Date<\/dt>.+?<\/dd>)/'; 
				// $work_for_content2 = new work_for_content ($value1);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
				
					// $pattern3 = '/<span class=\'timestamp\' data-value=\'(\d+)\'/'; 
					// $work_for_content3 = new work_for_content ($value2);
					// $array3 = $work_for_content3 -> get_pattern ($pattern3);
					// foreach ($array3[1] as $value3) {
				
						// $value3 = strip_tags (html_entity_decode ($value3));
						// $value3 = replace ('^\s+','', $value3);
						// $value3 = replace ('\s+$','', $value3);
						// $value3 = replace ('\s+',' ', $value3);
					
						// //$value3 = strtotime ($value3);
						// // $value3 = $value2 + 3600*8;
						
						// $date = getdate ($value3);
						// $date_a = array ();
						// array_push ($date_a, $date['year']);
						// array_push ($date_a, $date['mon']);
						// array_push ($date_a, $date['mday']);
						
						// foreach ($date_a as $date_a_key => $date_a_value) {
							// if (strlen ($date_a_value) < 2) {
								// $date_a [$date_a_key] = '0'.$date_a [$date_a_key];
							// }
						// }
						// $date = join ('-', $date_a);
						// $this -> content1 = $date;
					// }
				// }
			// }

		
			// //выход на команды
			// $pattern1 = '/(<div class="container left">.+?<\/a>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
			
				// $pattern2 = '/href="(.+?)"/'; 
				// $work_for_content2 = new work_for_content ($value1);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
					
					// if (preg_match ('/sport=baseball&page=team&id=/', $value2)) {
						
						// if (!preg_match ('/^http/', $value2)) {
							// $value2 = 'http://'.$this -> host . '/'. $value2;
						// }
						
						// $url = $value2; 
						// $referer = $this->referer;
						// $select = $this->select;
						// if (isset ($this -> content1)) {
							// $content1 = $this -> content1;
						// } else {
							// $content1 = '';
						// }
						// $file = 'http_'.MD5 ($url) .'.html';
						// $state = 'new';
						// $type = 'media'; 
						// $this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					// }
				// }
			// }
			
			// //referee referee_
			// $pattern1 = '/(<div class="referee referee_.+?<\/a>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
			
				// $pattern2 = '/href="(.+?)"/'; 
				// $work_for_content2 = new work_for_content ($value1);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
					
					// if (preg_match ('/person&id=/', $value2)) {
						
						// if (!preg_match ('/^http/', $value2)) {
							// $value2 = 'http://'.$this -> host . '/'. $value2;
						// }
						
						// $url = $value2; 
						// $referer = $this ->job ['url'];
						// $select = $this->select;
						// if (isset ($this -> content1)) {
							// $content1 = $this -> content1;
						// } else {
							// $content1 = '';
						// }
						// $file = 'http_'.MD5 ($url) .'.html';
						// $state = 'new';
						// $type = 'picturr'; 
						
						// $this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					// }
				// }
			// }
			
			
			// //выход на команды
			// $pattern1 = '/(<div class="container right">.+?<\/a>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
			
				// $pattern2 = '/href="(.+?)"/'; 
				// $work_for_content2 = new work_for_content ($value1);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
					
					// if (preg_match ('/sport=baseball&page=team&id=/', $value2)) {
						
						// if (!preg_match ('/^http/', $value2)) {
							// $value2 = 'http://'.$this -> host . '/'. $value2;
						// }
						
						// $url = $value2; 
						// $referer = $this->referer;
						// $select = $this->select;
						// if (isset ($this -> content1)) {
							// $content1 = $this -> content1;
						// } else {
							// $content1 = '';
						// }
						// $file = 'http_'.MD5 ($url) .'.html';
						// $state = 'new';
						// $type = 'media'; 
						// $this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					// }
				// }
			// }
			
			// //выход на игроков
			// $pattern1 = '/(<div class="block.team._people_match_stat.+?<\/table>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
			
				// $pattern2 = '/(<tr.+?<\/tr>)/'; 
				// $work_for_content2 = new work_for_content ($value1);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
					
					// $td = array ();
					// $pattern3 = '/(<td.+?<\/td>)/'; 
					// $work_for_content3 = new work_for_content ($value2);
					// $array3 = $work_for_content3 -> get_pattern ($pattern3);
					// foreach ($array3[1] as $value3) {
						// array_push ($td, $value3);
					// }
					
					// if (count ($td) > 0) {
					
						// $insert = array ();
						
						// $pattern3 = '/<h2.+?href=".+?team&id=(.+?)"/'; 
						// $work_for_content3 = new work_for_content ($value1);
						// $array3 = $work_for_content3 -> get_pattern ($pattern3);
						// foreach ($array3[1] as $value3) {
							// $value3 = strip_tags (html_entity_decode ($value3));
							// $insert ['team_id'] = $value3;
						// }
						
						// $td[0] = strip_tags (html_entity_decode ($td[0]));
						// $pattern3 = '/(\d+)/'; 
						// $work_for_content3 = new work_for_content ($td[0]);
						// $array3 = $work_for_content3 -> get_pattern ($pattern3);
						// foreach ($array3[1] as $value3) {
							// $value3 = strip_tags (html_entity_decode ($value3));
							// $insert ['player_number'] = $value3;
						// }
						
						// $pattern3 = '/href="(.+?)"/'; 
						// $work_for_content3 = new work_for_content ($td[1]);
						// $array3 = $work_for_content3 -> get_pattern ($pattern3);
						// foreach ($array3[1] as $value3) {
							
							// if (preg_match ('/page=player&id=/', $value3) and !preg_match ('/^http/ui', $value3)) {
								
								// if (!preg_match ('/^http/', $value3)) {
									// $value3 = 'http://'.$this -> host . '/'. $value3;
								// }
								
								// $url = $value3; 
								// $referer = $this ->job ['url'];
								// //$select = $this->select;
								// $select = json_encode ($insert);
								
								// if (isset ($this -> content1)) {
									// $content1 = $this -> content1;
								// } else {
									// $content1 = '';
								// }
								
								// $file = 'http_'.MD5 ($url) .'.html';
								// $state = 'new';
								// $type = 'picture'; 
								
								// $this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
							// }
						// }
					// }
				// }
			// }
			
			// $insert = array ();
			
			// //actual_date
			// $array = array ();
			// $pattern3 = '/Game=(.+?)-/'; 
			// $work_for_content3 = new work_for_content ($this -> job['url']);
			// $array3 = $work_for_content3 -> get_pattern ($pattern3);
			// foreach ($array3[1] as $value3) {
				// $value3 = strip_tags (html_entity_decode ($value3));
				// $value3 = replace ('^\s+','', $value3);
				// $value3 = replace ('\s+$','', $value3);
				// $value3 = replace ('^\s+$','', $value3);
				// if ($value3 != '') {

					// $a = preg_split ('/_/ui', $value3);
					// if (count ($a) == 4) {
						
						// array_pop ($a);
						// array_pop ($a);
						// $value3 = join ('', $a);
						// $d = preg_split ('//ui', $value3);
						// if (count ($d) > 0) {
							// array_shift ($d);
							// $date = $d[0].$d[1].$d[2].$d[3].'-'.$d[4].$d[5].'-'.$d[6].$d[7];
							// $insert['actual_date'] = $date;
						// }
					// }	
				// }
			// }
			
			// //gender
			// $array = array ();
			// $pattern3 = '/women=(\d+)/'; 
			// $work_for_content3 = new work_for_content ($this -> job['referer']);
			// $array3 = $work_for_content3 -> get_pattern ($pattern3);
			// foreach ($array3[1] as $value3) {
				// $value3 = strip_tags (html_entity_decode ($value3));
				// $value3 = replace ('^\s+','', $value3);
				// $value3 = replace ('\s+$','', $value3);
				// $value3 = replace ('^\s+$','', $value3);
				
				// if ($value3 == '0') {
					// $insert['gender'] = 'men';
				// }
				
				// if ($value3 == '1') {
					// $insert['gender'] = 'women';
				// }
			// }
			
			// //игроки  и их команды
			// $pattern1 = '/(<TABLE cellSpacing=0 cellPadding=5 width=100% border=0 id="aa.+?<TABLE class=my_Title.+?<\/TABLE>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
				
				// $pattern3 = '/href="(.+?)"/'; 
				// $work_for_content3 = new work_for_content ($value1);
				// $array3 = $work_for_content3 -> get_pattern ($pattern3);
				// foreach ($array3[1] as $value3) {
					
					// if (preg_match ('/\/team\//ui', $value3)) {
						// $insert['team_id'] = preg_replace ('/^.+\//ui', '', $value3);
						
						// $url = $value3; 
						// $referer = $this ->job ['url'];
						// //$select = $this->select;
						// $select = json_encode ($insert);
						
						// if (isset ($this -> content1)) {
							// $content1 = $this -> content1;
						// } else {
							// $content1 = '';
						// }
						
						// $file = 'http_'.MD5 ($url) .'.html';
						// $state = 'new';
						// $type = 'media'; 
						
						// $this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					// }
				// }
				
				// $pattern3 = '/href="(.+?)"/'; 
				// $work_for_content3 = new work_for_content ($value1);
				// $array3 = $work_for_content3 -> get_pattern ($pattern3);
				// foreach ($array3[1] as $value3) {
					
					// if (preg_match ('/\/coach\//ui', $value3)) {
						// $insert['team_id'] = preg_replace ('/^.+\//ui', '', $value3);
						
						// $url = $value3; 
						// $referer = $this ->job ['url'];
						// //$select = $this->select;
						// $select = json_encode ($insert);
						
						// if (isset ($this -> content1)) {
							// $content1 = $this -> content1;
						// } else {
							// $content1 = '';
						// }
						
						// $file = 'http_'.MD5 ($url) .'.html';
						// $state = 'new';
						// $type = 'picturc'; 
						
						// $this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					// }
				// }
				
			
				// $pattern3 = '/href="(.+?)"/'; 
				// $work_for_content3 = new work_for_content ($value1);
				// $array3 = $work_for_content3 -> get_pattern ($pattern3);
				// foreach ($array3[1] as $value3) {
					
					// if (preg_match ('/\/player\//ui', $value3)) {
						
						// if (!preg_match ('/^http/', $value3)) {
							// $value3 = 'https://'.$this -> host . '/'. $value3;
						// }
						
						// $url = $value3; 
						// $referer = $this ->job ['url'];
						// //$select = $this->select;
						// $select = json_encode ($insert);
						
						// if (isset ($this -> content1)) {
							// $content1 = $this -> content1;
						// } else {
							// $content1 = '';
						// }
						
						// $file = 'http_'.MD5 ($url) .'.html';
						// $state = 'new';
						// $type = 'picture'; 
						
						// $this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					// }
				// }
			// }
		// }
		
		
		
		
		// if ($this ->job ['type'] == 'media') {		
		
			// $cconttent = $content;
			// $cconttent = replace ('<div class="squad-position-title group-head">Coach<\/div>.+$', '', $cconttent);
			
			// //выход на игроков
			// $pattern1 = '/(<a.+?<\/a>)/'; 
			// $work_for_content1 = new work_for_content ($cconttent);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
			
				// $pattern2 = '/href="(.+?)"/'; 
				// $work_for_content2 = new work_for_content ($value1);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
					
					// if (preg_match ('/=player&id=/', $value2)) {
						
						// if (!preg_match ('/^http/', $value2)) {
							// $value2 = 'http://'.$this -> host . '/'. $value2;
						// }
						
						// $url = $value2; 
						// $referer = $this ->job ['url'];
						// $select = $this->select;
						// $content1 = $this ->job ['content'];
						// $file = 'http_'.MD5 ($url) .'.html';
						// $state = 'new';
						// $type = 'picture'; 
						
						// $this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					// }
				// }
			// }
			
			// //coach
			// $pattern1 = '/(<div class="squad-position-title group-head">Coach<\/div>.+?<\/a>)/'; 
			// $work_for_content1 = new work_for_content ($content);
			// $array1 = $work_for_content1 -> get_pattern ($pattern1);
			// foreach ($array1[1] as $value1) {
			
				// $pattern2 = '/href="(.+?)"/'; 
				// $work_for_content2 = new work_for_content ($value1);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
					
					// if (preg_match ('/=player&id=/', $value2)) {
						
						// if (!preg_match ('/^http/', $value2)) {
							// $value2 = 'http://'.$this -> host . '/'. $value2;
						// }
						
						// $url = $value2; 
						// $referer = $this ->job ['url'];
						// $select = $this->select;
						// $content1 = $this ->job ['content'];
						// $file = 'http_'.MD5 ($url) .'.html';
						// $state = 'new';
						// $type = 'picturc'; 
						
						// $this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					// }
				// }
			// }
			
		}
		*/
		

		
		// $arTable = array ();
		// $html = new simple_html_dom (); 
		// $html->load ($content);
		// $element = $html->find('a[class="adm-nav-page"]');
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
				
				// $pattern2 = '/href="(.+?)"/'; 
				// $work_for_content2 = new work_for_content ($arTableValue);
				// $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// foreach ($array2[1] as $value2) {
				
					// if (!preg_match ('/^http/', $value2)) {
						// $value2 = 'http://'.$this -> host . $value2;
					// }
					
					// $url = $value2; 
					// $referer = $this->referer;
					// $select = $this->select;
					// $content = '';
					// $get_file_from_url = new get_file_from_url ($url);
					// $file = $get_file_from_url -> get();
					// $state = 'new';
					// $type = 'html'; 
					// $this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content, $state, $file, $type);
				// }
			// }
		// }
	}
}

function replace ($pattern1, $pattern2, $content) { 
	$pattern1 = '/'.$pattern1.'/ui';
	$content = preg_replace ($pattern1, $pattern2, $content);
	return $content;
}	
function strip_tags1 ($str) {
	$str = replace ('<.+?>', ' ', $str);
	return $str;
}


?>
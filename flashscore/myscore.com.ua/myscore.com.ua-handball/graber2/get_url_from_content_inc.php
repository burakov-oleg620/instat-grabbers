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
		$content = preg_replace ('/\n+|\r+\|t+/ui', ' ', $content);
		
		// $pattern = '/\n+/';
		// $replacement = ' ';
		// $content = preg_replace ($pattern, $replacement, $content);
		// $pattern = '/\r+/ui';
		// $replacement = ' ';
		// $content = preg_replace ($pattern, $replacement, $content);
		// $replacement = '/\t+/ui';
		// $content = preg_replace ($pattern, $replacement, $content);
		// $pattern = '/\'/';
		// $replacement = '"';
		// $content = preg_replace ($pattern, $replacement, $content);

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

			$pattern1 = '/(<div class="tabs__group">.+?<\/div>)/'; 
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
				
					if (!preg_match ('/^http/', $value2)) {
						$value2 = 'https://'.$this -> host . $value2;
					}
					
					$url = $value2;
					
					if (preg_match ('/\/results/ui', $url)) {
						
						$referer = $this->referer;
						$select = $this->select;
						$content = '';
						// $get_file_from_url = new get_file_from_url ($url);
						// $file = $get_file_from_url -> get();
						$file = 'http_'.MD5 ($url) .'.html';
						$state = 'new';
						$type = 'html2'; 
						$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content, $state, $file, $type);
						
					}
					
					if (preg_match ('/\/fixtures/ui', $url)) {
						
						$referer = $this->referer;
						$select = $this->select;
						$content = '';
						//$get_file_from_url = new get_file_from_url ($url);
						//$file = $get_file_from_url -> get();
						$file = 'http_'.MD5 ($url) .'.html';
						$state = 'new';
						$type = 'html2'; 
						$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content, $state, $file, $type);
					}
					
					
					//для чтения архивных матчей (пока заремарено)
					if (preg_match ('/\/archive/ui', $url)) {
						
						$referer = $this->referer;
						$select = $this->select;
						$content = '';
						//$get_file_from_url = new get_file_from_url ($url);
						// $file = $get_file_from_url -> get();
						$file = 'http_'.MD5 ($url) .'.html';
						$state = 'new';
						$type = 'outa'; 
						//$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content, $state, $file, $type);
					}
				}
			}
		}	

			
			
			
		//матчи
		if ($this ->job ['type'] == 'html2') {
			
			$pattern1 = '/AA÷(.+?)¬AD÷/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				//$url = 'https://flashscore.com/match/'.$value1.'/#match-summary'; 
				$url = 'https://'.$this->host.'/match/'.$value1.'/#match-summary'; 
				$referer = $this->referer;
				$select = $this->select;
				$content1 = '';
				$file = 'http_'.MD5 ($url) .'.html';
				$state = 'new';
				$type = 'pdf'; 
				$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
			}
			
			
			if (preg_match ('/fixtures/ui', $this ->job['url'])) {
				
				$tournament_id = 0;
				//$pattern1 = '/<div id="tournament-page-season-fixtures">(\d+)<\/div>/'; 
				$pattern1 = '/seasonId: (\d+),/'; 
				$work_for_content1 = new work_for_content ($content);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					$tournament_id = $value1;
				}	
				
				$tournament_data_mt = '';
				//$pattern1 = '/_cjs.myLeagues.getToggleIcon\(null, `(.+?)`/'; 
				//$pattern1 = '/myLeagues\.getToggleIcon\(null, "(.+?)"/'; 
				//$pattern1 = '/tournament_id = "(.+?)"/'; 
				$pattern1 = '/getToggleIcon\("(.+?)",/'; 
				$work_for_content1 = new work_for_content ($content);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					$tournament_data_mt = $value1;
				}	
				
				
				$matchcount_on_page = 108;
				$allmatchcount = 1;
				//$pattern1 = '/<div id="tournament-page-allmatchcount-fixtures">(\d+)<\/div>/'; 
				$pattern1 = '/allEventsCount: (\d+),/'; 
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
		
						$url = 'https://d.'.$this->host.'/x/feed/tf_'.$tournament_data_mt.'_'.$tournament_id.'_'.$i.'_3_ru_1'; 
						
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
				//$pattern1 = '/<div id="tournament-page-season-results">(\d+)<\/div>/'; 
				$pattern1 = '/seasonId: (\d+),/'; 
				$work_for_content1 = new work_for_content ($content);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					$tournament_id = $value1;
				}	
				
				$tournament_data_mt = '';
				//$pattern1 = '/_cjs.myLeagues.getToggleIcon\(null, `(.+?)`/'; 
				//$pattern1 = '/myLeagues\.getToggleIcon\(null, "(.+?)"/'; 
				//$pattern1 = '/tournament_id = "(.+?)"/'; 
				$pattern1 = '/getToggleIcon\("(.+?)",/'; 
				$work_for_content1 = new work_for_content ($content);
				$array1 = $work_for_content1 -> get_pattern ($pattern1);
				foreach ($array1[1] as $value1) {
					$tournament_data_mt = $value1;
				}	
				
				
				$matchcount_on_page = 108;
				$allmatchcount = 1;
				//$pattern1 = '/<div id="tournament-page-allmatchcount-results">(\d+)<\/div>/'; 
				$pattern1 = '/allEventsCount: (\d+),/'; 
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
		
						$url = 'https://d.'.$this->host.'/x/feed/tr_'.$tournament_data_mt.'_'.$tournament_id.'_'.$i.'_3_ru_1'; 
						
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
			

		
		//матчи из архива
		if ($this ->job ['type'] == 'outa') {
			
			$pattern1 = '/(<div class="leagueTable__season">.+?<\/div>)/'; 
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
				
					if (!preg_match ('/^http/', $value2)) {
						$value2 = 'https://'.$this -> host . $value2;
					}
					
					$url = $value2; 
					$referer = $this->referer;
					$select = $this->select;
					$content = '';
					// $get_file_from_url = new get_file_from_url ($url);
					// $file = $get_file_from_url -> get();
					$file = 'http_'.MD5 ($url) .'.html';
					$state = 'new';
					$type = 'html4'; 
					$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content, $state, $file, $type);
					
				}
			}
		}	
			


		if ($this ->job ['type'] == 'html4') {
			
			$pattern1 = '/(<div class="tabs__group">.+?<\/div>)/'; 
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
				
					if (!preg_match ('/^http/', $value2)) {
						$value2 = 'https://'.$this -> host . $value2;
					}
					
					$url = $value2; 
					
					
					if (preg_match ('/\/results\/$/ui', $url)) {
						
						$referer = $this->referer;
						$select = $this->select;
						$content = '';
						// $get_file_from_url = new get_file_from_url ($url);
						// $file = $get_file_from_url -> get();
						$file = 'http_'.MD5 ($url) .'.html';
						$state = 'new';
						$type = 'html2'; 
						$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content, $state, $file, $type);
						
					}
					
					if (preg_match ('/\/fixtures\/$/ui', $url)) {
						
						$referer = $this->referer;
						$select = $this->select;
						$content = '';
						//$get_file_from_url = new get_file_from_url ($url);
						//$file = $get_file_from_url -> get();
						$file = 'http_'.MD5 ($url) .'.html';
						$state = 'new';
						$type = 'html2'; 
						$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content, $state, $file, $type);
					}
					
				}
			}

		}	
			
			
		if ($this ->job ['type'] == 'html3') {
			
			$pattern1 = '/AA÷(.+?)¬AD÷/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				// $url = 'https://flashscore.com.ua/match/'.$value1.'/#match-summary'; 
				// $referer = $this->referer;
				// $select = $this->select;
				// $content1 = '';
				// $file = 'http_'.MD5 ($url) .'.html';
				// $state = 'new';
				// $type = 'out'; 
				// //$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
				
				//$url = 'https://flashscore.com/match/'.$value1.'/#match-summary'; 
				$url = 'https://'.$this->host.'/match/'.$value1.'/#match-summary'; 
				$referer = $this->referer;
				$select = $this->select;
				$content1 = '';
				$file = 'http_'.MD5 ($url) .'.html';
				$state = 'new';
				$type = 'pdf'; 
				$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
			}
		}	

		

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
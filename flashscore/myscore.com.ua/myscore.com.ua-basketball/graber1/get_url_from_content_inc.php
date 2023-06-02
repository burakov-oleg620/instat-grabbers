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
		
		// $pattern = '/\'/';
		// $replacement = '"';
		// $content = preg_replace ($pattern, $replacement, $content);

		//объ¤влени¤
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
		
			//$pattern1 = '/(<ul class="submenu hidden".+?<\/ul>)/'; 
			//$pattern1 = '/(<li id="lmenu.+?<\/a>)/'; 

			$pattern1 = '/(<div class="left_menu_categories_seo">.+?<\/div>)/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
				
				$pattern2 = '/href="(.+?)"/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {
					

					if (preg_match ('/basketball/', $value2)) {

						$v2 = preg_split ('/\//ui', $value2);
						if (count ($v2) == 4) {
						
							if (!preg_match ('/^http/', $value2)) {
								//$value2 = 'https://'.$this -> host . '/'.$value2;
								$value2 = 'https://'.$this -> host . $value2;
							}
							
							$url = $value2; 
							$referer = $this->referer;
							$select = $this->select;
							$content1 = '';
							$file = 'http_'.MD5 ($url) .'.html';
							$state = 'new';
							$type = 'out'; 
							
							$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
						}

					}
				}
				
				//break;
			}
		}
		
		


		if ($this ->job ['type'] == 'out') {		
			
			//$pattern1 = '/(<ul class="menu selected-country-list">.+?<\/ul>)/'; 
			$pattern1 = '/(<div class="leftMenu__item leftMenu__item--width.+?<\/div>)/'; 
			$work_for_content1 = new work_for_content ($content);
			$array1 = $work_for_content1 -> get_pattern ($pattern1);
			foreach ($array1[1] as $value1) {
			
				$pattern2 = '/href="(.+?)"/'; 
				$work_for_content2 = new work_for_content ($value1);
				$array2 = $work_for_content2 -> get_pattern ($pattern2);
				foreach ($array2[1] as $value2) {

					// if (preg_match ('/hockey/', $value2)) {

						if (!preg_match ('/^http/', $value2)) {
							//$value2 = 'https://'.$this -> host . '/'.$value2;
							$value2 = 'https://'.$this -> host . $value2;
						}
						
						$url = $value2; 
						$referer = $this->referer;
						$select = $this->select;
						$content1 = '';
						$file = 'http_'.MD5 ($url) .'.html';
						$state = 'new';
						$type = 'media'; 
						
						$this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content1, $state, $file, $type);
					// }
				}
			}
		}	
		

		
		// // $arTable = array ();
		// // $html = new simple_html_dom (); 
		// // $html->load ($content);
		// // $element = $html->find('a[class="adm-nav-page"]');
		// // if(count($element) > 0) {
			// // foreach($element as $table) {
				// // //echo '1 = '.  $table->innertext ."\n";
				// // array_push ($arTable, $table->innertext);
			// // }
		// // }
		
		// // if (count ($arTable) > 0) {
			// // foreach ($arTable as $arTableValue) {
				// // // print $arTableValue ."\n";
				// // // print $file ."\n";
				
				// // $pattern2 = '/href="(.+?)"/'; 
				// // $work_for_content2 = new work_for_content ($arTableValue);
				// // $array2 = $work_for_content2 -> get_pattern ($pattern2);
				// // foreach ($array2[1] as $value2) {
				
					// // if (!preg_match ('/^http/', $value2)) {
						// // $value2 = 'http://'.$this -> host . $value2;
					// // }
					
					// // $url = $value2; 
					// // $referer = $this->referer;
					// // $select = $this->select;
					// // $content = '';
					// // $get_file_from_url = new get_file_from_url ($url);
					// // $file = $get_file_from_url -> get();
					// // $state = 'new';
					// // $type = 'html'; 
					// // $this -> work_mysql_graber -> insert_ignore_into_table ($url, $referer, $select, $content, $state, $file, $type);
				// // }
			// // }
			
			
	}
}

function replace ($pattern1, $pattern2, $content) { 
	$pattern1 = '/'.$pattern1.'/';
	$content = preg_replace ($pattern1, $pattern2, $content);
	return $content;
}	

?>
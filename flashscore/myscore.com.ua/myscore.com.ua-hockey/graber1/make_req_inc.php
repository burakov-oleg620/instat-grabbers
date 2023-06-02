<?php
//создание запроса


class make_req {

	public $array;
	public $host;
	public $work_mysql_graber;
	public $ch;
	public $work_ini_file_result;
	public $proxy_array;
	
	function __construct ($array, $host, $work_mysql_graber, $ch, $work_ini_file_result, $proxy_array) {
		$this->array = $array;
		$this -> host = $host;
		$this -> work_mysql_graber = $work_mysql_graber;
		$this -> ch = $ch;
		$this -> work_ini_file_result = $work_ini_file_result;
		$this -> proxy_array = $proxy_array;
	}
	
	function make () {
		
		$url = $this->array['url']; 
		$referer = $this->array['referer'];
		$select = $this->array['select'];
		$file = $this->array['file'];
		$type = $this->array['type'];
		
		$workdir = getcwd ().'/'.$type;
		$pattern = '/\\\/';
		$replacement = '/';
		$workdir = preg_replace ($pattern, $replacement, $workdir);
		
		if (file_exists ($workdir)) {
		} else {
			mkdir ($workdir);
		}
		
		//установка нового урл
		curl_setopt($this -> ch, CURLOPT_URL, $url);
		
		//установка признака прокси
		if (isset ($this -> work_ini_file_result ['proxy_set']) and  $this -> work_ini_file_result ['proxy_set'] == 1)  {
			
			// print 'count ($this -> proxy_array) = '. count ($this -> proxy_array) ."\n";
			// print '$this -> work_ini_file_result [\'proxy_limit_down\'] = ' . $this -> work_ini_file_result ['proxy_limit_down'] ."\n";
		
			if (count ($this -> proxy_array) > $this -> work_ini_file_result ['proxy_limit_down']) {
				
				$proxy = array_shift ($this -> proxy_array);
				//$proxy['proxy'] = '127.0.0.1:8080';
				
				print  '$proxy = ' . $proxy['proxy']."\n";
				curl_setopt($this -> ch, CURLOPT_PROXY, $proxy['proxy']);
				
				// $get_proxy_from_service = new get_proxy_from_service ($work_ini_file_result, $work_mysql_graber);
				// $get_proxy_from_service_result =  $get_proxy_from_service -> get ();
				// unset ($get_proxy_from_service);
				
				
			} else {
			
				$insert = array ();
				$insert ['proxy_select'] = $this -> work_ini_file_result ['proxy_limit'];
				$this -> proxy_array = $this -> work_mysql_graber -> select_proxy_from_array ($insert);
				
				// print '**count ($this -> proxy_array) = '. count ($this -> proxy_array) ."\n";
				// print '**$this -> work_ini_file_result [\'proxy_limit_down\'] = ' . $this -> work_ini_file_result ['proxy_limit_down'] ."\n";
				
				// print_r ($this -> proxy_array) ."\n";
				if (count ($this -> proxy_array) > $this -> work_ini_file_result ['proxy_limit_down']) {
					
					$proxy = array_shift ($this -> proxy_array);
					//$proxy['proxy'] = '127.0.0.1:8080';
					
					print  '$proxy = ' . $proxy['proxy']."\n";
					curl_setopt($this -> ch, CURLOPT_PROXY, $proxy['proxy']);
					
				} else {
					die (print 'no proxy' ."\n");
				}
			}
		}
		
		
		// загрузка страницы и выдача её браузеру
		$content = curl_exec($this -> ch);		
		
		
		
		$httpcode = curl_getinfo($this -> ch, CURLINFO_HTTP_CODE);
		//print $httpcode."\t".$url. "\n";
		print $httpcode."\t".$this->array['type']."\t".$url. "\n";
		
		if ($httpcode == 200) {
			
			$file = $workdir.'/'.$file;
			$put_content_to_file = new put_content_to_file ($content, $file);
			$put_content_to_file -> put ();
			
			$my_host = $this -> host;
			$host_array = preg_split ('/\//', $url);
			if (count ($host_array) > 2) {
				
				$pattern = '/www\./';
				$replacement = '';
				$workdir = preg_replace ($pattern, $replacement, $host_array[2]);
				$my_host = $host_array[2];
			}
			
			
			// $get_url_from_content = new get_url_from_content ($content, $this->work_mysql_graber, $url, $select, $this->host);
			// $get_url_from_content = new get_url_from_content ($content, $this->work_mysql_graber, $referer, $select, $this->host, $this -> work_ini_file_result);
			
			$get_url_from_content = new get_url_from_content ($content, $this->work_mysql_graber, $referer, $select, $my_host, $this -> work_ini_file_result, $this->array);
			$get_url_from_content -> get (); 
			unset ($get_url_from_content);
			
			
			
			if ($type == 'media' and $this -> work_ini_file_result ['system'] == 1) {
				
				$workdir2 = getcwd ();
				$pattern = '/\\\/';
				$replacement = '/';
				$workdir2 = preg_replace ($pattern, $replacement, $workdir2);
				
				$workdir3 = getcwd ();
				$pattern = '/\\\/';
				$replacement = '/';
				$workdir3 = preg_replace ($pattern, $replacement, $workdir3);
				
				$pattern = '/graber1/';
				$replacement = 'graber2';
				$workdir3 = preg_replace ($pattern, $replacement, $workdir3);
				
				
				print '=====================media===============' ."\n";
				
				
				
				
				
				chdir ($workdir3);
				
				if (is_dir ('c:/windows')) {	
					$system = 'start1.cmd';
				} else {
					$system = './start1';
					//$system = './start1 > '.$input_content_array[2].'.log';
				}
				
				$t = preg_split ('/\//ui', $this->array ['url']);
				if (count ($t) > 1) {
					
					// $date = getdate (time());		
					// $date1 = $date['year'];
					// $date2 = $date1--;
					
					// array_shift ($t);
					// array_shift ($t);
					// $host =  array_shift ($t);
					
					// array_pop ($t);
					// $path = array_pop ($t);
					
					// $url1 = 'https://'.$host.'/'.$path.'/games-schedule.asp?year='.$date1.'-'.$date2.'&women=0';
					// //$url2 = 'https://'.$host.'/'.$path.'/games-schedule.asp?year='.$date1.'-'.$date2.'&women=1';
					
					// $url1 = $this -> array['url'] .'fixtures/';
					// $url2 = $this -> array['url'] .'results/';
					
					$url1 = $this -> array['url'];
					
					
					$input_file = $workdir3 .'/xls/001.xls';
					$fh = fopen ($input_file, 'w') or die;

					
					fwrite ($fh, $url1. "\t". 1 . "\n");
					//fwrite ($fh, $url2. "\t". 1 . "\n");
					
					fclose ($fh);	
				}

			
				system ($system);
				chdir ($workdir2);
			}


			$this -> work_mysql_graber	-> set_state_pass ($url);
			
			
			
			
			
		} else {
			
			if (isset ($this -> work_ini_file_result ['proxy_set']) and  $this -> work_ini_file_result ['proxy_set'] == 1)  {
				
				
				if ($httpcode == 404) {
					$this -> work_mysql_graber	-> set_state_fail ($url);
				} else {
					//число попыток прокси
					$this -> work_mysql_graber	-> set_try_proxy ($proxy);
					$this -> work_mysql_graber	-> set_state_fail ($url);
				}
				
			} else {
				$this -> work_mysql_graber	-> set_state_fail ($url);
			}
			
		}	
		//print_r ($this -> proxy_array);
		return $this -> proxy_array;	
	}
	
	
}

?>
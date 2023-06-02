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
					
					print  '$proxy = ' . $proxy['proxy']."\n";
					curl_setopt($this -> ch, CURLOPT_PROXY, $proxy['proxy']);
					
				} else {
					die (print 'no proxy' ."\n");
				}
			}
		}
		
		if ($type == 'html3') {
			$headers = array
				(
					'Host: d.myscore.com.ua',
					'User-Agent: core',
					'Accept: */*',
					'Accept-Language: *',
					'X-Referer: '.$referer,
					'X-Fsign: SW9D1eZo',
					'X-Requested-With: XMLHttpRequest',
					'Referer: https://d.myscore.com.ua/x/feed/proxy-local',
				);
			
			curl_setopt($this -> ch, CURLOPT_HEADER, $headers);
			curl_setopt($this -> ch, CURLOPT_HTTPHEADER, $headers); //установка хттп заголовков		
			
		} elseif ($type == 'outa') {
			
			$headers = array
				(
					'Host: d.myscore.com.ua',
					'User-Agent: core',
					'Accept: */*',
					'Accept-Language: *',
					'X-Referer: '.$referer,
					'X-Fsign: SW9D1eZo',
					'X-Requested-With: XMLHttpRequest',
					'Referer: https://d.myscore.com.ua/x/feed/proxy-local',
				);
			
			curl_setopt($this -> ch, CURLOPT_HEADER, $headers);
			curl_setopt($this -> ch, CURLOPT_HTTPHEADER, $headers); //установка хттп заголовков		
			
		} else {
			
			$headers = array
				(
					'User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:20.0) Gecko/20100101 Firefox/20.0',
					'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
					'Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
				);
			
			curl_setopt($this -> ch, CURLOPT_HEADER, $headers);
			curl_setopt($this -> ch, CURLOPT_HTTPHEADER, $headers); //установка хттп заголовков		
		}
		
		
		
		// загрузка страницы и выдача её браузеру
		$content = curl_exec($this -> ch);		
		
		
		
		$httpcode = curl_getinfo($this -> ch, CURLINFO_HTTP_CODE);
		print $httpcode."\t".$url. "\n";
		
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


			$this -> work_mysql_graber	-> set_state_pass ($url);
			
		} else {
			
			if (isset ($this -> work_ini_file_result ['proxy_set']) and  $this -> work_ini_file_result ['proxy_set'] == 1)  {
				
				
				if ($httpcode == 404) {
					$this -> work_mysql_graber	-> set_state_fail ($url);
					
				} else {
					
					//число попыток прокси
					$this -> work_mysql_graber	-> set_try_proxy ($proxy);
					//$this -> work_mysql_graber	-> set_state_new ($url);
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
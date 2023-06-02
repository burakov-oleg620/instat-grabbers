<?php
//получение ссылок

class get_proxy_from_service {
	
	public $work_ini_file_result;
	public $work_mysql_graber;

	function __construct ($work_ini_file_result, $work_mysql_graber) {
		$this->work_ini_file_result = $work_ini_file_result;
		$this -> work_mysql_graber = $work_mysql_graber;
	}
	
	function get () {
		
		//Шаманим прокси для ИТА
		$f1 = '../../ip.txt';
		$f2 = getcwd () .'/ip.txt';
		if (is_file ($f1)) {
			copy ($f1, $f2) or die ();
		}
		
		if (is_file ($f2)) {
			$content = file_get_contents ($f2);
			$p = array ();
			$c = preg_split ('/\n+/ui', $content);
			if (count ($c) > 0) {
				foreach ($c as $key1 => $value1) {
					$value1 = str_replace (array ("\n", "\r", "\t"), '', $value1);
					if (preg_match ('/:/ui', $value1)) {
						array_push ($p, $value1);
					}
				}
			}
			
			if (count ($p) > 0) {

				shuffle ($p);
				shuffle ($p);
				shuffle ($p);
				shuffle ($p);
				shuffle ($p);
				
				$fh = fopen ($f2, 'w') or die ();
				foreach ($p as $array2_value) {
					fwrite ($fh,  $array2_value ."\n");
				}
				fclose ($fh);
			}
			
			
			if (is_file ($f2)) {
				$fh = fopen ($f2, 'r') or die ();
				while ($value = fgets ($fh)) {
					
					$value = replace ('^\s+','', $value);
					$value = replace ('\s+$','', $value);
					$value = replace ('\s.+$','', $value);
					
					
					if (preg_match ('/\d+\.\d+\.\d+\.\d+:\d+/', $value)) {
						print $value ."\n";	
					
						$insert = array ();
						$insert ['mp5str'] =  md5 ($value);
						$insert ['proxy'] = $value;
						$insert ['try'] = 0;
						$insert ['time'] = time ();
						
						$this -> work_mysql_graber -> insert_ignore_into_table_proxy ($insert);
					}
				}
				fclose ($fh);
			}
		}
		
		
		

		if (!is_file($f1)) {
			
			$ch = curl_init();
			//$cookies = getcwd () . '/cookies.txt';
			
			# добавляем заголовков к нашему запросу. Чтоб смахивало на настоящих		
			$headers = array
				(
					'User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:20.0) Gecko/20100101 Firefox/20.0',
					'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
					'Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
				);

			// установка URL и других необходимых параметров
			curl_setopt($ch, CURLOPT_HEADER, false);
			curl_setopt($ch, CURLOPT_HTTPHEADER, $headers); //установка хттп заголовков		
			curl_setopt($ch, CURLOPT_HEADER, false);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1); //редирект включен
			// curl_setopt($ch, CURLOPT_COOKIEJAR,  $cookies); 
			// curl_setopt($ch, CURLOPT_COOKIEFILE, $cookies);
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
			//curl_setopt( $ch, CURLOPT_FILE, $file);
			
			//установка нового урл
			curl_setopt($ch, CURLOPT_URL, $this->work_ini_file_result['proxy_url']);
			
			// загрузка страницы и выдача её браузеру
			$content = curl_exec($ch);		
			
			$return  = array ();
			
			$httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
			print $httpcode ."\t". $this->work_ini_file_result['proxy_url'] ."\n";

			
			//отключено!!!!!!!!!! получение прокси по ссылке
			if ($httpcode == 200) {
				
				$array2 = array ();
				$array  = preg_split ('/\n+/', $content);
				if (count ($array) > 0) {
					foreach ($array as $value) {
						
						shuffle ($array);
						shuffle ($array);
						shuffle ($array);
						shuffle ($array);
						shuffle ($array);
						
						$value = replace ('^\s+','', $value);
						$value = replace ('\s+$','', $value);
						$value = replace ('\s.+$','', $value);
						
						if (preg_match ('/\d+\.\d+\.\d+\.\d+:\d+/', $value)) {
							print $value ."\n";	
						
							$insert = array ();
							$insert ['mp5str'] =  md5 ($value);
							$insert ['proxy'] = $value;
							$insert ['try'] = 0;
							$insert ['time'] = time ();
							
							$this -> work_mysql_graber -> insert_ignore_into_table_proxy ($insert);
							array_push ($array2, $value);
						}
						
						if (count ($array2) > 0) {
							$file= getcwd () .'/ip.txt';
							$fh = fopen ($file, 'w') or die ();
							foreach ($array2 as $array2_value) {
								fwrite ($fh,  $array2_value ."\n");
							}
							fclose ($fh);
						}
					}
					
				} else {
					
					$file = getcwd () .'/ip.txt';
					if (is_file ($file)) {
						$fh = fopen ($file, 'r') or die ();
						while ($value = fgets ($fh)) {
							
							$value = replace ('^\s+','', $value);
							$value = replace ('\s+$','', $value);
							$value = replace ('\s.+$','', $value);
							
							
							if (preg_match ('/\d+\.\d+\.\d+\.\d+:\d+/', $value)) {
								print $value ."\n";	
							
								$insert = array ();
								$insert ['mp5str'] =  md5 ($value);
								$insert ['proxy'] = $value;
								$insert ['try'] = 0;
								$insert ['time'] = time ();
								
								$this -> work_mysql_graber -> insert_ignore_into_table_proxy ($insert);
							}
						}
						fclose ($fh);
					}
				
				}
				
			} else {
			
				$file= getcwd () .'/ip.txt';
				if (is_file ($file)) {
					$fh = fopen ($file, 'r') or die ();
					while ($value = fgets ($fh)) {
						
						$value = replace ('^\s+','', $value);
						$value = replace ('\s+$','', $value);
						$value = replace ('\s.+$','', $value);
						print $value ."\n";
						
						if (preg_match ('/\d+\.\d+\.\d+\.\d+:\d+/', $value)) {
							print $value ."\n";
							
							$insert = array ();
							$insert ['mp5str'] =  md5 ($value);
							$insert ['proxy'] = $value;
							$insert ['try'] = 0;
							$insert ['time'] = time ();
							
							$this -> work_mysql_graber -> insert_ignore_into_table_proxy ($insert);
						}
					}
					fclose ($fh);
				}
			}
			
			curl_close($ch);		
		}
	}
}


?>
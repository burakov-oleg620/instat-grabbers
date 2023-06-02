<?php

ini_set('date.timezone', 'Europe/Moscow');
setlocale(LC_ALL, 'ru_RU.CP1251', 'rus_RUS.CP1251', 'Russian_Russia.1251');
error_reporting(E_ALL | E_STRICT) ;
ini_set('display_errors', 'On');		
set_time_limit(0); //устанавливаем время на безлимит
flush ();


include 'work_ini_file_inc.php';
include 'work_select_file_inc.php';
include 'work_mysql_graber_inc.php';
include 'get_file_from_url_inc.php';
include 'get_url_from_content_inc.php';
include 'make_req_inc.php';
include 'put_content_to_file_inc.php';
include 'clear_dir_inc.php';
include 'count_start_inc.php';
include 'clear_str_inc.php';
include 'get_base_path_inc.php';
include 'work_for_content_inc.php';
include 'work_for_txt1_inc.php';
include 'write_text_file_rewrite_inc.php';
include 'simple_html_dom.php';
include 'get_proxy_from_service_inc.php';


$work_ini_file = new work_ini_file ('graber.ini');
$host_mysql = $work_ini_file -> get ('host_mysql');
$user = $work_ini_file -> get ('user');
$password = $work_ini_file -> get ('password');
$table = $work_ini_file -> get ('table');
$database = $work_ini_file -> get ('database');
$host = $work_ini_file -> get ('host');
$count_limit = $work_ini_file -> get ('count_limit');
$count_start_from_ini = $work_ini_file -> get ('count_start_from_ini');

$sleep1 = $work_ini_file -> get ('sleep1');
$sleep2 = $work_ini_file -> get ('sleep2');

$work_ini_file_result = $work_ini_file -> get_array ();
// print_r ($work_ini_file_result) ."\n";


 $work_mysql_graber = new work_mysql_graber ($host_mysql, $user, $password, $table, $database);

//агрегатор
//$work_mysql_graber -> drop_table_agregator (); 
//$work_mysql_graber -> create_table_agregator ();
//$work_mysql_graber -> clear_table_agregator (30);



$global_url = array ();
start1 ();



function start1 () {
	global $work_mysql_graber;
	global $global_url;
	global $host;
	global $count_limit;
	global $sleep1;
	global $sleep2;
	global $work_ini_file_result;
	
	$ch = curl_init();
	$cookies = getcwd () . '/cookies.txt';
	
	# добавляем заголовков к нашему запросу. Чтоб смахивало на настоящих		
		$headers = array
			(
				'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101 Firefox/98.0',
				//'User-Agent: '.get_useragent (),
				//'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
				//'Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
				//'Cookie: u=2t4f30iw.1l1r14.37hjs29pekc0; buyer_location_id=652200; sx=H4sIAAAAAAACA53M0Q2DIBAA0F3u2w%2FgjvNwG0AgQK2pJtXEsHt36BvgPeBDCJytUM6EWq%2BGkRU69sFQyGmF5YEvLFBtNZtFp%2B4a3fHeSmutv2Lg%2FpkxMUyQYNFMogQRZUzAyfvTHf66ipAqcZe%2BE509%2FlXOdowfhtMt6q4AAAA%3D; _ym_uid=1642888533895834713; _ym_d=1642888533; _gcl_au=1.1.1513355812.1642888533; _ga_9E363E7BES=GS1.1.1647996816.83.1.1647996983.19; _ga=GA1.2.1787466560.1642888533; __gads=ID=cfb47cf76a06e510:T=1642888532:S=ALNI_Ma6ekHZfT49a6HjrGaMgELAIbX3ww; tmr_reqNum=521; tmr_lvid=c8d7fabbd40cda707cb8605b48cb2189; tmr_lvidTS=1642980757732; _fbp=fb.1.1642980758068.1528215510; buyer_laas_location=652200; showedStoryIds=97-96-94-88-83-78-71; lastViewingTime=1647513958551; uxs_uid=c577d420-841f-11ec-92a9-017308d74436; cto_bundle=8HyGyl9hdTh3a0hvNzFSelU5c3JUelFmVTRsN2VjcEhwMlBsbThWOUdNUjJGY1pNOGpVYWM0eFRscW1hNjBPVWw4SEJlZGNRSEFIV2FRRlclMkZxSm0wdno1S2tjOVJ3JTJCdm9RcWp6enpWa1hOdWtxZmYlMkZBcnVYd0VoTE1DSnRqdGduZ0dheQ; isCriteoSetNew=true; luri=shahty; _ym_isad=2; _gid=GA1.2.1356471334.1647994755; f=5.8696cbce96d2947c36b4dd61b04726f147e1eada7172e06c47e1eada7172e06c47e1eada7172e06c47e1eada7172e06cb59320d6eb6303c1b59320d6eb6303c1b59320d6eb6303c147e1eada7172e06c8a38e2c5b3e08b898a38e2c5b3e08b890df103df0c26013a7b0d53c7afc06d0b2ebf3cb6fd35a0ac7b0d53c7afc06d0b8b1472fe2f9ba6b9ad42d01242e34c7968e2978c700f15b6831064c92d93c390fa5be3b03511ce6d04dbcad294c152cb8b1472fe2f9ba6b9ba0ac8037e2b74f9268a7bf63aa148d21d6703cbe432bc2a8b1472fe2f9ba6b97b0d53c7afc06d0b71e7cb57bbcb8e0f03c77801b122405c2da10fb74cac1eab2da10fb74cac1eab2ebf3cb6fd35a0ac20f3d16ad0b1c546cb8d4ff514f0b6b4020edee442043466f6e2929d5d3a4e78e759de1b6e2d1c4c69a0e895c25479ed9330468234c971bc525e1b3ec9e3cbd2e6b4ddffebbeebad433f0a9b173360dcb24f153e02483cfb91e52da22a560f550df103df0c26013a0df103df0c26013aaaa2b79c1ae9259505faa2cfc096ba33cfe7f009942e092f3de19da9ed218fe28732de926882853ab034d4ddab9fab148c5fd0ed95756aa9f40d61b2c0299cae; ft="bwiwnCaXrMmld2MmEdYlP9J71q7ehkYNn5uqGcbwnMnG7/Ch4HCeaMov9StJMUktrOHRd7xSCTfasujrcC8/TZCcjPIYDaTiIRRCzvamwxCgn2CXIsTEXJD4IAcNZZxKR8elC7KJnOOXU8bi/nctAudAfRt/6G9XeZafgj6AxsaoNK1EY4YyEMBYXLOGapOd"; st=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoidko0TkJ5SlU2TElJTGRDY3VNTkdBZm5PRWwySzdtS01KZXBFMDh1VUFISkRLK1poZ3YwSmwyRXYzVzN0Qy94K2NUSGVGaEZsQ1Jyc29KRVBXdVVta1ZyWWk5UzBVa1dKSTJaVk9XazJKMlJIanNZNDJ1QXIrdlgzMWJVWldFL2tTQzVnWmR3ZGczZjNTU2JzeGhlT0tBekhWNUgveEYxbDVJWTBoYXNQckRoOGdxVUVnLzZYYVhWUlRGQmFTM0xKeEc3amk1THAyMU1PMEpsWThzTWFKck03YnA0d2NpVFdpRzRpZkFsRmVIeTdRd3poZmxYbDlqQWRpM0lIdi9iSmQya3lMZEwvQUZ3TEFoSkxGWEpPWUovc3E0ZnhqZm9HZzBjZ2dmMHdnT05oaU1aRWdZNHpjSENjbzJncDhwSEwwckVIelMwa21BRmRIbFdQS3RWWHhDbnVLTGFNVVNlS25pMTU1UXpTNWkvbEd2MWdqaG9WV0tNT3FJWlNXV3dWYXdQZ3N6M0NBemUvM0kvNS9ZbWJEZC94OVA1U1daU1JWZUlYaUZFVjhmenVnbXc4aUdiVmhxSVN6MGg3S0JrUTNnYW1vNDQzUlRDSFNuSVMwM1RDdHJmY3R6Q3VobWkzN3RwbWxzT05BZVZSNit4bGFXdU5pcnRGUkphOWVocDNrWFhvTmxMQlFzek92N2tWaUI1Uld4U0x0Z2VVYy9DUnFYU0dKQThDb013aTdiOWs3WEkyWDBHSVNsUGpzaTc0bVNVUlFraUJHK3RlSnFKTjZVdWdEY3RQY1dWamxDSkhaWUVjQmpJMUY0eGRxRTFOUlpFM0JzVkxIbTZGcjQvaFFGbkdFMnFFZmdTZnN1Nm95SEN6WnpZWDdYWDVOMTcrS3RHUWFkd0lGcHNUc1VIZ2lDUEZjT29yUnlSbUdmeUNDeHdGc28wa25yODhQR1dWK2pvUitRcFRYc1Y2M2VndTFXTFlibnM3SENHak54b3NuYmFzVDlUdmZxVmlGelRHOWZIVWZsRnFvcVhRYnYvQlJlZDVrcHJVMnI5a2dzQzM0MDdvMTBpSWtPQ0YzSytRc3hnNVhQclVRQzJrMTNtcEw0WTNxT20wN1FVbFFEWHdOZjVaMlNRQnFyZGYyS1lUYVBnZ1QzVnBmV3pwTmVzU1U1T0RWcDhsSlNVZkZGdjl2djlGZ05GUnNwNEFKOGtVUW9VWmJrTWVESDBwQmZzVmhzS0xLMWs1SXVvPSIsImlhdCI6MTY0Nzk5NDgwMSwiZXhwIjoxNjQ5MjA0NDAxfQ.tO6uJ7C6HZ_eF9Rtj0q-TQ0bSTNyheyApefYo_k-9e4; abp=0; SEARCH_HISTORY_IDS=1%2C%2C4; v=1648021290',

			);

	$timeout = $work_ini_file_result['curl_timeout'];
	
	// установка URL и других необходимых параметров
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_HTTPHEADER, $headers); //установка хттп заголовков		
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1); //редирект включен

	//curl_setopt($ch, CURLOPT_COOKIEJAR,  $cookies); 
	//curl_setopt($ch, CURLOPT_COOKIEFILE, $cookies);
	//curl_setopt($ch, CURLOPT_SSLVERSION, CURL_SSLVERSION_TLSv1_0);
	//curl_setopt($ch, CURLOPT_SSLVERSION, CURL_SSLVERSION_TLSv1_1);
	//curl_setopt($ch, CURLOPT_SSLVERSION, CURL_SSLVERSION_TLSv1_2);

	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
	curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $timeout); 
	curl_setopt($ch, CURLOPT_TIMEOUT, $timeout);  	
	//curl_setopt( $ch, CURLOPT_FILE, $file);
	
	
	$proxy_array = array ();
	
	if (isset ($work_ini_file_result ['proxy_set']) and  $work_ini_file_result ['proxy_set'] == 1)  {

		$work_mysql_graber -> create_table_proxy ();
		
		$work_mysql_graber -> clear_table_proxy ($work_ini_file_result);
		
		if (isset ($work_ini_file_result ['get_proxy_from_service']) and $work_ini_file_result ['get_proxy_from_service'] == 1) {
			
			//работаем с таблицей прокси
			$work_mysql_graber -> drop_table_proxy ();
			$work_mysql_graber -> create_table_proxy ();
		
			$get_proxy_from_service = new get_proxy_from_service ($work_ini_file_result, $work_mysql_graber);
			$get_proxy_from_service_result =  $get_proxy_from_service -> get ();
			unset ($get_proxy_from_service);
		}
		
		// $insert = array ();
		// $insert ['proxy_select'] = $work_ini_file_result ['proxy_limit'] * $work_ini_file_result ['proxy_limit_k']
		// $proxy_array = $work_mysql_graber -> select_proxy_from_array ($insert);
	}

	work_1 ();
	work_2 ();

	while (count ($global_url) > 0) {

		$url  = array_shift ($global_url);
		$make_req = new make_req ($url, $host, $work_mysql_graber, $ch, $work_ini_file_result, $proxy_array);
		$proxy_array = $make_req -> make ();
		
		// Здесь задержку;
		// print '$sleep1 = '. $sleep1 ."\n";
		// print '$sleep2 = '. $sleep2 ."\n";
		
		$rand = rand ($sleep1, $sleep2);
		sleep ($rand);
		
		work_2 (); //выбираю новые ссылки из БД
	}
	

	//закрываем сеанс курл
	curl_close($ch);
	
}



function work_1 () {
	
	global $work_mysql_graber;
	global $database;
	global $table;
	
	$select1 = new work_ini_file ('select1.txt'); 
	$array = $select1 -> get_array ();
	foreach ($array as $key => $value) {
	
		$md5str = md5 ($key);
		$url = $key;
		$referer = $key;
		$select = $value;
		$content = '';
		$state = 'new';
		
		$get_file_from_url = new get_file_from_url ($url);
		$file = $get_file_from_url -> get ();
		$type = 'html';
		
		// $work_mysql_graber -> insert_ignore_into_table (
			// $url, 
			// $referer, 
			// $select,
			// $content,
			// $state,
			// $file,
			// $type
		// );
	}
}


function work_2 () {
	global $work_mysql_graber;
	global $global_url;
	global $count_start_from_ini;
	
	$array = $work_mysql_graber -> select_state_new_to_array ();
	foreach ($array as $value) {
		array_push ($global_url, $value);
		$url = $value['url'];
		$work_mysql_graber -> set_state_work ($url);
	}
	return $array;
}

function work_3 () {
	global $work_mysql_graber;
	$work_mysql_graber -> set_state_new ();
}



?> 

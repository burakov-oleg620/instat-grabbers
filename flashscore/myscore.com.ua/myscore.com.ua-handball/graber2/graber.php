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
			'User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:20.0) Gecko/20100101 Firefox/20.0',
			'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
			'Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
		);

	$timeout = $work_ini_file_result['curl_timeout'];
	
	// установка URL и других необходимых параметров
	curl_setopt($ch, CURLOPT_HEADER, $headers);
	curl_setopt($ch, CURLOPT_HTTPHEADER, $headers); //установка хттп заголовков		
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1); //редирект включен
	curl_setopt($ch, CURLOPT_COOKIEJAR,  $cookies); 
	curl_setopt($ch, CURLOPT_COOKIEFILE, $cookies);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
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

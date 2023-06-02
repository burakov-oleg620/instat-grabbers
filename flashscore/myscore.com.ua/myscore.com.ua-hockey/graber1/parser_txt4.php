<?php
ini_set('date.timezone', 'Europe/Moscow');
// ini_set('memory_limit', '8192M');

//setlocale(LC_ALL, 'ru_RU.CP1251', 'rus_RUS.CP1251', 'Russian_Russia.1251');
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
include 'put_content_to_file_inc.php';

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

//агрегатор
// $work_mysql_graber -> drop_table_agregator ();
// $work_mysql_graber -> create_table_agregator ();
// $work_mysql_graber -> clear_table_agregator (30);


$get_base_path = new get_base_path;
$workdir = $get_base_path -> get ();
$workdir2 = $workdir .'/txt';

$file0 = $workdir2.'/write_text_file_rewrite0.xls';
$file1 = $workdir2.'/write_text_file_rewrite1.xls';
$file2 = $workdir2.'/write_text_file_rewrite2.xls';
$file3 = $workdir2.'/write_text_file_rewrite3.xls';
$file4 = $workdir2.'/write_text_file_rewrite4.xls';

$workdir = $workdir .'/html';
$workdir1 = getcwd () .'/picture';
$workdir2 = getcwd () .'/picture2';

$count = 0;
// $file0_array = array ();
// $fh = fopen ($file0, 'r') or die;
// while ($str = fgets ($fh)) {
	// $clear_str = new clear_str ($str);
	// $str = $clear_str -> delete_2 ();
	// unset ($clear_str); 
	
	// //print $str ."\n";

	// if (preg_match ('/\t/', $str)) {
		// //print ++$count ."\n";
		
		// $temp1 = array ();
		// $temp1 = preg_split ('/\t/', $str);
	
		// // print '*'. count ($temp1) ."\n";
		// if (count ($temp1) > 1) {
			// foreach ($temp1 as $key => $value) {
				// $clear_str = new clear_str ($temp1[$key]);
				// $temp1[$key] = $clear_str -> delete_2 ();
				// unset ($clear_str); 
			// }
				
			// if ($temp1[0] != '-') {
				// $file0_array [$temp1[0]] = $temp1[1];
			// }
		// }
	// }
// }
// fclose ($fh);


// print_r ($file0_array) ."\n";
// die ();

$fh = fopen ($file4, 'r') or die;
while ($str = fgets ($fh)) {
	$clear_str = new clear_str ($str);
	$str = $clear_str -> delete_2 ();
	unset ($clear_str); 
	
	//print $str ."\n";

	if (preg_match ('/\t/', $str)) {
		//print ++$count ."\n";
		
		$temp1 = array ();
		$temp1 = preg_split ('/\t/', $str);
	
		// print '*'. count ($temp1) ."\n";
		if (count ($temp1) > 1) {
			foreach ($temp1 as $key => $value) {
				$clear_str = new clear_str ($temp1[$key]);
				$temp1[$key] = $clear_str -> delete_2 ();
				unset ($clear_str); 
			}
				
			if ($temp1[0] != '-') {

				// array_push ($file_array, $temp1);
				// $file_array [$temp1[0]] = $temp1;
				
				$insert = array ();
				
				$picture = $temp1[16];
				if ($picture != '-') {
					$picture_array = preg_split ('/\|\|/', $picture);
					foreach ($picture_array as $key => $value) {
						
						$picture_array [$key] = replace ('^\s+','', $picture_array [$key]);
						$picture_array [$key] = replace ('\s+$','', $picture_array [$key]);
						$picture_array [$key] = replace ('\s+',' ', $picture_array [$key]);
						
						$array = array ();
						
						$pattern1 = '/(<.+?>.+?<\/.+?>)/'; 
						$work_for_content1 = new work_for_content ($picture_array [$key]);
						$array1 = $work_for_content1 -> get_pattern ($pattern1);
						foreach ($array1[1] as $value1) {
							
							// $value1 = strip_tags1 (html_entity_decode ($value1));
							$value1 = replace ('^\s+','', $value1);
							$value1 = replace ('\s+$','', $value1);
							$value1 = replace ('\s+',' ', $value1);
							// $array ['url'] = $value1;
							
							$label = '';
							$value = '';
							
							$pattern2 = '/<([\/].+?)>/'; 
							$work_for_content2 = new work_for_content ($value1);
							$array2 = $work_for_content2 -> get_pattern ($pattern2);
							foreach ($array2[1] as $value2) {
							
								$value2 = strip_tags (html_entity_decode ($value2));
								$value2 = preg_replace ('/\//', '', $value2);
								$value2 = replace ('^\s+','', $value2);
								$value2 = replace ('\s+$','', $value2);
								$value2 = replace ('\s+','_', $value2);
								$value2 = strtolower ($value2);
								$label = $value2;
							}
							
							$pattern2 = '/^(.+)$/'; 
							$work_for_content2 = new work_for_content ($value1);
							$array2 = $work_for_content2 -> get_pattern ($pattern2);
							foreach ($array2[1] as $value2) {
							
								$value2 = strip_tags1 (html_entity_decode ($value2));
								$value2 = replace ('^\s+','', $value2);
								$value2 = replace ('\s+$','', $value2);
								$value2 = replace ('\s+',' ', $value2);
							
								$value = $value2;
							}
							if ($label != '' and $value != '') {
								$array [$label] = $value;
								$insert [$label] = $value;
							}
						}
					}
				}
				
				$insert ['url'] = $temp1[0];
				$insert ['id'] = $temp1[1];
				$insert ['img'] = $temp1[13];
				$insert ['team_id'] = $temp1[12];

				
				foreach ($insert as $key => $value) {
					if ($value == '-') {$value = '';}
					$insert [$key] = $value;
				}
				
				
				
				$a = array ();
				array_push ($a, $insert);
				
				print_r ($insert) ."\n";
				
				
				$json_str = json_encode ($a);
				//print $json_str ."\n";
				
				//post ($json_str);
				
				//array_push ($file_array, $insert);
				//$work_mysql_graber -> insert_ignore_into_table_agregator ($temp1[0], time ());
			} 
		}
	}
}
fclose ($fh);

// if (count ($file_array) > 0) {

	// $json_str = json_encode ($file_array);
	
	// // print_r ($file_array);
	// // print '$json_str = '. $json_str ."\n";
	
	// //post ($json_str);
	
	// // $write_text_file_rewrite = new write_text_file_rewrite ($file3);
	
	// // $header = array ();
	// // // array_push ($header, 'url');
	// // // array_push ($header, 'object_name');
	// // // $write_text_file_rewrite -> put_str (join ("\t", $header ) ."\n" );
	
	
	// // foreach ($file_array as $key => $value1) {
		// // $str = join ("\t", $value1);
		// // $write_text_file_rewrite -> put_str ($str ."\n");
	// // }
	// // unset ($write_text_file_rewrite);
// }



function get_param ($str, $pattern) {
	preg_match_all ($pattern, $str, $array);
	return $array;
}

function strip_tags1 ($str) {
	$str = replace ('<.+?>', ' ', $str);
	return $str;
}

function replace ($pattern1, $pattern2, $content) { 
	$pattern1 = '/'.$pattern1.'/';
	$content = preg_replace ($pattern1, $pattern2, $content);
	return $content;
}	

function post ($postdata) {
	$return = array ();	
	
	$key_import2 = '22812357092873478234729374';
	$url = 'http://data.instatfootball.tv/api/import2?key='.$key_import2.'&method=UpdateFootballResultadosMatches';
	
	$post_array = [
		'json' => $postdata,
	];
	
	$ch = curl_init($url);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
    // curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
	curl_setopt($ch, CURLOPT_POSTFIELDS, $post_array);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);	
	
	$content = curl_exec($ch);		
	$httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
	
	print $httpcode."\t".$url. "\n";
	if ($httpcode == 200) {
	
		$get_base_path = new get_base_path;
		$workdir = $get_base_path -> get ();
		unset ($get_base_path);
		
		$file = $workdir .'/txt/post_json_matches.html';
		
		$put_content_to_file = new put_content_to_file ($content, $file);
		$put_content_to_file -> put ();
		unset ($put_content_to_file);
	}
	
	return $return;
}
?>
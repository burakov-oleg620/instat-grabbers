<?php

ini_set('date.timezone', 'Europe/Moscow');
setlocale(LC_ALL, 'ru_RU.CP1251', 'rus_RUS.CP1251', 'Russian_Russia.1251');
error_reporting(E_ALL | E_STRICT) ;
ini_set('display_errors', 'On');		
set_time_limit(0); //устанавливаем время на безлимит
flush ();

$count = 0;
$count_day = 3;
$day_lockfile_delete = 2;

//$date = date("Y-m-d H:i:s");
//$date = getdate (time());

$time = time();
$lockfile = getcwd () .'/lockfile.txt';

#очистка от старого лок файла
if (is_file ($lockfile)) {
	$fh = fopen ($lockfile, 'r') or die ();
	while ($str = fgets ($fh)) {
		$temp = preg_split ('/\t/', $str);
		
		if (count ($temp) > 0) {
			foreach ($temp as $key => $value) {
				$value = str_replace (array ("\n", "\t", "\r"), '', $value);
				$value = trim ($value);
			}
			$time_lockfile = $temp[0];
		}
	}
	fclose ($fh);	

	$day = ($time - $time_lockfile) / 3600/24;
	$day = (int)$day;
	
	if ($day > $day_lockfile_delete) {
		unlink ($lockfile) or die;
	}
}



if (!is_file ($lockfile)) {

	$fh = fopen ($lockfile, 'w') or die ();
	fwrite ($fh, time () ."\t". 1);
	fclose ($fh);
	
	// $url_array = array ();
	// $time = time ();
	// while ($count_day > 0) {
	
		// $date = getdate ($time);
		// //print_r ($date);
		
		// $time = $time - 24*3600; //смотрим назад
		// //$time = $time + 24*3600; //смотрим вперед
		
		// $count_day--;
		
		// $date_0 = array ();
		// array_push ($date_0, $date['year']);
		// array_push ($date_0, $date['mon']);
		// array_push ($date_0, $date['mday']);
		
		// foreach ($date_0 as $key => $value) {
			// if (strlen ($value) < 2) {
				// $date_0 [$key] = '0'.$value;
			// }
		// }
		
		// //$url = 'http://scoresway.com/matches/'.$date_0[0].'/'.$date_0[1].'/'.$date_0[2].'/';
		// $url = 'http://www.scoresway.com/?sport=baseball&page=matches&date='.$date_0[0].'-'.$date_0[1].'-'.$date_0[2];
		// array_push ($url_array, $url);
	// }
	
	// array_push ($url_array, 1);
	// if (count ($url_array) > 0) {
		// $file = getcwd () .'/city/001.xls';
		
		// $fh = fopen ($file, 'w') or die ();
		// foreach ($url_array as $value) {
			// fwrite ($fh, $value ."\t". 1 ."\n");
		// }
		// fclose ($fh);
	// }
	
	
	$workdir0 = getcwd ();
	$workdir1 = getcwd () .'/city';
	$workdir2 = getcwd () .'/graber1';
	$workdir3 = getcwd () .'/graber2';
	

	$file_array = array ();
	$dh = opendir ($workdir1) or die;
	while ($file = readdir ($dh)) {
		if ($file != '.' and $file != '..') {
			$file = $workdir1.'/'.$file;
			$pattern = '/xls$/';
			
			if (preg_match ($pattern, $file)) {
				print ++$count ."\n";
				
				$fh = fopen ($file, 'r') or die ();
				while ($str = fgets ($fh)) {
					$str = str_replace(array("\r","\n"), '', $str);
					
					array_push ($file_array, $str);
				}
				fclose ($fh);
			}
		}
	}
	closedir ($dh);
	
	if (count ($file_array) > 0) {
		foreach ($file_array as $file_array_value) {
			$t = preg_split ('/\t/ui',$file_array_value);
			
			//graber1
			// if (is_dir ($workdir2)) {
				// chdir ($workdir2);
		
				// // $date = getdate (time());		
				
				// // $date1 = $date['year'];
				// // $date2 = $date1--;
				
				// $file = getcwd () .'/xls/001.xls';
				// $fh = fopen ($file, 'w') or die ();
				// fwrite ($fh, $t[0] ."\t". 1 . "\n");
				// fclose ($fh);
				
				// $file_start = 'start1.cmd';
				// if (is_file ($file_start) and is_dir ('c:\windows')) {
					// system  ($file_start);
				// }
				
				// $file_start = './start1';
				// if (is_file ($file_start) and !is_dir ('c:\windows')) {
					// system  ($file_start);
				// }
				
				// chdir ($workdir0);
			// }
			
			
			
			//graber2
			if (is_dir ($workdir3)) {
				chdir ($workdir3);
		
				$file = getcwd () .'/xls/001.xls';
				$fh = fopen ($file, 'w') or die ();
				fwrite ($fh, $t[0] ."\t". 1 . "\n");
				fclose ($fh);
				
				$file_start = 'start1.cmd';
				if (is_file ($file_start) and is_dir ('c:\windows')) {
					system  ($file_start);
				}
				
				$file_start = './start1';
				if (is_file ($file_start) and !is_dir ('c:\windows')) {
					system  ($file_start);
				}
				
				chdir ($workdir0);
			}
			
		}
	}

	unlink ($lockfile) or die ();
	
}

?>
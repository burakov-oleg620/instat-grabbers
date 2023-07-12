<?php

$from_db = filter_input(INPUT_GET, 'from_db', FILTER_VALIDATE_INT);

if (!is_dir ('c:/windows')) {
    if(empty($from_db) or $from_db !== 1){
	header("Content-Type: text/html; charset=utf8");
    }
} else {
	header("Content-Type: text/html; charset=utf8");
}

// Подключаем библиотеку
// require_once('PHPExcel/Classes/PHPExcel.php');
// require_once('PHPExcel/Classes/PHPExcel/Writer/Excel5.php');

// include 'clear_str_inc.php';
// include 'work_for_content_inc.php';
// include 'work_for_txt1_inc.php';

ini_set('date.timezone', 'Europe/Moscow');
//setlocale(LC_ALL, 'ru_RU.CP1251', 'rus_RUS.CP1251', 'Russian_Russia.1251');
//setlocale(LC_ALL, "Russian_Russia.1251");
//setlocale(LC_ALL, "rus");
//setlocale(LC_ALL, 'ru_RU.utf8', 'rus_RUS.ut8', 'Russian_Russia.utf8');
//setlocale(LC_ALL,"russian");
setlocale(LC_ALL, 'ru_RU.UTF-8');

error_reporting(E_ALL | E_STRICT) ;
ini_set('display_errors', 'On');		
set_time_limit(0); //устанавливаем время на безлимит
flush ();

//$form_path = '/upload.php';
$form_path = '/parser_short_data/parser_matches_xml_int_soccerway_com3/upload.php';


// echo '<!DOCTYPE html>'."\n";
// echo '<html lang="ru">'."\n";
// echo '<head>'."\n";
// //echo '<meta content="text/html; charset=Windows-1251" http-equiv="Content-Type">';
// //echo '<meta charset="Windows-1251">'."\n";
// echo '<meta http-equiv="content-type" content="text/html; charset=UTF-8" />' ."\n";
// echo '</head>'."\n";


// echo '<body>'."\n";
// echo '<table>'."\n";
// echo '<tr>'."\n";
// echo '<td>'."\n";
// echo '<a href="'.$form_path.'"> Home </a>' ."\n";
// echo '</td>'."\n";

// echo '<td width="200">'."\n";
// echo '  ' ."\n";
// echo '</td>'."\n";


// echo '<td>'."\n";
// echo '<a href="'.$form_path.'?delete=1"> Clear </a>' ."\n";
// echo '</td>'."\n";

// echo '</tr>'."\n";
// echo '</table>'."\n";


////<p><textarea name="description">Необходимо определить владеет ли ФИО квартирой по адресу "Адрес" Этаж / Этажность площадь. Если да, то квартира без ремонта? Если владеет добавляем, если нет, ошибка. </textarea></p>	
//<p><textarea name="description">1</textarea></p>



// echo '<!-- Тип кодирования данных, enctype, ДОЛЖЕН БЫТЬ указан ИМЕННО так -->




// <form enctype="multipart/form-data" action="'.$form_path.'" method="POST">


	// <h2>Загрузка файла</h2>

	// <!-- Поле MAX_FILE_SIZE должно быть указано до поля загрузки файла -->
    
    // <!-- Название элемента input определяет имя в массиве $_FILES -->
    // Отправить этот файл: <input name="userfile" type="file" />
    // <input type="submit" value="Send File" />
	
	
// </form>

// <br />
// <br />
// <hr />
// '."\n";


//print_r ($_FILES) ."\n";
//print_r ($_POST) ."\n";
// print '******' ."\n";
// print $_POST ['address'] ."\n";



//$file_in = '001.xls';
$file_in = time ().'-'.rand (1, 1000000). '.xls';
$file_in = getcwd ().'/files/'.$file_in;


// $file_out = 'phonenumber_get_fio_result.xls';
// $file_out = getcwd ().'/files/'.$file_out;

//очистка, удаление in out файлов
if (isset ($_GET['delete']) and $_GET['delete'] == 1) {
	if (is_file ($file_in)) {
		unlink  ($file_in);
	}
	
	// if (is_file ($file_out)) {
		// unlink  ($file_out);
	// }
	
	$workdir = getcwd (). '/files';
	$dh = opendir ($workdir) or die;
	while ($file = readdir ($dh)) {
		if (preg_match ('/xls$/ui', $file)) {
			$file = $workdir.'/'.$file;
			unlink  ($file);
		}
	}
}		

$all_files = array ();

//если есть URL, то обращаемся к по нему ничего не генерируя
if (
	isset ($_GET['url']) and preg_match ('/^http/ui', $_GET['url']) and 
	isset ($_GET['date']) and preg_match ('/\d{4}-\d{2}-\d{2}/ui', $_GET['date']) and 
	isset ($_GET['date']) and preg_match ('/^\d+$/ui', $_GET['id']) 
) {
	$url = trim ($_GET['url']);
	$date =  trim ($_GET['date']);
	$id =  trim ($_GET['id']);
	
	if (is_file ($file_in)) {
		unlink ($file_in) or die (print 'not unlink '.$file_in);
	}
	
	$t = array ();
	array_push ($t, $url);
	array_push ($t, $date);
	array_push ($t, $id);
	
	$all_files [$id] = $t;

	$fh = fopen ($file_in, 'w') or die ();
	foreach ($all_files as $key1 => $value1) {
		//$str = $value1 [0]. "\t".$value1[1]. "\t".$value1[2]. "\t".$value1[3];
		$str = join ("\t", $value1);
		fwrite ($fh, $str ."\n");
	}
	fclose ($fh);
	chmod ($file_in, 0664) or die (print 'chmod die');
}

print_r ($_GET) ."\n";


//если урл не установлен жестко, то его генерируем
if (
	!isset ($_GET['url']) and 
	isset ($_GET['date']) and preg_match ('/\d{4}-\d{2}-\d{2}/ui', $_GET['date']) and 
	isset ($_GET['date']) and preg_match ('/^\d+$/ui', $_GET['id']) 
) {
	
	$date =  trim ($_GET['date']);
	$id =  trim ($_GET['id']);
	
	$date_a = preg_split ('/-/ui', $date);
	//$url =  'https://int.soccerway.com/matches/2018/09/06/1/1/1/1/2780191/';
	$url =  'https://int.soccerway.com/matches/'.trim ($date_a[0]).'/'.trim ($date_a[1]).'/'.trim ($date_a[2]).'/1/1/1/1/'.$id.'/';
	
	if (is_file ($file_in)) {
		unlink ($file_in) or die (print 'not unlink '.$file_in);
	}
	
	$t = array ();
	array_push ($t, $url);
	array_push ($t, $date);
	array_push ($t, $id);
	
	$all_files [$id] = $t;


	$fh = fopen ($file_in, 'w') or die ();
	foreach ($all_files as $key1 => $value1) {
		//$str = $value1 [0]. "\t".$value1[1]. "\t".$value1[2]. "\t".$value1[3];
		$str = join ("\t", $value1);
		fwrite ($fh, $str ."\n");
	}
	fclose ($fh);
	chmod ($file_in, 0664) or die (print 'chmod die');
}




foreach ($_FILES as $key1 => $value1) {
	//print_r ($value1) ."\n";
	
	
	$name = array ();
	$file =  $value1['tmp_name'];

	if (is_file ($file)) {
	
		$pExcel = PHPExcel_IOFactory::load($file);

		// Цикл по листам Excel-файла
		foreach ($pExcel->getWorksheetIterator() as $worksheet) {
			// выгружаем данные из объекта в массив
			//$tables[] = $worksheet->toArray();}
			$str1 = $worksheet->toArray();
			
			foreach ($str1 as $key1 => $value1) {
				
				if (isset ($value1[0]) and isset ($value1[1])) {
					foreach ($value1 as $key2 => $value2) {
						$value1[$key2] = trim ($value1[$key2]);
					}
					
					if (preg_match ('/\d{4}-\d{2}-\d{2}/ui', $value1[0]) and preg_match ('/\d+/ui', $value1[1])) {
						
						$t = array ();
						
						$date = preg_split ('/-/ui', $value1[0]);
						//$url =  'https://int.soccerway.com/matches/2018/09/06/1/1/1/1/2780191/';
						$url =  'https://int.soccerway.com/matches/'.trim ($date[0]).'/'.trim ($date[1]).'/'.trim ($date[2]).'/1/1/1/1/'.$value1[1].'/';
						array_push ($t, $url);
						array_push ($t, $value1[0]);
						array_push ($t, $value1[1]);
						
						array_push ($all_files, $t);
					
					}
				}
			}
		}
	}
}



if (count ($all_files) > 0) {
	
	if (is_file ($file_in)) {
		unlink ($file_in) or die (print 'not unlink '.$file_in);
	}
	

	// echo '<h2> загрузили новый файл!!! </h2>'."\n";
	
	$fh = fopen ($file_in, 'w') or die ();
	foreach ($all_files as $key1 => $value1) {
		//$str = $value1 [0]. "\t".$value1[1]. "\t".$value1[2]. "\t".$value1[3];
		$str = join ("\t", $value1);
		fwrite ($fh, $str ."\n");
	}
	fclose ($fh);
	chmod ($file_in, 0664) or die (print 'chmod die');
}


//отображение входящего файла и его статусов
if (is_file ($file_in)) {
	
	
	// $fh = fopen ($file_in, 'r') or die (print 'die');
	
	// // echo '<p> </p>'."\n";
	// // echo '<p> </p>'."\n";
	// // echo '<h2> Входящий файл </h2>'."\n";

	// print '<table border="1">' ."\n";
	// print '<th>URL</th><th>ДАТА</th><th>ID</th>' ."\n";
	
	// while ($str = fgets ($fh)) {
	
		// $temp1 = preg_split ('/\t/', $str);
		// if (count ($temp1) > 0) {
			// print '<tr>' ."\n";
			
			// foreach ($temp1 as $key1 => $value1) {
				// $temp1[$key1] = trim ($temp1[$key1]);
			// }
			
			// print '<td>'.$temp1[0].'</td>'."\n";
			// print '<td>'.$temp1[1].'</td>' ."\n";
			// print '<td>'.$temp1[2].'</td>' ."\n";
			// // print '<td>'.$temp1[3].'</td>' ."\n";
			// // print '<td>'.$temp1[4].'</td>' ."\n";
			// // print '<td>'.$temp1[5].'</td>' ."\n";
			// // print '<td>'.$temp1[6].'</td>' ."\n";
			// // print '<td>'.$temp1[7].'</td>' ."\n";
			// print '</tr>' ."\n";
		// }
	// }
	// fclose ($fh);
	// print '</table>' ."\n";
	
	$insert = array (
		'success' => 'true',
	);
	echo json_encode ($insert);
	

} else {
	$insert = array (
		'success' => 'false',
	);
	echo json_encode ($insert);
}

// echo '</body>'."\n";
// echo '</html>'."\n";
		

		
		
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

function lower($string){
	return mb_strtolower($string,'UTF-8');
	//return mb_strtolower($string,'cp1251');
}
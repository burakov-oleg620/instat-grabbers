<?php
ini_set('date.timezone', 'Europe/Moscow');
// setlocale(LC_ALL, 'ru_RU.CP1251', 'rus_RUS.CP1251', 'Russian_Russia.1251');
setlocale(LC_ALL, 'ru_RU.UTF-8');
error_reporting(E_ALL | E_STRICT) ;
ini_set('display_errors', 'On');		
set_time_limit(0); //устанавливаем время на безлимит
flush ();


$workdir = getcwd () .'/graber/xls';
$dh = opendir ($workdir) or die;
while ($file = readdir ($dh)) {
	if ($file != '.' and $file != '..') {
		$file = $workdir.'/'.$file;
		$pattern = '/xls$/';
		// preg_match ($pattern, $file, $array);
		
		if (preg_match ($pattern, $file)) {
		
			$fh = fopen ($file, 'r') or die;
			while ($str = fgets ($fh)) {
				
				if (preg_match ('/\t/', $str)) {
					
					$temp1 = array ();
					$temp1 = preg_split ('/\t/', $str);
					
					if (count ($temp1) > 0) {
						$temp1[0] = preg_replace ('/\/$/', '', $temp1[0]);
						
						$temp2 = preg_split ('/\//', $temp1[0]);
						
						
						$date = array ();
						array_push ($date, array_pop ($temp2));
						array_push ($date, array_pop ($temp2));
						array_push ($date, array_pop ($temp2));
						
						// print_r ($date) ."\n";
						
						print '<p>Дата матча, обрабатываемого в настоящий момент: '. $date[0] .'.'. $date[1] .'.'. $date[2] .'</p>';
					}
				}
			}
			fclose ($fh);
		}
	}
}	

closedir ($dh);

$count_file = 0;
$workdir = getcwd () .'/log';

$dh = opendir ($workdir) or die;
while ($file = readdir ($dh)) {
	if ($file != '.' and $file != '..') {
		$file = $workdir.'/'.$file;
		$pattern = '/xls$/';
		// preg_match ($pattern, $file, $array);
		
		if (preg_match ($pattern, $file)) {
			$count_file++;
		}
	}
}	
closedir ($dh);
print '<p>Количество обработанных дней: '. $count_file/2 .'</p>';

?>

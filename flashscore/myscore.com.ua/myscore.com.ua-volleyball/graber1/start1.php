<?php

ini_set('date.timezone', 'Europe/Moscow');
setlocale(LC_ALL, 'ru_RU.CP1251', 'rus_RUS.CP1251', 'Russian_Russia.1251');
error_reporting(E_ALL | E_STRICT) ;
ini_set('display_errors', 'On');		
set_time_limit(0); //устанавливаем время на безлимит
flush ();


$system = 'php clear_table.php';
system ($system);

$system = 'php clear_dir.php';
system ($system);

$system = 'php work1.php';
system ($system);

$system = 'php graber.php';
system ($system);

$system = 'php parser_html1.php';
system ($system);

$system = 'php parser_html2.php';
system ($system);

$system = 'php parser_txt1.php';
system ($system);

$system = 'php parser_txt2.php';
system ($system);

?>

<?php
//класс для работы с ини файлом

class work_ini_file {
	
	public $array = array ();
	
	function __construct ($file) {
		$fh = fopen ($file,'r') or die;
		while ($str = fgets ($fh)) {
			$pattern = '/\n+/';
			$replacement = ''; 
			$str = preg_replace ($pattern, $replacement, $str); 
			
			if ($str != '') {
				$pattern = '/\'(.+?)\' = \'(.+?)\'/';
				preg_match_all ($pattern, $str, $array); 
				 while (count ($array[1]) > 0) {
					$value1 = array_shift ($array[1]); 
					$value2 = array_shift ($array[2]); 
					$this->array[$value1] = $value2; 
				 }
			}
		}
		fclose ($fh); 	
	}
	
	function get ($str) {
		if (isset ($this->array[$str])) {
			return $this->array[$str];
		} else {
			return 'not defined parametr';
		}
	}
	
	function get_array () {
		 return $this->array;
	}
	
}

?>
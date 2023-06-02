<?php
//класс для работы с файлами select

class work_select_file {
	
	public $array = array ();
	
	function __construct ($file) {
		$fh = fopen ($file,'r') or die;
		while ($str = fgets ($fh)) {
			$pattern = '/\n+/';
			$replacement = ''; 
			$str = preg_replace ($pattern, $replacement, $str); 
			$pattern = '/\r+/';
			$replacement = ''; 
			$str = preg_replace ($pattern, $replacement, $str); 			
			$pattern = '/\s+/';
			$replacement = ''; 
			$str = preg_replace ($pattern, $replacement, $str); 						
			if ($str != '') {
				array_push ($this->array, $str);
			}
		}
		fclose ($fh); 	
	}
	
	function get () {
		return $this->array;
	}
	
}

?>
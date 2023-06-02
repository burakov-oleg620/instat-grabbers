<?php
//получение имени файла

class get_file_from_url {
	
	public $url;
	public $file;
	
	function __construct ($url) {
		$this -> url = $url;
	}
	
	function get () {
		$str = $this -> url;
		$pattern = '/\//'; $replacement = '_';
		$str = preg_replace ($pattern, $replacement, $str); 
		$pattern = '/\:/'; $replacement = '_';
		$str = preg_replace ($pattern, $replacement, $str); 	
		$pattern = '/=+/'; $replacement = '_';
		$str = preg_replace ($pattern, $replacement, $str); 	
		$pattern = '/=+/'; $replacement = '_';
		$str = preg_replace ($pattern, $replacement, $str); 	
		$pattern = '/\s+/'; $replacement = '_';
		$str = preg_replace ($pattern, $replacement, $str); 	
		$pattern = '/\?/'; $replacement = '_';
		$str = preg_replace ($pattern, $replacement, $str); 		
		$this -> file = $str;
		return $str;		
	}
	
}

?>
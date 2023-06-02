<?php
//действия со строками 


class clear_str {

	public $str;
	
	function __construct ($str) {
		$this->str = $str;
	}
	
	function delete_1 () {
		$str = $this -> str;
		$pattern = '/\n+/u';
		$replacement = ''; 
		$str = preg_replace ($pattern, $replacement, $str); 
		$pattern = '/\r+/u';
		$replacement = ''; 
		$str = preg_replace ($pattern, $replacement, $str); 			
		$pattern = '/^\s+/u';
		$replacement = ''; 
		$str = preg_replace ($pattern, $replacement, $str); 						
		$pattern = '/\s+$/u';
		$replacement = ''; 
		$str = preg_replace ($pattern, $replacement, $str); 								
		return $str;
	}
	
	function delete_2 () {
		$str = $this -> str;
		$pattern = '/\n+/u';
		$replacement = ' '; 
		$str = preg_replace ($pattern, $replacement, $str); 
		$pattern = '/\r+/u';
		$replacement = ' '; 
		$str = preg_replace ($pattern, $replacement, $str); 			
		$pattern = '/^\s+/u';
		$replacement = ''; 
		$str = preg_replace ($pattern, $replacement, $str); 						
		$pattern = '/\s+$/u';
		$replacement = ''; 
		$str = preg_replace ($pattern, $replacement, $str); 								
		return $str;
	}
	
	
}
?>
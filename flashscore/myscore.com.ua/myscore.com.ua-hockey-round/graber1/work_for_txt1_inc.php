<?php
//Собирает даные в текстовый файл


class work_for_txt1 {

	public $array;
	
	function __construct () {
		$array = array (); 
		$this -> array = $array;
	}
	
	function put ($str) {
		array_push ($this->array, $str);
		return $this->array;
	}
	
	function get () {
		$str = join ("\t", $this->array); 
		return $str;
	}
	
}
?>
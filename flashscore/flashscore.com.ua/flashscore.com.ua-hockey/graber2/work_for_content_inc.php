<?php
//поиск по контенту. (может и не нужно вовсе :))


class work_for_content {

	public $str;
	
	function __construct ($str) {
		$this->str = $str;
	}
	
	function get_pattern ($pattern) {
		preg_match_all ($pattern, $this->str, $array);
		return $array;
	}
	
	
}
?>
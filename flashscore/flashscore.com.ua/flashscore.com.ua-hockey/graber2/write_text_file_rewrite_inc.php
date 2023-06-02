<?php
//запись в текстовый файл режим перезаписи

class write_text_file_rewrite {

	public $fh;
	
	function __construct ($file) {
		$fh = fopen ($file, 'w') or die;
		$this->fh = $fh;
	}
	
	function put_str ($str) {
		fwrite ($this->fh, $str); 
		return $str;
	}
	
	function __destruct () {
		fclose ($this -> fh); 
	}

}
?>
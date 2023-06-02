<?php

class put_content_to_file {
	
	public $content;
	public $file;
	
	
	function __construct ($content, $file) {
		$this -> content = $content;
		$this -> file = $file;
	}
	
	function put () {
		$fh = fopen ($this -> file, 'w') or die;
		fwrite ($fh, $this -> content);
		fclose ($fh);	
	}

}

?>


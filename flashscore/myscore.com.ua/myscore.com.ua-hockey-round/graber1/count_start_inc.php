<?php
//Ведение файлового счетчика запусков.


class count_start {

	public $workdir;
	public $file;

	
	function __construct () {
		$workdir = getcwd ();
		$pattern = '/\\\/';
		$replacement = '/';
		$workdir = preg_replace ($pattern, $replacement, $workdir);
		$this -> workdir = $workdir;
		$file = $workdir.'/count.txt';
		$this->file = $file;
	}
	
	function create_file () {
		$fh = fopen ($this->file, 'w') or die;
		//fwrite ($fh, '1' . "\n");
		fwrite ($fh, '1');
		fclose ($fh);
	}
	
	
	function get_count_from_file () {
		$count = 0;
		$fh = fopen ($this->file, 'r') or die;
		while ($str = fgets ($fh)) {
			$count++;
		} 
		fclose ($fh);
		return $count;
	}

	function put_count_to_file () {
		$file = array ();
		
		$fh = fopen ($this->file, 'r') or die;
		while ($str = fgets ($fh)) {
			$pattern = '/\n+/';
			$replacement = ''; 
			$str = preg_replace ($pattern, $replacement, $str); 
			$pattern = '/\r+/';
			$repacement = ''; 
			$str = preg_replace ($pattern, $replacement, $str); 			
			$pattern = '/\s+/';
			$replacement = ''; 
			$str = preg_replace ($pattern, $replacement, $str); 						
			if ($str != '') {
				array_push ($file, $str);
			}
		}
		fclose ($fh);
		array_push ($file, '1');
		
		$fh = fopen ($this->file, 'w') or die;
		foreach ($file as $value) {
			fwrite ($fh, $value."\n");
		}
		fclose ($fh);
	}
	
	function unlink_file () {
		unlink ($this->file) or die;
	}
	
	
	function __destruct () {
	
	}
	
}
?>
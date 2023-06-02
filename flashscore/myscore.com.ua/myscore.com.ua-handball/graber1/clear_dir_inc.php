<?php
//очистка катагов


class clear_dir {

	public $workdir;
		
	function __construct () {
		$workdir = getcwd ();
		$pattern = '/\\\/';
		$replacement = '/';
		$workdir = preg_replace ($pattern, $replacement, $workdir);
		$this -> workdir = $workdir;
	}
	
	function clear_html () {	
		$workdir = $this -> workdir .'/html';
		$dh = opendir ($workdir) or die;
		while ($file = readdir ($dh)) {
			
			if ($file != '.' and $file != '..') {
				$file = $workdir.'/'.$file;
				//print $file . "\n";
				unlink ($file) or die;
			}
		}
	}
	
	function clear_txt () {	
		$workdir = $this -> workdir .'/txt';
		$dh = opendir ($workdir) or die;
		while ($file = readdir ($dh)) {
			
			if ($file != '.' and $file != '..') {
				$file = $workdir.'/'.$file;
				print $file . "\n";
				unlink ($file) or die;
			}
		}
	}	
	
	function clear_picture () {	
		$workdir = $this -> workdir .'/picture';
		$dh = opendir ($workdir) or die;
		while ($file = readdir ($dh)) {
			
			if ($file != '.' and $file != '..') {
				$file = $workdir.'/'.$file;
				print $file . "\n";
				unlink ($file) or die;
			}
		}
	}	
	
	function clear_media () {	
		$workdir = $this -> workdir .'/media';
		$dh = opendir ($workdir) or die;
		while ($file = readdir ($dh)) {
			
			if ($file != '.' and $file != '..') {
				$file = $workdir.'/'.$file;
				print $file . "\n";
				unlink ($file) or die;
			}
		}
	}	

	function clear_pdf () {	
		$workdir = $this -> workdir .'/pdf';
		$dh = opendir ($workdir) or die;
		while ($file = readdir ($dh)) {
			
			if ($file != '.' and $file != '..') {
				$file = $workdir.'/'.$file;
				print $file . "\n";
				unlink ($file) or die;
			}
		}
	}	

	
}

?>
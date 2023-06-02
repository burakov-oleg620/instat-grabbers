<?php
//Получение текущего каталга с обработкой слэшей


class get_base_path {

	public $workdir;


	
	function __construct () {
		$workdir = getcwd ();
		$pattern = '/\\\/';
		$replacement = '/';
		$workdir = preg_replace ($pattern, $replacement, $workdir);
		$this -> workdir = $workdir;
	}
	
	function get () {
		return $this->workdir;
	}
}
?>
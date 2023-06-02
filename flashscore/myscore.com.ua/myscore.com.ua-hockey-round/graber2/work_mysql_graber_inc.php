<?php
//класс для работы с таблицей грабера

class work_mysql_graber {

	public $host; 
	public $username;
	public $password;
	public $table;
	public $database;
	public $connect;
	
    function __construct($host, $user, $password, $table, $database) {
		if ($password == ' ') {$password = '';}
		
		$connect = mysqli_connect ($host, $user, $password, $database);
		
		$this->host = $host;
        $this->user = $user;
        $this->password = $password;
		$this->table = $table;
		$this->database = $database;
		$this->connect = $connect;

		return $connect;
    }
	
	function __destruct() {
		unset ($this -> connect);
    }
	
	
	function create_table () {
		$sql  = '
			create table if not exists '.$this->table.' (
			`id` int(10) not null primary key auto_increment,
			`md5str` char (255) not null unique,
			`url` text,
			`referer` text,
			`select` text,
			`content` text,
			`state` char (10),
			`file` text, 
			`type` char (10)
		)'; 
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}
	
	function drop_table () {
		$sql  = 'drop table if exists '.$this->table; 
		$query = mysqli_query ($this -> connect, $sql);
		return 1;
	}
	
	
	function insert_ignore_into_table ($url, $referer, $select, $content, $state, $file, $type) {
		$mp5str = md5 ($url); 
		
		$sql = 'insert ignore into '.$this->table.' (
			`md5str`, 
			`url`, 
			`referer`, 
			`select`, 
			`content`,
			`state`,
			`file`, 
			`type`
			)
			value (
			"'.addslashes($mp5str).'", 
			"'.addslashes($url).'", 
			"'.addslashes($referer).'", 
			"'.addslashes($select).'", 
			"'.addslashes($content).'", 
			"'.addslashes($state).'", 
			"'.addslashes($file).'", 
			"'.addslashes($type).'" 
			)
		';
		
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}

	
	function select_state_new_to_array () {
		$state = 'new';
		$sql = 'select * from '.$this->table.' where state = "'.$state.'" limit 2';
		$query = mysqli_query ($this -> connect, $sql);		
		$array = array ();
		while ($row = mysqli_fetch_array ($query)) {
			array_push ($array, $row);
		}
		return $array;
	}	

	function set_state_work ($url) {
		$state = 'work';
		$md5str = md5 ($url);
		$sql = 'update '.$this->table.' set state = "'.$state.'" where `md5str` = "'.$md5str.'"';
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}	

	
	function set_state_pass ($url) {
		$state = 'pass';
		$md5str = md5 ($url);
		$sql = 'update '.$this->table.' set state = "'.$state.'" where `md5str` = "'.$md5str.'"';
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
	}	
	
	function set_state_fail ($url) {
		$state = 'fail';
		$md5str = md5 ($url);
		$sql = 'update '.$this->table.' set state = "'.$state.'" where `md5str` = "'.$md5str.'"';
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}	
	
	
	function set_state_new ($url) {
		$state = 'new';
		$md5str = md5 ($url);
		$sql = 'update '.$this->table.' set state = "'.$state.'" where `md5str` = "'.$md5str.'"';
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}	
	
	

	function set_fail_to_new () {
		$state1 = 'fail';
		$state2 = 'new';
		$sql = 'update '.$this->table.' set state = "'.$state2.'" where state = "'.$state1.'"';
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		
		$state1 = 'work';
		$state2 = 'new';
		$sql = 'update '.$this->table.' set state = "'.$state2.'" where state = "'.$state1.'"';
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		
		return 1;
	}		
	
	
	function select_url_po_file ($file) {
		$sql = 'select * from '.$this->table.' where `md5str` = "'.$file.'"';
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		$array = array ();
		while ($row = mysqli_fetch_array ($query)) {
			array_push ($array, $row);
		}
		return $array;
	}	
	
	
	
	


	/////////
	//proxy//
	////////
	
	function create_table_proxy () {
		$sql  = 
		'create table if not exists '.$this->table.'_proxy (
			`id` int(10) not null primary key auto_increment,
			`md5str` char (32) unique,
			`proxy` char (32),
			`try` int (11),
			`time` int (11)
		)'; 
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}
	
	function drop_table_proxy () {
		$sql  = 'drop table if exists '.$this->table.'_proxy'; 
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}
	
	
	function insert_ignore_into_table_proxy ($insert) {
		$sql = 'insert ignore into '.$this->table.'_proxy (
				`md5str`, 
				`proxy`, 
				`try`, 
				`time` 
			)
			value (
				"'.$insert ['mp5str'].'", 
				"'.$insert ['proxy'].'", 
				"'.$insert ['try'].'", 
				"'.$insert ['time'].'" 
			)
		';
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}
	
	function select_proxy_from_array ($insert) {
		$state = 'new';
		$sql = 'select * from '.$this->table.'_proxy where `try` = "0" limit '.$insert['proxy_select'];
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		$array = array ();
		while ($row = mysqli_fetch_array ($query)) {
			array_push ($array, $row);
		}
		shuffle ($array);
		shuffle ($array);
		return $array;
	}	
	
	
	function set_try_proxy ($insert) {
		$try = $insert ['try'] + 1;
		$sql = 'update '.$this->table.'_proxy set `try` = "'.$try.'" where `md5str` = "'.$insert['md5str'].'"';
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}	
	
	function clear_table_proxy ($insert) {
		$time = time () - $insert ['proxy_clear_time'] * 24*3600;
		
		$sql = 'select * from '.$this->table.'_proxy where `time` BETWEEN "0" AND '.$time;		
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";
		
		while ($row = mysqli_fetch_array ($query)) {
			$sql = 'delete from '.$this->table.'_proxy where `md5str` = "'.$row['md5str'].'"';	
			$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";
		}
		return 1;
	}	
	
	
	///////////////////////////////
	//////Работа с агрегатором////
	/////////////////////////////
	
	function create_table_agregator () {
		$sql  = '
			create table if not exists `resultadosfutbolcom_agregator` (
			`id` int(10) not null primary key auto_increment,
			`md5str` char (255) not null unique,
			`url` text,
			`time` int(11)
		)'; 
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}
	
	function drop_table_agregator () {
		$sql  = 'drop table if exists `resultadosfutbolcom_agregator`'; 
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}
	
	
	function insert_ignore_into_table_agregator ($url, $time) {
		$mp5str = md5 ($url); 
		$sql = 'insert ignore into `resultadosfutbolcom_agregator` (
			`md5str`, 
			`url`, 
			`time`
			)
			value (
			"'.$mp5str.'", 
			"'.$url.'", 
			"'.$time.'" 
			)
		';
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		return 1;
	}	
	
	function clear_table_agregator ($clear_time) {
		$time = time () - $clear_time * 24*3600;
		$sql = 'select * from `agregator` where `time` BETWEEN "0" AND '.$time;		
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		
		while ($row = mysqli_fetch_array ($query)) {
			$sql = 'delete from `agregator` where `md5str` = "'.$row['md5str'].'"';
			$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		}
		return 1;
	}	

	function select_from_agregator ($url) {
		$state = 'new';
		$mp5str = md5 ($url); 
		
		$sql = 'select * from `agregator` where `md5str` = "'.$mp5str.'"';
		$query = mysqli_query ($this -> connect, $sql) or print mysqli_errno ($this->connect).  ": " . mysqli_error($this->connect)."\n";;
		
		$array = array ();
		while ($row = mysqli_fetch_array ($query)) {
			array_push ($array, $row);
		}
		return $array;
	}	
	
}

?>
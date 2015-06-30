<?php
//ini_set('display_errors',1);
//error_reporting(E_ALL|E_STRICT);

class Crumble {
	public $crumbleIdentifier;
	public $crumbleTitle;
	public $crumbleAuthor;
	public $crumbleLong;
	public $crumbleLat;
	public $crumbleImagePath;
	public $crumbleDate;
	public $crumbleTekst;

	public function __construct($crumbleIdentifier, $crumbleTitle, $crumbleAuthor, $crumbleLong, $crumbleLat, $crumbleImagePath, $crumbleDate, $crumbleTekst) {
		$this->crumbleIdentifier = $crumbleIdentifier;
		$this->crumbleTitle = $crumbleTitle;
		$this->crumbleAuthor = $crumbleAuthor;
		$this->crumbleLong = $crumbleLong;
		$this->crumbleLat = $crumbleLat;
		$this->crumbleImagePath = $crumbleImagePath;
		$this->crumbleDate = $crumbleDate;
		$this->crumbleTekst = $crumbleTekst;
	}
}

class User {
	public $username;
	public $profilename;
	public $profileimagePath;

	public function __construct($username, $profilename, $profileimagePath) {
		$this->username = $username;
		$this->profilename = $profilename;
		$this->profileimagePath = $profileimagePath;
	}
}

$servername = "localhost";
$serverusername = "root";
$serverpassword = "greenhouse";
$dbname = "crumble";
$type = $_POST["crumble"];
//$type = "crumble";

$conn = new mysqli($servername, $serverusername, $serverpassword, $dbname);
$results = Array();

if($conn->connect_error) {
	echo $conn->connect_error;
}
else {
	if($type == "crumble") {
		$stmnt = $conn->prepare("select * from crumble");  	
	}
	else {
		$stmnt = $conn->prepare("select * from user");  
	}
}

if($stmnt->execute()) {
	
	$stmnt->store_result();
	if($type == "crumble") {
		$stmnt->bind_result($id, $title, $author, $long, $lat, $imagePath, $date, $tekst);
	//$result = $stmnt->get_result();
		while ($stmnt->fetch()) {
			$crumble = new Crumble($id, $title, $author, $long, $lat, $imagePath, $date, $tekst);
			array_push($results, $crumble);
		}
	}
	else {
		$stmnt->bind_result($username,  $profilename, $userpass, $profileimagepath);
	//$result = $stmnt->get_result();
		while ($stmnt->fetch()) {
			$user = new User($username, $profilename, $profileimagepath);
			array_push($results, $user);
		}
	}
	
}
else {
	$response = "Kon Crumble niet plaatsen";
	echo $stmnt->error;

}
$stmnt->close();
$conn->close();
echo json_encode($results);
  //echo count($crumbles);
?>
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
$servername = "localhost";
$serverusername = "root";
$serverpassword = "greenhouse";
$dbname = "crumble";

$conn = new mysqli($servername, $serverusername, $serverpassword, $dbname);
$crumbles = Array();

if($conn->connect_error) {
	echo $conn->connect_error;
}
else {
	$stmnt = $conn->prepare("select * from crumble");  
}

if($stmnt->execute()) {
	
	$stmnt->store_result();
	$stmnt->bind_result($id, $title, $author, $long, $lat, $imagePath, $date, $tekst);
	//$result = $stmnt->get_result();
	while ($stmnt->fetch()) {
		$crumble = new Crumble($id, $title, $author, $long, $lat, $imagePath, $date, $tekst);
		array_push($crumbles, $crumble);
	}
}
else {
	$response = "Kon Crumble niet plaatsen";
	echo $stmnt->error;

}
  $stmnt->close();
  $conn->close();
  echo json_encode($crumbles);
  //echo count($crumbles);
?>
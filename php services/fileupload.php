<?php
//ini_set('display_errors',1);
//error_reporting(E_ALL|E_STRICT);
$response = "";
$response2 = "";
$response = $response . $_POST["firstName"]. " -- " . $_POST["lastName"] . " -- " . $_POST["userId"];
$target_dir = "uploads/";
$encodedString = $_POST["media"];
$characters = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
$imgName = "";
for($i = 1; $i<15; $i++) {
$char = $characters[rand(0, (strlen($characters) - 1))];
  $imgName = $imgName . $char;
}
$img = imagecreatefromstring(base64_decode($encodedString));
if($img != false) {
  $success = imagejpeg($img, $target_dir.$imgName.'.jpg');
}
if($success == 1) {
  $response = "Bestand successvol geüpload";
}
else {
  $response = "Kon bestand niet upload";
}


/*
// Check if file already exists
//echo 'Target file: ' . $target_file; 
if (file_exists($target_file)) {
    $response = $response . "Sorry, file already exists.";
    $uploadOk = 0;
}
// Check file size
if ($_FILES["media"]["size"] > 500000) {
    $response = $response . "Sorry, your file is too large." ;
    $uploadOk = 0;
}
// Allow certain file formats
if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
&& $imageFileType != "gif" ) {
    $response = $response . "Sorry, only JPG, JPEG, PNG & GIF files are allowed.";
    $uploadOk = 0;
}
// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
    $response = $response . "Sorry, your file was not uploaded.";
// if everything is ok, try to upload file
} else {
    if (move_uploaded_file($_FILES["media"]["tmp_name"], $target_file)) {
        $response = $response . "The file ". basename( $_FILES["media"]["name"]). " has been uploaded.";
        // echo json_encode($response);
        //echo json_encode("yeshh");
  //       $titel = $_POST['titel'];
  //       $body = $_POST['body'];
  //       $author = $_POST['author'];
  //       $long = $_POST['long'];
  //       $lat = $_POST['lat'];
  //       $date = $_POST['date'];

  //       $servername = "localhost";
		// $serverusername = "root";
		// $serverpassword = "deregtersql";
		// $dbname = "moviecollection";

		// $conn = new mysqli($servername, $serverusername, $serverpassword, $dbname);

		// if($conn->connect_error) {
		// 	die("Connection failed: " . $conn->connect_error);
		// }
		// else {
		// 	$clientemail = $_POST['username'];
		// 	$clientpass = $_POST['password'];

		// 	$stmnt = $conn->prepare("insert into movie (titel, year, lengte, rating, description, nlsubs, type, filename) values(?,?,?,?,?,?,?,?)");
		// 	$stmnt->bind_param("siiissss", $titel, $year, $length, $rating, $omschrijving, $nlsubs, $filmofserie, $target_file);

		// 	if($stmnt->execute()) {
		// 		echo '<br/>Uploaden voltooid!<br/>';
		// 		$type = strtolower($filmofserie);
  //       		$type = $type . 's';
		// 		header("Location: ".$type.".php");
		// 	}
		// 	else{
		// 		echo '<br/>Uploaden niet gelukt!<br/>'; 
		// 		echo $stmnt->error;
		// 	}
		// 	$stmnt->close();
		// 	$conn->close();
		// }

  //       echo 'Titel: '. $titel . '<br />';
  //       echo 'Jaar: '. $year . '<br />';
  //       echo 'Lengte: '. $length . '<br />';
  //       echo 'Rating: '. $rating . '<br />';
  //       echo 'Omschrijving: '. $omschrijving . '<br />';
  //       echo 'Film of serie: '. $filmofserie . '<br />';
  //       echo 'nlsubs: '. $nlsubs . '<br />';

        
        

    } else {
        $response = $response . "Could not upload file";
        // echo json_encode($response);
    }
} */
echo json_encode($response);
?>
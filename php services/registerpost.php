<?php
// ini_set('display_errors',1);
// error_reporting(E_ALL|E_STRICT);

	$servername = "84.28.193.115";
	$serverusername = "remoteuser";
	$serverpassword = "420blaze";
	$dbname = "crumble";

	$conn = new mysqli($servername, $serverusername, $serverpassword, $dbname);

	if($conn->connect_error) {
		die("Connection failed: " . $conn->connect_error);
	}
	else {
		$clientemail = $_POST['username'];
		$clientpass = $_POST["password"];
		
		//Locale variabelen voor te testen
		//$clientemail = "karel";
		//$clientpass = "deregter";
		

		$stmnt = $conn->prepare("insert into user values(?,?)");
		$stmnt->bind_param("ss", $clientemail, $clientpass);

		$stmnt->execute();


		$stmntSelect = $conn->prepare("select * from user where username=? AND password=?");
		$stmntSelect->bind_param("ss", $clientemail, $clientpass);
		$stmntSelect->execute();
		$stmntSelect->bind_result($field1, $field2);
		
		$result = 0;

		while($stmntSelect -> fetch()) {
			$result = 1;
		}
		if($result === 1)
		{
			$succes = "Registratie gelukt!";
			echo json_encode($succes);
		}
		else {
			$succes = "Registratie mislukt!";
			echo json_encode($succes);
		}

		$stmnt->close();
		$conn->close();
	}

?>
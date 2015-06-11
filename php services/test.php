<?php
$var = $_POST["firstName"]. " -- " . $_POST["lastName"] . " -- " . $_POST["userId"];
echo json_encode($var);

?>
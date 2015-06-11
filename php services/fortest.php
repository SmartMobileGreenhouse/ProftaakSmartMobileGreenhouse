<?php
$characters = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
$imgName = "";
for($i = 1; $i<15; $i++) {
$char = $characters[rand(0, (strlen($characters) - 1))];
  $imgName = $imgName . $char;
}
echo $imgName;

?>
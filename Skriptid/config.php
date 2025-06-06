<?php

$host = "10.0.90.4";
$user = "root";
$password = "StrongPass123";
$dbname = "kasutajatugi";

$conn = new mysqli($host, $user, $password, $dbname);
if ($conn->connect_error) {
        die("ühendus ebaõnnestis: " .
$conn->connect_error);
}

?>

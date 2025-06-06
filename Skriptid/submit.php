<?php
include 'config.php';

$nimi = $_POST['nimi'];
$osakond = $_POST['osakond'];
$kontakt = $_POST['kontakt'];
$probleem = $_POST['probleem'];

if ($nimi && $osakond && $kontakt && $probleem) {
    $stmt = $conn->prepare("INSERT INTO probleemid (nimi, osakond, kontakt, probleem, staatus) VALUES (?, ?, ?, ?, 'lahendamata')");
    $stmt->bind_param("ssss", $nimi, $osakond, $kontakt, $probleem);
    $stmt->execute();
    echo "Pöördumine saadetud!";
} else {
    echo "Kõik väljad peavad olema täidetud!";
}
?>

<?php include 'config.php'; ?>
<!DOCTYPE html>
<html lang="et">
<head>
  <meta charset="UTF-8">
  <title>Kasutajatugi</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <header class="bg-primary text-white p-3 text-center">
    <h1>Kasutajatugi</h1>
  </header>

  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
      <div>
        <ul class="navbar-nav">
          <li class="nav-item"><a class="nav-link" href="index.php">Avaleht</a></li>
          <li class="nav-item"><a class="nav-link" href="uudised.php">Uudised</a></li>
          <li class="nav-item"><a class="nav-link" href="tugileht.php">Tugileht</a></li>
          <li class="nav-item"><a class="nav-link" href="kontakt.php">Kontakt</a></li>
          <li class="nav-item"><a class="nav-link" href="admin.php">Admin</a></li>
        </ul>
      </div>
    </div>
  </nav>

  <main class="container mt-4">
    <h2>Esita probleem</h2>
    <form action="submit.php" method="POST">
      <div class="mb-3">
        <label>Nimi</label>
        <input type="text" name="nimi" class="form-control" required>
      </div>
      <div class="mb-3">
        <label>Osakond</label>
        <input type="text" name="osakond" class="form-control" required>
      </div>
      <div class="mb-3">
        <label>Kontakt</label>
        <input type="text" name="kontakt" class="form-control" required>
      </div>
      <div class="mb-3">
        <label>Probleemi kirjeldus</label>
        <textarea name="probleem" class="form-control" required></textarea>
      </div>
      <button type="submit" class="btn btn-success">Saada</button>
    </form>
  </main>
</body>
</html>

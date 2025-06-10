Import-Module ActiveDirectory

$csvPath = "C:\Scriptid\kasutajad.csv"
$domainDN = "DC=oige,DC=local"
$defaultPassword = ConvertTo-SecureString "Passw0rd" -AsPlainText -Force
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
    # Kontrollib, kas 'Nimi' ja 'Osakond' on olemas
    if (-not $user.Nimi -or -not $user.Osakond) {
        Write-Warning "Puudub 'Nimi' või 'Osakond' veerg - vahele jäetud."
        continue
    }

    $userNimi = $user.Nimi

    if ([string]::IsNullOrWhiteSpace($userNimi)) {
        Write-Warning "Tühi või puudu 'Nimi' - vahele jäetud."
        continue
    }

    $userNimi = $userNimi.Trim()
    $nimeosad = $userNimi.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)

    if ($nimeosad.Count -lt 2) {
        Write-Warning "Kasutaja '$userNimi' pole formaadis 'Eesnimi Perenimi' - vahele jäetud."
        continue
    }

    $pnimi = $nimeosad[-1]
    $enimi = ($nimeosad[0..($nimeosad.Count - 2)] -join ' ')

    # Kasutajanimi väikesteks ja täpitähtedeta
    $kasutajanimi = ($enimi + "." + $pnimi).ToLower()

    # Asenda täpitähed
    $kasutajanimi = $kasutajanimi `
        -replace "ä", "a" `
        -replace "ö", "o" `
        -replace "õ", "o" `
        -replace "ü", "u" `
        -replace "š", "s" `
        -replace "ž", "z"

    $ounimi = $user.Osakond.Trim()
    $ouDN = "OU=$ounimi,$domainDN"

    # Kontroll kas OU eksisteerib
    $ouCheck = Get-ADOrganizationalUnit -LDAPFilter "(ou=$ounimi)" -SearchBase $domainDN -ErrorAction SilentlyContinue
    if (-not $ouCheck) {
        try {
            New-ADOrganizationalUnit -Name $ounimi -Path $domainDN -ErrorAction Stop
            Write-Host "OU '$ounimi' loodud."
        }
        catch {
            Write-Warning "OU '$ounimi' loomine ebaõnnestus: $_"
            continue
        }
    }

    # Kontroll kas kasutaja eksisteerib

    if (Get-ADUser -Filter "SamAccountName -eq '$kasutajanimi'" -ErrorAction SilentlyContinue) {
        Write-Warning "Kasutaja '$kasutajanimi' juba eksisteerib - vahele jäetud."
        continue
    }

    # Loo kasutaja
    try {
        New-ADUser `
            -Name "$enimi $pnimi" `
            -GivenName $enimi `
            -Surname $pnimi `
            -SamAccountName $kasutajanimi `
            -UserPrincipalName "$kasutajanimi@oige.local" `
            -AccountPassword $defaultPassword `
            -ChangePasswordAtLogon $true `
            -Enabled $true `
            -Path $ouDN

        Write-Host "Kasutaja '$kasutajanimi' loodud OU-sse '$ounimi'"
    }
    catch {
        Write-Error "Viga kasutaja '$kasutajanimi' loomisel: $_"
    }
}

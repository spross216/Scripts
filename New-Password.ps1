



$password = invoke-RestMethod -Uri "Https://www.dinopass.com/password/strong" -Method GET
$formatPassword = [PSCustomObject]@{
    Password = $password
}
$formatPassword | Format-Table

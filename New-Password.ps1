[CmdletBinding()]
param ()

Invoke-RestMethod -Uri "Https://www.dinopass.com/password/strong" -Method GET 

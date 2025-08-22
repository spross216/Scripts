$Logging     = @( Get-ChildItem -Path $PSScriptRoot\Functions\Logging\*.ps1 -ErrorAction SilentlyContinue )
$Private     = @( Get-ChildItem -Path $PSScriptRoot\Functions\Private\*.ps1 -ErrorAction SilentlyContinue )
$Public      = @( Get-ChildItem -Path $PSScriptRoot\Functions\Public\*.ps1 -ErrorAction SilentlyContinue )


foreach ($Import in @($Logging + $Private + $Public)) 
{
    try 
    {
        . $Import.FullName
    }     
    catch 
    {
        Write-Error -Message "Failed to import function $($Import.FullName): $_" # placeholder for new error handler
    }
}


Export-ModuleMember -Function $Public.BaseName 

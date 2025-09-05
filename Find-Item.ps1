<#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
#>

[CmdletBinding()]
param ([parameter(mandatory=$true)][string]$Query)


$files = Get-ChildItem -Path .\* -Recurse | Select-String -Pattern $Query | Select-Object -ExpandProperty Path -Unique 

if (-not $files)
{
    return "'$Query' not found in current project directory"
}

edit $files 
<#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
#>


[CmdletBinding()]
param (
    [parameter(mandatory=$true)][string]$Path,
    [string]$Filter
)


if (-not (Test-Path $Path))
{
    return "'$Path' is not a valid directory"
}


if ($Filter)
{
    $files = Get-ChildItem -Path $Path -Recurse -Filter $Filter
} 
else
{
    $files = Get-ChildItem -Path $Path -Recurse
}

edit $files

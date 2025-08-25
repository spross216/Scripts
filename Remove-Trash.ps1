[CmdletBinding()]
param (
    [String[]]$TrashcanDirectories = @(
        "%USERPROFILE%\Desktop",
        "%USERPOFILE%\Downloads",
        "%USERPROFILE\Pictures\Screenshots"
    )
)

$deletedFiles = @()
foreach ($trashcan in $trashcanDirectories)
{
    try
    {
        $stagedItems = Get-ChildItem -Path $trashcan -Recurse | Remove-Item -Force -ErrorAction Stop
        $deletedItems = $stagedItems | Where-Object { $_.Exists -eq $false }
        $deletedFiles += $deletedItems.FullName
        Write-Host "Number of files deleted in $($trashcan): $($deletedFiles.Count)"

        if (-not $deletedFiles)
        {
            Write-Host "No files were deleted in $trashcan"
        }

        Write-Host "Deleted files:"
        $deletedFiles | Format-Table -AutoSize Path
    }
    catch
    {
        Throw "[!] Error: `n$($_.Exception.Message)"                
    }
}


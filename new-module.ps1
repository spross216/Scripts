<#
.SYNOPSIS
    Initializes a new PowerShell module project with a standard folder structure, Git repository, and template files
.PARAMETER Path
    The directory path where the project will be created
.PARAMETER ProjectName
    The name of the PowerShell module
.PARAMETER RemoteRepo
    The Url of the remote Git repository
.Example
    $project = @{
        Path = "C:\Projects\MyModule",
        ProjectName = "MyModule",
        RemoteRepo = "https://github.com/user/MyModule.git"
    }
    ./New-Module.ps1 @project
#>

[CmdletBinding()]
param (
    [parameter(mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Path,

    [parameter(mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$ProjectName,


    [parameter(mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$RemoteRepo
)


# Create an error handling wrapper that can be piped into 
function Invoke-WithErrorHandling
{
    param (
        [Parameter(mandatory=$true)]
        [string]$Context,

        [Parameter(mandatory=$true)]
        [ScriptBlock]$Script
    )

  
    try
    {
        & $Script
    }
    catch
    {
        Write-Error "`n[!] Error during: $Context`n$($_.Exception.Message)`n"
        Exit 1
    }
}


# see if the path already exists. If it does, exit the script
if (Test-Path $Path)
{
    Write-Error "[!] Error: The specified path '$Path' already exists..."
    Exit 1 
}

# validate the template files exist and are in $PSScriptRoot. If they do not, exit the script 
if (-not (Test-Path "$PSScriptRoot\template.psm1") -or -not (Test-Path "$PSScriptRoot\template.psd1"))
{
    Write-Error "[!] Error: Template files (template.psm1 or template.psd1) not found in $PSScriptRoot"
    Exit 1
}

$toDo = "create the project directory specified in the Path parameter and cd to it" 
Invoke-WithErrorHandling -Context $toDo -Script {
    New-Item -ItemType Directory -Path $Path
    Set-Location $Path 
}
Write-Verbose "[*] Created and navigated to new project directory: $Path"


$todo =  "initialize the git repository"
$output = Invoke-WithErrorHandling -Context $todo -Script {
    & { git init 2>&1 } | Out-String
}
Write-Verbose "[*] Initialized git repository: `n$output`n"


$todo = "add the remote repository"
$output = Invoke-WithErrorHandling -Context $todo -Script {
    & { git remote add origin $RemoteRepo 2>&1 } | Out-String
}
Write-Verbose "[*] Added remote repository: `n$output`n"


$todo = "create the minimum folder structure"
Invoke-WithErrorHandling -Context $todo -Script {
    $newFolders = @(
        ".\Help",
        ".\Functions",
        ".\Functions\Logging",
        ".\Functions\Private",
        ".\Functions\Public",
    )
    New-Item -ItemType Directory -Path $newFolders
}
Write-Verbose "[*] Created project directory structure"


$todo = "Create the module manifest, module file and README"
Invoke-WithErrorHandling -Context $todo -Script {
    $newFiles = @(
        "$ProjectName.psm1",
        "$ProjectName.psd1",
        "README.MD"
    )
    New-Item -ItemType File -Name $newFiles
    Get-Content $PSScriptRoot\template.psm1 | Set-Content "$ProjectName.psm1"
    Get-Content $PSScriptRoot\template.psd1 | Set-Content "$ProjectName.psd1"
    "# $ProjectName`nA PowerShell module for [description]" | Set-Content ".\README.MD"
}
Write-Verbose "[*] Created project files: `n"
Get-ChildItem


$todo = "Stage project changes"
$output = Invoke-WithErrorHandling -Context $todo -Script {
    & { git add . 2>&1 } | Out-String
}
Write-Verbose "[*] Staged changes: `n$output"


$todo = "Commit staged changes"
$output = Invoke-WithErrorHandling -Context $todo -Script {
    & { git commit -m "Project init" 2>&1 } | Out-String
}
Write-Verbose "[*] Commited changes: `n$output"


$todo = "Push to remote repository"
$output = Invoke-WithErrorHandling -Context $todo -Script {
    & { git push origin 2>&1 } | Out-String
}
Write-Verbose "[*] Commited changes: `n$output"


$todo = "Open project in Helix"
Invoke-WithErrorHandling -Context $todo -Script { hx . } 

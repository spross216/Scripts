# Silent SCCM Client Removal Script for RMM

Stop-Service -Name CcmExec -Force -ErrorAction SilentlyContinue

$ccmSetupPath = "C:\Windows\CCMSetup\ccmsetup.exe"
if (Test-Path $ccmSetupPath) {
    & $ccmSetupPath /uninstall
    Start-Sleep -Seconds 30
}

$Sccm = @(
    "C:\Windows\CCM",
    "C:\Windows\CCMSetup",
    "C:\Windows\ccmcache",
    "HKLM:\SOFTWARE\Microsoft\CCM",
    "HKLM:\SOFTWARE\Microsoft\CCMSetup",
    "HKLM:\SOFTWARE\Microsoft\SMS",
)

Remove-Item -Path $Sccm -Recurse -Force -ErrorAction SilentlyContinue
Get-ScheduledTask | Where-Object {$_.TaskName -like "*CCM*"} | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue

# Silent SCCM Client Removal Script for RMM

Stop-Service -Name CcmExec -Force -ErrorAction SilentlyContinue

$ccmSetupPath = "C:\Windows\CCMSetup\ccmsetup.exe"
if (Test-Path $ccmSetupPath) {
    & $ccmSetupPath /uninstall
    Start-Sleep -Seconds 30
}

Remove-Item -Path "C:\Windows\CCM" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\CCMSetup" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\ccmcache" -Recurse -Force -ErrorAction SilentlyContinue

Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\CCM" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\CCMSetup" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\SMS" -Recurse -Force -ErrorAction SilentlyContinue

Get-ScheduledTask | Where-Object {$_.TaskName -like "*CCM*"} | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue

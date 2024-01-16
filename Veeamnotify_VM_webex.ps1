Start-Sleep -Seconds 20

$webhookUrlVM = "https://webexapis.com/v1/webhooks/incoming/ID webhook webex"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


$LastVMSession = Get-VBRBackupSession | Sort-Object CreationTime -Descending | Select-Object -First 1
$VMBackupDuration = $LastVMSession.EndTime - $LastVMSession.CreationTime
$VMBackupDurationFormatted = '{0:D2}:{1:D2}:{2:D2}' -f $VMBackupDuration.Hours, $VMBackupDuration.Minutes, $VMBackupDuration.Seconds


$jsonDataVM = @{
    "markdown" = @"
**Backup Sessions:**

- **Type:** VM
- **Job Name:** $($LastVMSession.Name)
- **CreationTime:** $($LastVMSession.CreationTime)
- **EndTime:** $($LastVMSession.EndTime)
- **Duration:** $VMBackupDurationFormatted
- **Result:** $($LastVMSession.Result)
- **State:** $($LastVMSession.State)
"@
} | ConvertTo-Json


Invoke-RestMethod -Uri $webhookUrlVM -Method Post -Body $jsonDataVM -ContentType "application/json"

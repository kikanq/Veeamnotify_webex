Start-Sleep -Seconds 20


$webhookUrlPM = "https://webexapis.com/v1/webhooks/incoming/webex webhook ID"


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


$LastPMSession = Get-VBRComputerBackupJobSession | Sort-Object EndTime -Descending | Select-Object -First 1


$PBackup_job_name = (Get-VBRComputerBackupJob | Where-Object {$_.Id -eq $LastPMSession.JobId}).Name


$jsonDataPM = @{
    "markdown" = @"
**Last sessions PM:**

- **Type:** PM
- **Job Name:** $($PBackup_job_name)
- **Creation Time:** $($LastPMSession.CreationTime)
- **End Time:** $($LastPMSession.EndTime)
- **Duration:** $PMBackupDurationFormatted
- **Result:** $($LastPMSession.Result)
- **State:** $($LastPMSession.State)
"@
} | ConvertTo-Json


Invoke-RestMethod -Uri $webhookUrlPM -Method Post -Body $jsonDataPM -ContentType "application/json"
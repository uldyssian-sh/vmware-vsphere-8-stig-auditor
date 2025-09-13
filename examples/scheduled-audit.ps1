# Scheduled STIG Audit with Windows Task Scheduler Integration
# Run daily compliance checks and maintain audit history

param(
    [Parameter(Mandatory)]
    [string]$VCenter,
    
    [string]$CredentialPath = "$env:USERPROFILE\stig-audit-creds.xml",
    [string]$HistoryPath = ".\audit-history",
    [int]$RetentionDays = 30,
    [string]$EmailConfig = ".\email-config.json"
)

# Create history directory
if (-not (Test-Path $HistoryPath)) {
    New-Item -Path $HistoryPath -ItemType Directory -Force
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$date = Get-Date -Format "yyyy-MM-dd"

Write-Host "Starting scheduled STIG audit for $VCenter" -ForegroundColor Green

try {
    # Load stored credentials
    if (Test-Path $CredentialPath) {
        $credential = Import-Clixml -Path $CredentialPath
        $username = $credential.UserName
        $password = $credential.Password
    } else {
        Write-Error "Credential file not found: $CredentialPath"
        Write-Host "Create credentials with: Get-Credential | Export-Clixml -Path '$CredentialPath'"
        exit 1
    }
    
    # Run audit
    Write-Host "Executing STIG compliance audit..." -ForegroundColor Cyan
    $auditScript = Join-Path $PSScriptRoot ".." "vsphere8-stig-auditor.ps1"
    
    # Capture both output and results
    $results = & $auditScript -VCenter $VCenter -Username $username -Password $password
    
    # Save detailed results
    $detailFile = Join-Path $HistoryPath "stig-audit-$date-$timestamp.csv"
    $results | Export-Csv -Path $detailFile -NoTypeInformation
    
    # Generate summary
    $summary = @{
        Date = Get-Date
        VCenter = $VCenter
        Total = $results.Count
        Pass = ($results | Where-Object Status -eq 'Pass').Count
        Fail = ($results | Where-Object Status -eq 'Fail').Count
        Warn = ($results | Where-Object Status -eq 'Warn').Count
        Info = ($results | Where-Object Status -eq 'Info').Count
        CompliancePercentage = [math]::Round((($results | Where-Object Status -eq 'Pass').Count / $results.Count) * 100, 2)
    }
    
    # Save summary to history
    $summaryFile = Join-Path $HistoryPath "audit-summary.json"
    $history = @()
    
    if (Test-Path $summaryFile) {
        $history = Get-Content $summaryFile | ConvertFrom-Json
    }
    
    $history += $summary
    $history | ConvertTo-Json | Out-File -FilePath $summaryFile -Encoding UTF8
    
    # Display current summary
    Write-Host "`n=== AUDIT SUMMARY ===" -ForegroundColor Green
    Write-Host "Date: $($summary.Date)"
    Write-Host "vCenter: $($summary.VCenter)"
    Write-Host "Compliance: $($summary.CompliancePercentage)% ($($summary.Pass)/$($summary.Total))"
    Write-Host "Pass: $($summary.Pass)" -ForegroundColor Green
    Write-Host "Fail: $($summary.Fail)" -ForegroundColor Red
    Write-Host "Warn: $($summary.Warn)" -ForegroundColor Yellow
    Write-Host "Info: $($summary.Info)" -ForegroundColor Blue
    
    # Check for compliance degradation
    if ($history.Count -gt 1) {
        $previous = $history[-2]
        $current = $history[-1]
        
        if ($current.CompliancePercentage -lt $previous.CompliancePercentage) {
            Write-Warning "Compliance decreased from $($previous.CompliancePercentage)% to $($current.CompliancePercentage)%"
            $alertRequired = $true
        } elseif ($current.Fail -gt $previous.Fail) {
            Write-Warning "Failed controls increased from $($previous.Fail) to $($current.Fail)"
            $alertRequired = $true
        }
    }
    
    # Send email notification if configured
    if ((Test-Path $EmailConfig) -and ($summary.Fail -gt 0 -or $alertRequired)) {
        try {
            $emailSettings = Get-Content $EmailConfig | ConvertFrom-Json
            
            $subject = "STIG Compliance Alert - $VCenter ($($summary.Fail) failures)"
            $body = @"
vSphere 8 STIG Compliance Report

vCenter: $VCenter
Date: $($summary.Date)
Compliance: $($summary.CompliancePercentage)%

Results:
- Pass: $($summary.Pass)
- Fail: $($summary.Fail)
- Warn: $($summary.Warn)
- Info: $($summary.Info)

Detailed report: $detailFile
"@
            
            Send-MailMessage -To $emailSettings.To -From $emailSettings.From -Subject $subject -Body $body -SmtpServer $emailSettings.SmtpServer -Attachments $detailFile
            Write-Host "Email notification sent" -ForegroundColor Green
            
        } catch {
            Write-Warning "Failed to send email notification: $($_.Exception.Message)"
        }
    }
    
    # Cleanup old files
    Write-Host "Cleaning up files older than $RetentionDays days..." -ForegroundColor Yellow
    $cutoffDate = (Get-Date).AddDays(-$RetentionDays)
    Get-ChildItem -Path $HistoryPath -Filter "stig-audit-*.csv" | 
        Where-Object { $_.CreationTime -lt $cutoffDate } | 
        Remove-Item -Force
    
    Write-Host "Scheduled audit completed successfully" -ForegroundColor Green
    
} catch {
    Write-Error "Scheduled audit failed: $($_.Exception.Message)"
    
    # Log error
    $errorLog = Join-Path $HistoryPath "audit-errors.log"
    "$(Get-Date): $($_.Exception.Message)" | Add-Content -Path $errorLog
    
    exit 1
}

# Example Windows Task Scheduler command:
# schtasks /create /tn "vSphere STIG Audit" /tr "powershell.exe -File C:\Scripts\scheduled-audit.ps1 -VCenter vcenter.company.com" /sc daily /st 06:00
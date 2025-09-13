# Automated STIG Compliance Reporting Example
# Generates HTML and CSV reports with email notifications

param(
    [Parameter(Mandatory)]
    [string]$VCenter,
    
    [string]$ReportPath = ".\reports",
    [string]$EmailTo,
    [string]$EmailFrom,
    [string]$SmtpServer
)

# Create reports directory
if (-not (Test-Path $ReportPath)) {
    New-Item -Path $ReportPath -ItemType Directory -Force
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$reportName = "STIG-Compliance-$timestamp"

# Capture audit results
Write-Host "Running STIG compliance audit..." -ForegroundColor Green
$auditResults = & "$PSScriptRoot\..\vsphere8-stig-auditor.ps1" -VCenter $VCenter

# Generate CSV report
$csvPath = Join-Path $ReportPath "$reportName.csv"
$auditResults | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "CSV report saved: $csvPath" -ForegroundColor Cyan

# Generate HTML report
$htmlPath = Join-Path $ReportPath "$reportName.html"
$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>vSphere 8 STIG Compliance Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background-color: #2c3e50; color: white; padding: 20px; text-align: center; }
        .summary { background-color: #ecf0f1; padding: 15px; margin: 20px 0; border-radius: 5px; }
        .pass { color: #27ae60; font-weight: bold; }
        .fail { color: #e74c3c; font-weight: bold; }
        .warn { color: #f39c12; font-weight: bold; }
        .info { color: #3498db; font-weight: bold; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #34495e; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <div class="header">
        <h1>vSphere 8 STIG Compliance Report</h1>
        <p>Generated: $(Get-Date)</p>
        <p>vCenter: $VCenter</p>
    </div>
    
    <div class="summary">
        <h2>Compliance Summary</h2>
        <p><span class="pass">Pass: $($auditResults | Where-Object Status -eq 'Pass' | Measure-Object | Select-Object -ExpandProperty Count)</span></p>
        <p><span class="fail">Fail: $($auditResults | Where-Object Status -eq 'Fail' | Measure-Object | Select-Object -ExpandProperty Count)</span></p>
        <p><span class="warn">Warn: $($auditResults | Where-Object Status -eq 'Warn' | Measure-Object | Select-Object -ExpandProperty Count)</span></p>
        <p><span class="info">Info: $($auditResults | Where-Object Status -eq 'Info' | Measure-Object | Select-Object -ExpandProperty Count)</span></p>
    </div>
    
    <h2>Detailed Results</h2>
    <table>
        <tr>
            <th>Status</th>
            <th>Scope</th>
            <th>Component</th>
            <th>Rule ID</th>
            <th>Expectation</th>
            <th>Observed</th>
            <th>Notes</th>
        </tr>
"@

foreach ($result in $auditResults | Sort-Object Status, Scope, Component) {
    $statusClass = $result.Status.ToLower()
    $html += @"
        <tr>
            <td><span class="$statusClass">$($result.Status)</span></td>
            <td>$($result.Scope)</td>
            <td>$($result.Component)</td>
            <td>$($result.RuleId)</td>
            <td>$($result.Expectation)</td>
            <td>$($result.Observed)</td>
            <td>$($result.Notes)</td>
        </tr>
"@
}

$html += @"
    </table>
</body>
</html>
"@

$html | Out-File -FilePath $htmlPath -Encoding UTF8
Write-Host "HTML report saved: $htmlPath" -ForegroundColor Cyan

# Send email notification if configured
if ($EmailTo -and $EmailFrom -and $SmtpServer) {
    try {
        $failCount = ($auditResults | Where-Object Status -eq 'Fail').Count
        $subject = "vSphere STIG Compliance Report - $failCount Failures"
        
        $body = @"
vSphere 8 STIG Compliance Report

vCenter: $VCenter
Generated: $(Get-Date)

Summary:
- Pass: $($auditResults | Where-Object Status -eq 'Pass' | Measure-Object | Select-Object -ExpandProperty Count)
- Fail: $($auditResults | Where-Object Status -eq 'Fail' | Measure-Object | Select-Object -ExpandProperty Count)
- Warn: $($auditResults | Where-Object Status -eq 'Warn' | Measure-Object | Select-Object -ExpandProperty Count)
- Info: $($auditResults | Where-Object Status -eq 'Info' | Measure-Object | Select-Object -ExpandProperty Count)

Detailed reports are attached.
"@

        Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $subject -Body $body -SmtpServer $SmtpServer -Attachments $csvPath, $htmlPath
        Write-Host "Email notification sent to $EmailTo" -ForegroundColor Green
        
    } catch {
        Write-Warning "Failed to send email notification: $($_.Exception.Message)"
    }
}

Write-Host "`nReporting completed successfully!" -ForegroundColor Green
Write-Host "Reports saved in: $ReportPath" -ForegroundColor Cyan
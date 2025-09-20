# Bulk STIG Audit for Multiple vCenter Servers
# Audits multiple vCenter environments and consolidates results

param(
    [Parameter(Mandatory)]
    [string]$ConfigFile = "vcenter-list.csv",
    
    [string]$OutputPath = ".\bulk-audit-results",
    [int]$MaxConcurrent = 3
)

# Validate config file exists
if (-not (Test-Path $ConfigFile)) {
    Write-Error "Configuration file not found: $ConfigFile"
    Write-Host "Expected CSV format:"
    Write-Host "VCenter,Username,Description"
    Write-Host "vcenter1.company.com,auditor@vsphere.local,Production Environment"
    Write-Host "vcenter2.company.com,auditor@vsphere.local,Development Environment"
    exit 1
}

# Create output directory
if (-not (Test-Path $OutputPath)) {
    New-Item -Path $OutputPath -ItemType Directory -Force
}

# Load vCenter configuration
$vCenters = Import-Csv -Path $ConfigFile
Write-Host "Loaded $($vCenters.Count) vCenter servers for audit" -ForegroundColor Green

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$consolidatedResults = @()

# Process each vCenter
$vCenters | ForEach-Object -ThrottleLimit $MaxConcurrent -Parallel {
    $vCenter = $_.VCenter
    $username = $_.Username
    $description = $_.Description
    $outputPath = $using:OutputPath
    $timestamp = $using:timestamp
    
    try {
        Write-Host "Processing $vCenter ($description)..." -ForegroundColor Cyan
        
        # Get credentials (in real scenario, use secure credential storage)
        $password = Read-Host "Enter password for $username at $vCenter" -AsSecureString
        
        # Run audit
        $results = & "$using:PSScriptRoot\..\vmware-vsphere-8-stig-auditor.ps1" -VCenter $vCenter -Username $username -Password $password
        
        # Add environment info to results
        $results | ForEach-Object {
            $_ | Add-Member -NotePropertyName "Environment" -NotePropertyValue $description
            $_ | Add-Member -NotePropertyName "VCenterServer" -NotePropertyValue $vCenter
        }
        
        # Save individual results
        $individualFile = Join-Path $outputPath "STIG-Audit-$($vCenter.Replace('.', '-'))-$timestamp.csv"
        $results | Export-Csv -Path $individualFile -NoTypeInformation
        
        Write-Host "✓ Completed $vCenter - Results saved to $individualFile" -ForegroundColor Green
        
        return $results
        
    } catch {
        Write-Error "Failed to audit $vCenter : $($_.Exception.Message)"
        
        # Create error record
        return [PSCustomObject]@{
            Environment = $description
            VCenterServer = $vCenter
            Scope = $vCenter
            Component = "Connection"
            RuleId = "ERROR"
            Status = "Fail"
            Expectation = "Successful connection and audit"
            Observed = "Connection failed: $($_.Exception.Message)"
            Notes = "Audit could not be completed"
        }
    }
}

# Consolidate all results
Write-Host "`nConsolidating results..." -ForegroundColor Yellow
$consolidatedFile = Join-Path $OutputPath "STIG-Audit-Consolidated-$timestamp.csv"
$consolidatedResults | Export-Csv -Path $consolidatedFile -NoTypeInformation

# Generate summary report
$summary = @{}
foreach ($env in ($consolidatedResults | Group-Object Environment)) {
    $envName = $env.Name
    $envResults = $env.Group
    
    $summary[$envName] = @{
        Total = $envResults.Count
        Pass = ($envResults | Where-Object Status -eq 'Pass').Count
        Fail = ($envResults | Where-Object Status -eq 'Fail').Count
        Warn = ($envResults | Where-Object Status -eq 'Warn').Count
        Info = ($envResults | Where-Object Status -eq 'Info').Count
    }
}

# Display summary
Write-Host "`n=== BULK AUDIT SUMMARY ===" -ForegroundColor Green
foreach ($env in $summary.Keys) {
    Write-Host "`n$env :" -ForegroundColor Cyan
    Write-Host "  Total: $($summary[$env].Total)"
    Write-Host "  Pass : $($summary[$env].Pass)" -ForegroundColor Green
    Write-Host "  Fail : $($summary[$env].Fail)" -ForegroundColor Red
    Write-Host "  Warn : $($summary[$env].Warn)" -ForegroundColor Yellow
    Write-Host "  Info : $($summary[$env].Info)" -ForegroundColor Blue
}

# Generate HTML dashboard
$dashboardPath = Join-Path $OutputPath "STIG-Dashboard-$timestamp.html"
$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>vSphere STIG Compliance Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background-color: #2c3e50; color: white; padding: 20px; text-align: center; }
        .environment { background-color: #ecf0f1; margin: 20px 0; padding: 15px; border-radius: 5px; }
        .metrics { display: flex; justify-content: space-around; margin: 10px 0; }
        .metric { text-align: center; padding: 10px; }
        .pass { background-color: #d5f4e6; color: #27ae60; }
        .fail { background-color: #fadbd8; color: #e74c3c; }
        .warn { background-color: #fdeaa7; color: #f39c12; }
        .info { background-color: #d6eaf8; color: #3498db; }
    </style>
</head>
<body>
    <div class="header">
        <h1>vSphere STIG Compliance Dashboard</h1>
        <p>Generated: $(Get-Date)</p>
        <p>Environments Audited: $($summary.Keys.Count)</p>
    </div>
"@

foreach ($env in $summary.Keys) {
    $s = $summary[$env]
    $html += @"
    <div class="environment">
        <h2>$env</h2>
        <div class="metrics">
            <div class="metric pass">
                <h3>$($s.Pass)</h3>
                <p>Pass</p>
            </div>
            <div class="metric fail">
                <h3>$($s.Fail)</h3>
                <p>Fail</p>
            </div>
            <div class="metric warn">
                <h3>$($s.Warn)</h3>
                <p>Warn</p>
            </div>
            <div class="metric info">
                <h3>$($s.Info)</h3>
                <p>Info</p>
            </div>
        </div>
    </div>
"@
}

$html += "</body></html>"
$html | Out-File -FilePath $dashboardPath -Encoding UTF8

Write-Host "`nBulk audit completed!" -ForegroundColor Green
Write-Host "Consolidated results: $consolidatedFile" -ForegroundColor Cyan
Write-Host "Dashboard: $dashboardPath" -ForegroundColor Cyan
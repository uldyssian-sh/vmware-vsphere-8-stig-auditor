<#
  vSphere 8 STIG Read-Only Auditor (Console Only, with DISA STIG IDs)
  -------------------------------------------------------------------
  • Scope: ESXi 8.x (host), vCenter 8.x (core), and selected VM checks
  • Mode: Read-only (no Set-*, no changes)
  • Output: Console tables + summary only
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$VCenter,
  [string]$Username,
  [securestring]$Password,
  [switch]$SkipVCenterChecks
)

Write-Host "vSphere 8 STIG Auditor - READ ONLY" -ForegroundColor Cyan
Write-Host "This script performs queries only. It does not modify any settings." -ForegroundColor Yellow

# ---- Connect ----
try {
  if ($PSBoundParameters.ContainsKey('Username') -and $PSBoundParameters.ContainsKey('Password')) {
    $vi = Connect-VIServer -Server $VCenter -User $Username -Password $Password -ErrorAction Stop
  } else {
    $vi = Connect-VIServer -Server $VCenter -ErrorAction Stop
  }
} catch {
  Write-Error "Failed to connect to vCenter '$VCenter'. $_"
  exit 1
}

# ---- Helper for result rows ----
function New-CheckResult {
  param(
    [string]$Scope,[string]$Component,[string]$RuleId,
    [string]$Expectation,[string]$Observed,
    [ValidateSet('Pass','Fail','Warn','Info')][string]$Status='Info',
    [string]$Notes=''
  )
  [pscustomobject]@{
    Scope=$Scope; Component=$Component; RuleId=$RuleId; Status=$Status
    Expectation=$Expectation; Observed=$Observed; Notes=$Notes
  }
}

# Use a plain PowerShell array to avoid .Add() multi-line parsing issues
$results = @()

# ---- ESXi host checks ----
$hosts = Get-VMHost | Sort-Object Name
foreach ($h in $hosts) {
  $hv = $h | Get-View

  # ESXI-80-000008 Lockdown Mode enabled (Normal/Strict)
  $ld = $hv.Config.LockdownMode
  $st = if ($ld -ne 'lockdownDisabled') { 'Pass' } else { 'Fail' }
  $results += New-CheckResult -Scope $h.Name -Component 'Access Control' `
    -RuleId 'ESXI-80-000008' -Expectation 'Lockdown Mode enabled (Normal or Strict)' `
    -Observed $ld -Status $st

  # ESXI-80-000193 SSH service disabled (stopped and not automatic)
  $svcSSH = Get-VMHostService -VMHost $h | Where-Object { $_.Key -eq 'TSM-SSH' }
  if ($svcSSH) {
    $obs = "Running=$($svcSSH.Running); Policy=$($svcSSH.Policy)"
    $st  = if (-not $svcSSH.Running -and $svcSSH.Policy -ne 'on') { 'Pass' } else { 'Fail' }
    $results += New-CheckResult -Scope $h.Name -Component 'SSH' `
      -RuleId 'ESXI-80-000193' -Expectation 'SSH stopped; startup policy not automatic' `
      -Observed $obs -Status $st
  }

  # ESXI-80-000124 Time sync configured (NTP/PTP) and active/start-with-host
  $ntpServers = (Get-VMHostNtpServer -VMHost $h -ErrorAction SilentlyContinue) -join ','
  $timeSvcs = Get-VMHostService -VMHost $h | Where-Object { $_.Key -in @('ntpd','ptpd') -or $_.Label -match 'NTP|PTP' }
  $running = ($timeSvcs | Where-Object { $_.Running }) -ne $null
  $auto    = ($timeSvcs | Where-Object { $_.Policy -eq 'on' }) -ne $null
  $obs = "Servers=[$ntpServers]; Running=$running; Auto=$auto"
  $st  = if (($ntpServers -ne '') -and ($running -or $auto)) { 'Pass' } else { 'Fail' }
  $results += New-CheckResult -Scope $h.Name -Component 'Time/NTP' `
    -RuleId 'ESXI-80-000124' -Expectation 'Authoritative NTP/PTP configured; service running or start-with-host' `
    -Observed $obs -Status $st

  # ESXI-80-000114 Remote syslog configured
  $syslog = (Get-AdvancedSetting -Entity $h -Name 'Syslog.global.logHost' -ErrorAction SilentlyContinue).Value
  $st = if ($syslog -and $syslog.Trim()) { 'Pass' } else { 'Fail' }
  $results += New-CheckResult -Scope $h.Name -Component 'Logging' `
    -RuleId 'ESXI-80-000114' -Expectation 'Remote syslog target(s) set (udp/tcp/ssl URLs)' `
    -Observed $syslog -Status $st

  # ESXI-80-000195 Shell auto-stop timeout (UserVars.ESXiShellTimeOut <= 600 and not 0)
  $shellTO = (Get-AdvancedSetting -Entity $h -Name 'UserVars.ESXiShellTimeOut' -ErrorAction SilentlyContinue).Value
  $st = if (($shellTO -as [int]) -gt 0 -and ($shellTO -as [int]) -le 600) { 'Pass' } else { 'Fail' }
  $results += New-CheckResult -Scope $h.Name -Component 'Shell/SSH' `
    -RuleId 'ESXI-80-000195' -Expectation 'ESXiShellTimeOut <= 600s and not 0' `
    -Observed "ESXiShellTimeOut=$shellTO" -Status $st

  # ESXI-80-000068 Shell interactive idle timeout (UserVars.ESXiShellInteractiveTimeOut <= 900 and not 0)
  $shellITO = (Get-AdvancedSetting -Entity $h -Name 'UserVars.ESXiShellInteractiveTimeOut' -ErrorAction SilentlyContinue).Value
  $st = if (($shellITO -as [int]) -gt 0 -and ($shellITO -as [int]) -le 900) { 'Pass' } else { 'Fail' }
  $results += New-CheckResult -Scope $h.Name -Component 'Shell/SSH' `
    -RuleId 'ESXI-80-000068' -Expectation 'ESXiShellInteractiveTimeOut <= 900s and not 0' `
    -Observed "ESXiShellInteractiveTimeOut=$shellITO" -Status $st

  # ESXI-80-000196 DCUI idle timeout (UserVars.DcuiTimeOut <= 600 and not 0)
  $dcuiTO = (Get-AdvancedSetting -Entity $h -Name 'UserVars.DcuiTimeOut' -ErrorAction SilentlyContinue).Value
  $st = if (($dcuiTO -as [int]) -gt 0 -and ($dcuiTO -as [int]) -le 600) { 'Pass' } else { 'Fail' }
  $results += New-CheckResult -Scope $h.Name -Component 'DCUI' `
    -RuleId 'ESXI-80-000196' -Expectation 'DCUI timeout <= 600s and not 0' `
    -Observed "DcuiTimeOut=$dcuiTO" -Status $st

  # ESXI-80-000005 Account lockout threshold == 3
  $lockFail = (Get-AdvancedSetting -Entity $h -Name 'Security.AccountLockFailures' -ErrorAction SilentlyContinue).Value
  $st = if (($lockFail -as [int]) -eq 3) { 'Pass' } else { 'Fail' }
  $results += New-CheckResult -Scope $h.Name -Component 'Accounts' `
    -RuleId 'ESXI-80-000005' -Expectation 'Security.AccountLockFailures = 3' `
    -Observed "AccountLockFailures=$lockFail" -Status $st

  # ESXI-80-000111 Unlock timeout == 900 seconds
  $unlock = (Get-AdvancedSetting -Entity $h -Name 'Security.AccountUnlockTime' -ErrorAction SilentlyContinue).Value
  $st = if (($unlock -as [int]) -eq 900) { 'Pass' } else { 'Fail' }
  $results += New-CheckResult -Scope $h.Name -Component 'Accounts' `
    -RuleId 'ESXI-80-000111' -Expectation 'Security.AccountUnlockTime = 900 seconds' `
    -Observed "AccountUnlockTime=$unlock" -Status $st

  # ESXI-80-000035 Password quality policy present
  $pwq = (Get-AdvancedSetting -Entity $h -Name 'Security.PasswordQualityControl' -ErrorAction SilentlyContinue).Value
  $st = if ($pwq -and $pwq.Trim()) { 'Pass' } else { 'Fail' }
  $results += New-CheckResult -Scope $h.Name -Component 'Accounts' `
    -RuleId 'ESXI-80-000035' -Expectation 'PasswordQualityControl configured' `
    -Observed "PasswordQualityControl='$pwq'" -Status $st

  # ESXI-80-000216/217/218 vSwitch/Portgroup security – Standard vSwitch
  $pgs = Get-VirtualPortGroup -VMHost $h -Standard -ErrorAction SilentlyContinue
  foreach ($pg in $pgs) {
    $sec = $pg.ExtensionData.Spec.Policy.Security
    if ($sec) {
      $st = if (-not $sec.ForgedTransmits) { 'Pass' } else { 'Fail' }
      $results += New-CheckResult -Scope "$($h.Name)/$($pg.Name)" -Component 'vSwitch Security' `
        -RuleId 'ESXI-80-000216' -Expectation 'Forged Transmits = Reject' `
        -Observed "ForgedTransmits=$($sec.ForgedTransmits)" -Status $st

      $st = if (-not $sec.MacChanges) { 'Pass' } else { 'Fail' }
      $results += New-CheckResult -Scope "$($h.Name)/$($pg.Name)" -Component 'vSwitch Security' `
        -RuleId 'ESXI-80-000217' -Expectation 'MAC Address Changes = Reject' `
        -Observed "MacChanges=$($sec.MacChanges)" -Status $st

      $st = if (-not $sec.AllowPromiscuous) { 'Pass' } else { 'Fail' }
      $results += New-CheckResult -Scope "$($h.Name)/$($pg.Name)" -Component 'vSwitch Security' `
        -RuleId 'ESXI-80-000218' -Expectation 'Promiscuous Mode = Reject' `
        -Observed "AllowPromiscuous=$($sec.AllowPromiscuous)" -Status $st
    }
  }

  # VMCH-80-000210  Unneeded CD/DVD must be removed/disconnected
  $attached = Get-VM -Location $h | Get-CDDrive | Where-Object { $_.ConnectionState.Connected -or $_.StartConnected }
  if ($attached) {
    foreach ($d in $attached) {
      $vmName = $d.Parent.Name
      $obs = "Connected=$($d.ConnectionState.Connected); StartConnected=$($d.StartConnected); ISO=$($d.IsoPath)"
      $results += New-CheckResult -Scope "$($h.Name)/$vmName" -Component 'VM Media' `
        -RuleId 'VMCH-80-000210' -Expectation 'CD/DVD disconnected; not connect at power on' `
        -Observed $obs -Status 'Fail'
    }
  } else {
    $results += New-CheckResult -Scope $h.Name -Component 'VM Media' `
      -RuleId 'VMCH-80-000210' -Expectation 'No VMs with CD/DVD connected' `
      -Observed 'None detected' -Status 'Pass'
  }

  # VMCH-80-000197  Prevent unauthorized device connection from guest (info via key)
  $vms = Get-VM -Location $h
  foreach ($vm in $vms) {
    $adv = $vm | Get-AdvancedSetting -Name 'isolation.device.connectable.disable' -ErrorAction SilentlyContinue
    $val = $adv.Value
    $st = if ($val -eq 'true') { 'Pass' } else { 'Warn' }
    $results += New-CheckResult -Scope "$($h.Name)/$($vm.Name)" -Component 'VM Device Control' `
      -RuleId 'VMCH-80-000197' -Expectation "isolation.device.connectable.disable = true" `
      -Observed "isolation.device.connectable.disable=$val" -Status $st -Notes 'Requires VM reboot to take effect.'
  }
}

# ---- vCenter checks ----
if (-not $SkipVCenterChecks) {
  try {
    $svcContent = Get-View ServiceInstance
    $sessionMgr = Get-View $svcContent.Content.SessionManager

    # VCSA-80-000089 vSphere Client session timeout <= 15 min
    $timeoutMin = $sessionMgr.SessionTimeout.TotalMinutes
    $st = if (($timeoutMin -as [int]) -le 15 -and ($timeoutMin -ne 0)) { 'Pass' } else { 'Fail' }
    $results += New-CheckResult -Scope $VCenter -Component 'vCenter Session' `
      -RuleId 'VCSA-80-000089' -Expectation 'Session timeout <= 15 minutes' `
      -Observed "TimeoutMinutes=$timeoutMin" -Status $st
  } catch {
    $results += New-CheckResult -Scope $VCenter -Component 'vCenter' `
      -RuleId 'VCSA-80-000089' -Expectation 'Retrieve session timeout' `
      -Observed 'Error retrieving data' -Status 'Warn' -Notes "$_"
  }
}

# ---- Present results ----
$results | Sort-Object Status, Scope, Component |
  Select-Object Status, Scope, Component, RuleId, Observed, Expectation |
  Format-Table -AutoSize

# ---- Summary ----
$pass = ($results | Where-Object Status -eq 'Pass').Count
$fail = ($results | Where-Object Status -eq 'Fail').Count
$warn = ($results | Where-Object Status -eq 'Warn').Count
$info = ($results | Where-Object Status -eq 'Info').Count

Write-Host "`nCompliance Summary:" -ForegroundColor Cyan
Write-Host "  Pass : $pass"
Write-Host "  Fail : $fail"
Write-Host "  Warn : $warn"
Write-Host "  Info : $info"
Write-Host ""

Disconnect-VIServer -Server $vi -Confirm:$false | Out-Null

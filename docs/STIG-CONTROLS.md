# DISA STIG Controls Reference

This document provides detailed information about the DISA STIG controls implemented in the vSphere 8 STIG Auditor.

## ESXi Host Controls

### ESXI-80-000008 - Lockdown Mode
**Severity**: High  
**Category**: Access Control  
**Description**: ESXi must enable lockdown mode to restrict access to the host.

**STIG Requirement**: Lockdown mode must be enabled (Normal or Strict)
- **Normal**: Allows access through vCenter and authorized users
- **Strict**: Only allows access through vCenter Server

**Remediation**:
```powershell
# Enable Normal Lockdown Mode
$vmhost = Get-VMHost "esxi01.company.com"
$lockdown = Get-View $vmhost.ExtensionData.ConfigManager.HostAccessManager
$lockdown.ChangeLockdownMode("lockdownNormal")
```

### ESXI-80-000193 - SSH Service
**Severity**: Medium  
**Category**: Remote Access  
**Description**: ESXi must disable SSH to prevent unauthorized access.

**STIG Requirement**: SSH service must be stopped and not set to start automatically
- Service should not be running
- Startup policy should not be "on" (automatic)

**Remediation**:
```powershell
# Stop SSH service and set to manual startup
Get-VMHost | Get-VMHostService | Where-Object {$_.Key -eq "TSM-SSH"} | 
    Stop-VMHostService -Confirm:$false | 
    Set-VMHostService -Policy "off"
```

### ESXI-80-000124 - Time Synchronization
**Severity**: Medium  
**Category**: Time Management  
**Description**: ESXi must be configured with authoritative time sources.

**STIG Requirement**: NTP or PTP must be configured with authoritative time sources
- At least one NTP server configured
- Time service running or set to start with host

**Remediation**:
```powershell
# Configure NTP servers
Add-VMHostNtpServer -VMHost $vmhost -NtpServer "pool.ntp.org"
Get-VMHostService -VMHost $vmhost | Where-Object {$_.Key -eq "ntpd"} | 
    Start-VMHostService | 
    Set-VMHostService -Policy "on"
```

### ESXI-80-000114 - Remote Syslog
**Severity**: Medium  
**Category**: Logging  
**Description**: ESXi must send logs to a central log server.

**STIG Requirement**: Remote syslog target must be configured
- Syslog.global.logHost must contain valid syslog server(s)
- Supports UDP, TCP, and SSL protocols

**Remediation**:
```powershell
# Configure remote syslog
Get-VMHost | Get-AdvancedSetting -Name "Syslog.global.logHost" | 
    Set-AdvancedSetting -Value "udp://syslog.company.com:514" -Confirm:$false
```

### ESXI-80-000195 - Shell Auto-Stop Timeout
**Severity**: Medium  
**Category**: Shell Security  
**Description**: ESXi shell must automatically terminate after timeout.

**STIG Requirement**: ESXiShellTimeOut must be ≤ 600 seconds and not 0
- Prevents shells from running indefinitely
- Reduces attack surface

**Remediation**:
```powershell
# Set shell timeout to 10 minutes
Get-VMHost | Get-AdvancedSetting -Name "UserVars.ESXiShellTimeOut" | 
    Set-AdvancedSetting -Value 600 -Confirm:$false
```

### ESXI-80-000068 - Shell Interactive Timeout
**Severity**: Medium  
**Category**: Shell Security  
**Description**: ESXi shell must timeout idle interactive sessions.

**STIG Requirement**: ESXiShellInteractiveTimeOut must be ≤ 900 seconds and not 0
- Terminates idle shell sessions
- Prevents unauthorized access to idle sessions

**Remediation**:
```powershell
# Set interactive timeout to 15 minutes
Get-VMHost | Get-AdvancedSetting -Name "UserVars.ESXiShellInteractiveTimeOut" | 
    Set-AdvancedSetting -Value 900 -Confirm:$false
```

### ESXI-80-000196 - DCUI Timeout
**Severity**: Medium  
**Category**: Console Access  
**Description**: ESXi DCUI must timeout idle sessions.

**STIG Requirement**: DcuiTimeOut must be ≤ 600 seconds and not 0
- Applies to Direct Console User Interface
- Prevents unauthorized physical access

**Remediation**:
```powershell
# Set DCUI timeout to 10 minutes
Get-VMHost | Get-AdvancedSetting -Name "UserVars.DcuiTimeOut" | 
    Set-AdvancedSetting -Value 600 -Confirm:$false
```

### ESXI-80-000005 - Account Lockout Threshold
**Severity**: Medium  
**Category**: Account Security  
**Description**: ESXi must enforce account lockout policy.

**STIG Requirement**: Security.AccountLockFailures must equal 3
- Locks accounts after 3 failed login attempts
- Prevents brute force attacks

**Remediation**:
```powershell
# Set account lockout threshold
Get-VMHost | Get-AdvancedSetting -Name "Security.AccountLockFailures" | 
    Set-AdvancedSetting -Value 3 -Confirm:$false
```

### ESXI-80-000111 - Account Unlock Timeout
**Severity**: Medium  
**Category**: Account Security  
**Description**: ESXi must enforce account unlock timeout.

**STIG Requirement**: Security.AccountUnlockTime must equal 900 seconds
- Accounts remain locked for 15 minutes
- Balances security with usability

**Remediation**:
```powershell
# Set account unlock timeout
Get-VMHost | Get-AdvancedSetting -Name "Security.AccountUnlockTime" | 
    Set-AdvancedSetting -Value 900 -Confirm:$false
```

### ESXI-80-000035 - Password Quality
**Severity**: Medium  
**Category**: Password Security  
**Description**: ESXi must enforce password complexity requirements.

**STIG Requirement**: Security.PasswordQualityControl must be configured
- Enforces strong password requirements
- Prevents weak passwords

**Remediation**:
```powershell
# Set password quality control
$policy = "similar=deny retry=3 min=disabled,disabled,disabled,disabled,15"
Get-VMHost | Get-AdvancedSetting -Name "Security.PasswordQualityControl" | 
    Set-AdvancedSetting -Value $policy -Confirm:$false
```

### ESXI-80-000216/217/218 - vSwitch Security
**Severity**: Medium  
**Category**: Network Security  
**Description**: ESXi vSwitch security policies must be configured properly.

**STIG Requirements**:
- **216**: Forged Transmits = Reject
- **217**: MAC Address Changes = Reject  
- **218**: Promiscuous Mode = Reject

**Remediation**:
```powershell
# Configure vSwitch security policies
Get-VirtualSwitch | Get-SecurityPolicy | 
    Set-SecurityPolicy -ForgedTransmits $false -MacChanges $false -AllowPromiscuous $false
```

## vCenter Server Controls

### VCSA-80-000089 - Session Timeout
**Severity**: Medium  
**Category**: Session Management  
**Description**: vCenter must enforce session timeout limits.

**STIG Requirement**: Session timeout must be ≤ 15 minutes
- Prevents unauthorized access to idle sessions
- Reduces session hijacking risk

**Remediation**:
```powershell
# Configure session timeout (requires vCenter configuration)
# This is typically configured through vCenter Server settings
# or vSphere Client advanced settings
```

## Virtual Machine Controls

### VMCH-80-000210 - CD/DVD Management
**Severity**: Low  
**Category**: Device Control  
**Description**: Virtual machines must not have unnecessary CD/DVD devices.

**STIG Requirement**: CD/DVD devices must be disconnected and not connect at power on
- Reduces attack surface
- Prevents unauthorized media access

**Remediation**:
```powershell
# Disconnect CD/DVD drives
Get-VM | Get-CDDrive | 
    Set-CDDrive -NoMedia -StartConnected:$false -Confirm:$false
```

### VMCH-80-000197 - Device Connection Control
**Severity**: Medium  
**Category**: Device Security  
**Description**: Virtual machines must prevent unauthorized device connections.

**STIG Requirement**: isolation.device.connectable.disable must be true
- Prevents guests from connecting/disconnecting devices
- Requires VM restart to take effect

**Remediation**:
```powershell
# Disable device connectivity from guest
Get-VM | New-AdvancedSetting -Name "isolation.device.connectable.disable" -Value "true" -Confirm:$false
```

## Compliance Status Definitions

- **Pass**: Control is properly configured and meets STIG requirements
- **Fail**: Control does not meet STIG requirements and needs remediation
- **Warn**: Control may not meet requirements or needs manual verification
- **Info**: Informational finding that doesn't affect compliance

## Additional Resources

- [DISA STIG Library](https://public.cyber.mil/stigs/)
- [VMware vSphere Security Configuration Guide](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-security/GUID-52188148-C579-4F6A-8335-CFBCE0DD2167.html)
- [VMware Security Advisories](https://www.vmware.com/security/advisories.html)
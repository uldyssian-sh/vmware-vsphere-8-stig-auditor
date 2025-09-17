# vSphere 8 STIG Compliance Auditor

> DoD STIG automated compliance validation and remediation for vSphere 8

[![Deploy](https://github.com/uldyssian-sh/vsphere8-stig-auditor/actions/workflows/deploy.yml/badge.svg)](https://github.com/uldyssian-sh/vsphere8-stig-auditor/actions/workflows/deploy.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Quick Start

```powershell
# Prerequisites: PowerShell 7+, PowerCLI 13+, vCenter 8.0+
Import-Module VMware.PowerCLI
Connect-VIServer -Server vcenter.mil

# Clone and execute
git clone https://github.com/uldyssian-sh/vsphere8-stig-auditor.git
cd vsphere8-stig-auditor
.\scripts\Invoke-STIGAudit.ps1 -Environment "Production"
```

## STIG Control Coverage

| Category | Controls | Automated | Manual | Status |
|----------|----------|-----------|--------|--------|
| CAT I (High) | 45 | 42 | 3 | ✅ 93% |
| CAT II (Medium) | 128 | 115 | 13 | ✅ 90% |
| CAT III (Low) | 67 | 58 | 9 | ✅ 87% |
| **Total** | **240** | **215** | **25** | **✅ 90%** |

## Core Assessment Functions

```powershell
# Full environment audit
Invoke-STIGAssessment -Target "vcenter.mil" -Scope "Full" -OutputFormat "SCAP"

# Specific control testing
Test-STIGControl -ControlID "ESXI-80-000001" -Severity "CAT-I"

# Automated remediation
Set-STIGCompliance -Target "Production-Cluster" -Category "CAT-I" -AutoFix

# Generate compliance report
New-STIGReport -Assessment $results -Format "ATO-Package"
```

## Security Categories

### Category I - Critical Security Controls
- Multi-factor authentication enforcement
- Encryption of data at rest and in transit
- Network segmentation and isolation
- Privileged access management
- Audit logging and monitoring

### Category II - Important Security Controls
- User account management
- Service configuration hardening
- Resource access controls
- Security patch management
- Backup and recovery procedures

### Category III - General Security Controls
- Documentation requirements
- Training and awareness
- Physical security considerations
- Operational procedures
- Configuration management

## Compliance Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│                    STIG Compliance Status                   │
├─────────────────────────────────────────────────────────────┤
│ Overall Compliance:     ████████████████░░░░  90%          │
│ CAT I (Critical):       ████████████████████░  93%         │
│ CAT II (Important):     ████████████████████░  90%         │
│ CAT III (General):      ███████████████████░░  87%         │
│                                                             │
│ Open Findings:          25                                  │
│ Remediated:            215                                  │
│ Risk Score:            Medium                               │
└─────────────────────────────────────────────────────────────┘
```

## Automated Remediation

```powershell
# Risk-based remediation prioritization
$findings = Get-STIGFindings -Severity "CAT-I","CAT-II"
$findings | Sort-Object Risk -Descending | Invoke-AutoRemediation

# Batch remediation with rollback capability
Start-STIGRemediation -Controls @("ESXI-80-000001","ESXI-80-000002") -CreateCheckpoint
```

## Evidence Collection

- **Screenshots**: Automated GUI evidence capture
- **Configuration Files**: System configuration exports
- **Log Extracts**: Relevant security log entries
- **Command Output**: CLI verification results
- **Compliance Matrix**: Control-to-evidence mapping

## Integration & Reporting

### SCAP Integration
- XCCDF compliance reports
- OVAL definition validation
- CPE platform identification
- CVE vulnerability correlation

### Enterprise Integration
- **Splunk**: Security event forwarding
- **ServiceNow**: Automated ticket creation
- **Nessus**: Vulnerability scan correlation
- **Archer**: GRC platform integration

## Continuous Monitoring

```powershell
# Real-time compliance monitoring
Start-STIGMonitor -Interval 4 -AlertThreshold "CAT-I" -NotificationEmail "isso@mil"

# Scheduled compliance validation
Register-ScheduledTask -TaskName "Monthly-STIG-Audit" -Trigger (New-ScheduledTaskTrigger -Monthly)
```

---
**Maintained by**: [uldyssian-sh](https://github.com/uldyssian-sh) | **License**: MIT<!-- Deployment trigger Wed Sep 17 22:41:05 CEST 2025 -->

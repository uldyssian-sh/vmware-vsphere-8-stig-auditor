# vSphere 8 STIG Auditor

[![GitHub license](https://img.shields.io/github/license/uldyssian-sh/vsphere8-stig-auditor)](https://github.com/uldyssian-sh/vsphere8-stig-auditor/blob/main/LICENSE)
[![CI](https://github.com/uldyssian-sh/vsphere8-stig-auditor/workflows/CI/badge.svg)](https://github.com/uldyssian-sh/vsphere8-stig-auditor/actions)

## 🚀 Overview

VMware vSphere 8 Security Technical Implementation Guide (STIG) compliance auditor. Automated assessment and remediation tool for DoD STIG requirements on vSphere 8 environments.

**Technology Stack:** PowerCLI, PowerShell, vSphere API, STIG Controls

## ✨ Features

- 🔒 **STIG Compliance Assessment** - Automated STIG validation
- 📋 **DoD Requirements** - Complete STIG control coverage
- 🔧 **Automated Remediation** - Fix non-compliant configurations
- 📊 **Compliance Reporting** - Detailed STIG compliance reports
- 🎯 **Risk Assessment** - Security risk categorization
- 📈 **Continuous Monitoring** - Ongoing compliance validation

## 🛠️ Prerequisites

- PowerCLI 13.0+
- PowerShell 7.0+
- vCenter Server 8.0+
- Administrative access to vSphere environment
- STIG benchmark documentation

## 🚀 Quick Start

```powershell
# Clone repository
git clone https://github.com/uldyssian-sh/vsphere8-stig-auditor.git
cd vsphere8-stig-auditor

# Import required modules
Import-Module VMware.PowerCLI
Import-Module .\modules\STIGAuditor.psm1

# Connect to vCenter
Connect-VIServer -Server vcenter.domain.com

# Run STIG assessment
Invoke-STIGAssessment -Target "vcenter.domain.com" -OutputPath "C:\Reports\"

# Generate compliance report
New-STIGComplianceReport -AssessmentPath "C:\Reports\" -Format HTML
```

## 📋 STIG Categories

### Category I (High Risk)
- Authentication and access control
- Encryption requirements
- Network security controls
- Audit and logging
- System integrity

### Category II (Medium Risk)
- Configuration management
- User account management
- Service configuration
- Resource management
- Monitoring controls

### Category III (Low Risk)
- Documentation requirements
- Informational controls
- Best practice recommendations
- Operational procedures
- Training requirements

## 🔧 Available Cmdlets

| Cmdlet | Description |
|--------|-------------|
| `Invoke-STIGAssessment` | Run complete STIG assessment |
| `Test-STIGControl` | Test individual STIG control |
| `Set-STIGCompliance` | Apply STIG remediation |
| `Get-STIGReport` | Generate compliance reports |
| `Export-STIGResults` | Export assessment results |

## 📊 Assessment Examples

### Full Environment Assessment
```powershell
# Assess entire vSphere environment
Invoke-STIGAssessment -Target "vcenter.domain.com" -Scope "Environment" -Detailed

# Assess specific cluster
Invoke-STIGAssessment -Target "Production-Cluster" -Scope "Cluster"

# Assess ESXi hosts
Invoke-STIGAssessment -Target "esxi-host.domain.com" -Scope "Host"
```

### Specific Control Testing
```powershell
# Test authentication controls
Test-STIGControl -Category "Authentication" -Severity "CAT-I"

# Test network security
Test-STIGControl -Category "Network" -Control "ESXI-80-000001"

# Test logging configuration
Test-STIGControl -Category "Logging" -Detailed
```

## 🔒 STIG Controls Coverage

### vCenter Server Controls
- User authentication and authorization
- Certificate management
- Network configuration
- Logging and auditing
- Service configuration

### ESXi Host Controls
- Host security configuration
- Network isolation
- Storage security
- VM security settings
- Hypervisor hardening

### Virtual Machine Controls
- VM configuration security
- Guest OS hardening
- Network security
- Storage encryption
- Access controls

## 📈 Compliance Reporting

```powershell
# Generate executive summary
New-STIGExecutiveSummary -AssessmentData $results -OutputPath "C:\Reports\"

# Create detailed findings report
New-STIGFindingsReport -Results $results -IncludeRemediation -Format PDF

# Export to SCAP format
Export-STIGToSCAP -Results $results -OutputPath "C:\SCAP\"
```

## 🎯 Remediation

- Automated fix implementation
- Manual remediation guidance
- Risk-based prioritization
- Change impact analysis
- Rollback procedures

## 📚 Documentation

- [STIG Implementation Guide](docs/stig-implementation.md)
- [Control Mapping](docs/control-mapping.md)
- [Remediation Procedures](docs/remediation.md)
- [Troubleshooting](docs/troubleshooting.md)

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

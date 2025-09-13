# vSphere 8 STIG Compliance Auditor

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207%2B-blue)](https://github.com/PowerShell/PowerShell)
[![VMware](https://img.shields.io/badge/VMware-vSphere%208-orange)](https://www.vmware.com/products/vsphere.html)
[![CI](https://github.com/uldyssian-sh/vsphere8-stig-auditor/actions/workflows/ci.yml/badge.svg)](https://github.com/uldyssian-sh/vsphere8-stig-auditor/actions/workflows/ci.yml)
[![STIG](https://img.shields.io/badge/DISA-STIG%20Compliant-green)](https://public.cyber.mil/stigs/)

A comprehensive **read-only PowerCLI auditor** for VMware vSphere 8 environments against **DISA STIG security controls**. This tool performs non-intrusive compliance checks and generates detailed reports without making any configuration changes.

> **Author**: uldyssian-sh (LT) · **Version**: 1.0 · **License**: MIT

---

## 🔍 Overview

This auditor validates vSphere 8 environments against selected **DISA Security Technical Implementation Guide (STIG)** controls, covering:

- **ESXi 8.x Hosts** - Security settings, services, and configurations
- **vCenter 8.x Server** - Session management and core security
- **Virtual Machines** - Device controls and security policies

The script is **completely read-only** and safe to run in production environments with auditor/read-only accounts.

---

## ✨ Features

- **🔒 Read-Only Operation** - No configuration changes, safe for production
- **📋 DISA STIG Compliance** - Validates against official STIG controls
- **🎯 Comprehensive Coverage** - ESXi, vCenter, and VM security checks
- **📊 Detailed Reporting** - Formatted console output with compliance summary
- **⚡ Fast Execution** - Efficient PowerCLI queries with minimal impact
- **🔧 Flexible Authentication** - Supports various credential methods
- **📈 CI/CD Ready** - Automated testing and quality assurance

---

## 🚀 Quick Start

```powershell
# Clone the repository
git clone https://github.com/uldyssian-sh/vsphere8-stig-auditor.git
cd vsphere8-stig-auditor

# Install PowerCLI (if not already installed)
Install-Module -Name VMware.PowerCLI -Scope CurrentUser

# Run basic audit
.\vsphere8-stig-auditor.ps1 -VCenter "vcenter.company.com"

# Run with credentials
$cred = Get-Credential
.\vsphere8-stig-auditor.ps1 -VCenter "vcenter.company.com" -Username $cred.UserName -Password $cred.Password

# Skip vCenter checks (ESXi only)
.\vsphere8-stig-auditor.ps1 -VCenter "vcenter.company.com" -SkipVCenterChecks
```

---

## 📋 STIG Controls Covered

### ESXi Host Controls
| Rule ID | Description | Category |
|---------|-------------|----------|
| ESXI-80-000008 | Lockdown Mode enabled | Access Control |
| ESXI-80-000193 | SSH service disabled | Remote Access |
| ESXI-80-000124 | NTP/PTP time synchronization | Time Management |
| ESXI-80-000114 | Remote syslog configuration | Logging |
| ESXI-80-000195 | Shell auto-stop timeout | Shell Security |
| ESXI-80-000068 | Shell interactive timeout | Shell Security |
| ESXI-80-000196 | DCUI idle timeout | Console Access |
| ESXI-80-000005 | Account lockout threshold | Account Security |
| ESXI-80-000111 | Account unlock timeout | Account Security |
| ESXI-80-000035 | Password quality policy | Password Security |
| ESXI-80-000216 | vSwitch forged transmits | Network Security |
| ESXI-80-000217 | vSwitch MAC changes | Network Security |
| ESXI-80-000218 | vSwitch promiscuous mode | Network Security |

### vCenter Controls
| Rule ID | Description | Category |
|---------|-------------|----------|
| VCSA-80-000089 | Session timeout configuration | Session Management |

### Virtual Machine Controls
| Rule ID | Description | Category |
|---------|-------------|----------|
| VMCH-80-000210 | CD/DVD device management | Device Control |
| VMCH-80-000197 | Unauthorized device connections | Device Security |

---

## 📊 Sample Output

```
Status Scope                    Component         RuleId         Observed                           Expectation
------ -----                    ---------         ------         --------                           -----------
Pass   esxi01.company.com       Access Control    ESXI-80-000008 lockdownNormal                     Lockdown Mode enabled (Normal or Strict)
Fail   esxi01.company.com       SSH               ESXI-80-000193 Running=True; Policy=on            SSH stopped; startup policy not automatic
Pass   esxi01.company.com       Time/NTP          ESXI-80-000124 Servers=[pool.ntp.org]; Running=True; Auto=True Authoritative NTP/PTP configured
Warn   esxi01.company.com/VM01  VM Device Control VMCH-80-000197 isolation.device.connectable.disable=false isolation.device.connectable.disable = true

Compliance Summary:
  Pass : 25
  Fail : 3
  Warn : 2
  Info : 1
```

---

## 📚 Documentation

- [Installation Guide](docs/INSTALLATION.md) - Detailed setup instructions
- [STIG Controls Reference](docs/STIG-CONTROLS.md) - Complete control descriptions
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [Examples](examples/) - Usage scenarios and automation examples
- [Contributing](CONTRIBUTING.md) - How to contribute to the project

---

## 🔧 Requirements

### System Requirements
- **PowerShell 5.1+** (Windows) or **PowerShell 7+** (cross-platform)
- **VMware PowerCLI** module
- Network connectivity to vCenter Server

### vSphere Permissions
Minimum required permissions for auditing:
- **Global** > **System.Anonymous** (for basic connectivity)
- **Global** > **System.Read** (for configuration queries)
- **Host** > **Configuration.View** (for ESXi settings)
- **Virtual Machine** > **Configuration.View** (for VM settings)

### Supported Versions
- **VMware vSphere 8.0** and later
- **VMware ESXi 8.0** and later
- **VMware vCenter Server 8.0** and later

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on:
- Code of conduct and development guidelines
- Adding new STIG controls and checks
- Testing requirements and procedures
- Pull request process

### Development Setup
```powershell
# Install development dependencies
Install-Module -Name Pester -Scope CurrentUser
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser

# Run tests
Invoke-Pester -Path tests

# Run code analysis
Invoke-ScriptAnalyzer -Path . -Settings ./.config/PSScriptAnalyzerSettings.psd1 -Recurse
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ⚠️ Disclaimer

This script is provided "as is" without warranty of any kind. Use at your own risk. You are solely responsible for reviewing, testing, and implementing it in your environment.

This tool is not officially endorsed by DISA or VMware. STIG compliance requirements may change - always refer to the latest official DISA STIG documentation.

---

## 🙏 Acknowledgments

- **DISA** for providing comprehensive STIG security guidelines
- **VMware** for PowerCLI and vSphere platform
- **PowerShell Community** for testing and automation frameworks
- **Security Community** for continuous improvement feedback

---

**🔐 Security First**: This tool helps maintain security compliance but does not replace proper security practices, regular updates, and comprehensive security monitoring.
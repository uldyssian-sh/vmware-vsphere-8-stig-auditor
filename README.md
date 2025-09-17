# vSphere 8 STIG Auditor

<div align="center">

```
┌─────────────────────────────────────────────────────────────┐
│                    vSphere 8 STIG Auditor                  │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │   vCenter   │────│ STIG Checks │────│   Reports   │     │
│  │   Server    │    │   Engine    │    │  Generator  │     │
│  └─────────────┘    └─────────────┘    └─────────────┘     │
│         │                   │                   │          │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │ ESXi Hosts  │    │ Compliance  │    │ Remediation │     │
│  │ Inventory   │    │ Database    │    │   Scripts   │     │
│  └─────────────┘    └─────────────┘    └─────────────┘     │
└─────────────────────────────────────────────────────────────┘
```
  
  [![CI](https://github.com/uldyssian-sh/vsphere8-stig-auditor/workflows/CI/badge.svg)](https://github.com/uldyssian-sh/vsphere8-stig-auditor/actions)
  [![STIG Compliance](https://img.shields.io/badge/STIG-Compliant-green.svg)](https://public.cyber.mil/stigs/)
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
</div>

## 🛡️ Overview

Automated STIG (Security Technical Implementation Guide) compliance auditor for VMware vSphere 8 environments. Ensures your infrastructure meets DoD security standards.

## 🎯 Features

- **Automated STIG Checks**: 200+ security controls validation
- **Compliance Reports**: Detailed HTML/PDF reports
- **Remediation Scripts**: Auto-fix common violations
- **Multi-Environment**: Dev, staging, production support
- **API Integration**: REST API for CI/CD pipelines

## 🚀 Quick Start

```bash
# Install
pip install vsphere8-stig-auditor

# Configure
export VCENTER_HOST="your-vcenter.domain.com"
export VCENTER_USER="administrator@vsphere.local"
export VCENTER_PASS="your-password"

# Run audit
vsphere8-audit --full-scan --output-format html
```

## 📊 Compliance Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│                 STIG Compliance Dashboard                   │
├─────────────────────────────────────────────────────────────┤
│ Control Categories    │ Status    │ Compliance │ Actions    │
├─────────────────────────────────────────────────────────────┤
│ Access Control        │    ✅     │    98%     │ 2 Issues   │
│ System Settings       │    ✅     │   100%     │ Compliant  │
│ Network Security      │    ⚠️     │    85%     │ 5 Issues   │
│ Logging & Monitoring  │    ✅     │    95%     │ 1 Issue    │
└─────────────────────────────────────────────────────────────┘
```

## 📚 Documentation

- [Installation Guide](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/Installation)
- [Configuration Reference](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/Configuration)
- [STIG Controls Mapping](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/STIG-Controls)
- [API Documentation](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/API)

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

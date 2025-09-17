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
[![Security](https://github.com/uldyssian-sh/vsphere8-stig-auditor/workflows/Security/badge.svg)](https://github.com/uldyssian-sh/vsphere8-stig-auditor/security)
[![STIG](https://img.shields.io/badge/STIG-Compliant-green.svg)](https://public.cyber.mil/stigs/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

## 🛡️ Enterprise STIG Compliance Automation

Automated Security Technical Implementation Guide (STIG) compliance auditor for VMware vSphere 8 environments. Ensures DoD security standards compliance with comprehensive reporting and automated remediation capabilities.

## 🎯 Core Features

- **200+ STIG Controls**: Complete DoD security requirements coverage
- **Real-time Auditing**: Continuous compliance monitoring
- **Automated Remediation**: Smart fix deployment with rollback
- **Executive Reporting**: C-level compliance dashboards
- **Multi-Environment**: Production, staging, development support
- **API Integration**: REST API for CI/CD pipeline integration

## 🚀 Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Configure environment
export VCENTER_HOST="vcenter.domain.com"
export VCENTER_USER="administrator@vsphere.local"
export VCENTER_PASS="your-password"

# Run full STIG audit
python stig_auditor.py --full-audit --output-format html

# Apply automated fixes
python stig_auditor.py --remediate --category access_control
```

## 📊 STIG Control Categories

| Category | Controls | Automation | Priority |
|----------|----------|------------|----------|
| Access Control | 45 | Full | Critical |
| System Settings | 38 | Full | High |
| Network Security | 29 | Partial | High |
| Logging & Monitoring | 22 | Full | Medium |
| Backup & Recovery | 18 | Manual | Medium |

## 📚 Documentation

- **[Installation Guide](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/Installation)** - Complete setup instructions
- **[Configuration Reference](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/Configuration)** - All configuration options
- **[STIG Controls Mapping](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/STIG-Controls)** - Complete controls reference
- **[API Documentation](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/API)** - REST API reference
- **[Troubleshooting Guide](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/Troubleshooting)** - Common issues and solutions

## 🔗 Integration

- **[Jenkins Integration](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/Jenkins)** - Pipeline integration
- **[GitLab CI](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/GitLab-CI)** - Automated compliance checks
- **[Splunk](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/Splunk)** - Log analysis and alerting
- **[Grafana](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/Grafana)** - Compliance dashboards

## 🤝 Contributing

1. **[Fork Repository](https://github.com/uldyssian-sh/vsphere8-stig-auditor/fork)** - Create your fork
2. **[Create Branch](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/Contributing#branches)** - Feature or bugfix branch
3. **[Submit PR](https://github.com/uldyssian-sh/vsphere8-stig-auditor/pulls)** - Pull request with tests
4. **[Code Review](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki/Contributing#review)** - Peer review process

## 📄 License

This project is licensed under the MIT License - see the **[LICENSE](https://github.com/uldyssian-sh/vsphere8-stig-auditor/blob/main/LICENSE)** file for details.

## 🆘 Support

- **[GitHub Issues](https://github.com/uldyssian-sh/vsphere8-stig-auditor/issues)** - Bug reports and feature requests
- **[Discussions](https://github.com/uldyssian-sh/vsphere8-stig-auditor/discussions)** - Community support and Q&A
- **[Wiki](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki)** - Comprehensive documentation
- **[Security Policy](https://github.com/uldyssian-sh/vsphere8-stig-auditor/security/policy)** - Vulnerability reporting

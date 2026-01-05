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

```powershell
# Install PowerCLI
Install-Module -Name VMware.PowerCLI -Force

# Connect to vCenter
Connect-VIServer -Server vcenter.domain.com

# Run STIG audit
.\vsphere8-stig-auditor.ps1 -VCenter "vcenter.domain.com"

# Review results
Get-Content .\audit-results.txt
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

- **[Installation Guide](docs/INSTALLATION.md)** - Complete setup instructions
- **[Configuration Reference](docs/CONFIGURATION.md)** - All configuration options
- **[STIG Controls Mapping](docs/STIG-CONTROLS.md)** - Complete controls reference
- **[API Documentation](docs/API.md)** - REST API reference
- **[Troubleshooting Guide](docs/TROUBLESHOOTING.md)** - Common issues and solutions

## 🔗 Integration

- **PowerShell Module** - Direct PowerCLI integration
- **CI/CD Pipeline** - Automated compliance checks
- **Docker Support** - Containerized deployment
- **REST API** - Programmatic access

## 🤝 Contributing

1. **[Fork Repository](https://github.com/uldyssian-sh/vsphere8-stig-auditor/fork)** - Create your fork
2. **[Contributing Guide](CONTRIBUTING.md)** - Development guidelines
3. **[Submit PR](https://github.com/uldyssian-sh/vsphere8-stig-auditor/pulls)** - Pull request with tests
4. **[Code of Conduct](CODE_OF_CONDUCT.md)** - Community standards

## 📄 License

This project is licensed under the MIT License - see the **[LICENSE](https://github.com/uldyssian-sh/vsphere8-stig-auditor/blob/main/LICENSE)** file for details.

## 🆘 Support

- **[GitHub Issues](https://github.com/uldyssian-sh/vsphere8-stig-auditor/issues)** - Bug reports and feature requests
- **[Discussions](https://github.com/uldyssian-sh/vsphere8-stig-auditor/discussions)** - Community support and Q&A
- **[Wiki](https://github.com/uldyssian-sh/vsphere8-stig-auditor/wiki)** - Comprehensive documentation

---

Maintained by: uldyssian-sh⭐ Star this repository if you find it helpful!Disclaimer: Use of this code is at your own risk. Author bears no responsibility for any damages caused by the code.
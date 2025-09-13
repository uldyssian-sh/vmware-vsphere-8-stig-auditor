# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive project documentation and structure
- GitHub Actions CI/CD pipeline
- Automated testing with Pester
- Code quality checks with PSScriptAnalyzer
- Enterprise examples for bulk auditing and reporting
- Detailed STIG controls reference documentation

## [1.0.0] - 2024-12-19

### Added
- Initial release of vSphere 8 STIG Auditor
- Read-only compliance auditing for vSphere 8 environments
- Support for 15+ DISA STIG controls covering:
  - ESXi host security settings
  - vCenter session management
  - Virtual machine device controls
- Console output with compliance summary
- PowerCLI integration for vSphere management

### STIG Controls Implemented
- **ESXI-80-000008**: Lockdown Mode enforcement
- **ESXI-80-000193**: SSH service configuration
- **ESXI-80-000124**: NTP/PTP time synchronization
- **ESXI-80-000114**: Remote syslog configuration
- **ESXI-80-000195**: Shell auto-stop timeout
- **ESXI-80-000068**: Shell interactive timeout
- **ESXI-80-000196**: DCUI idle timeout
- **ESXI-80-000005**: Account lockout threshold
- **ESXI-80-000111**: Account unlock timeout
- **ESXI-80-000035**: Password quality policy
- **ESXI-80-000216**: vSwitch forged transmits
- **ESXI-80-000217**: vSwitch MAC changes
- **ESXI-80-000218**: vSwitch promiscuous mode
- **VCSA-80-000089**: vCenter session timeout
- **VMCH-80-000210**: VM CD/DVD management
- **VMCH-80-000197**: VM device connection control

### Features
- Non-intrusive read-only operation
- Flexible authentication options
- Detailed compliance reporting
- Error handling and graceful failures
- Support for multiple ESXi hosts per vCenter
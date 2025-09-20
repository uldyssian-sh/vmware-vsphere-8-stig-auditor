# Contributing to VMware vSphere 8 STIG Auditor

Thank you for your interest in contributing to the VMware vSphere 8 STIG Auditor! This document provides guidelines for contributing to this project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Issues

1. **Search existing issues** first to avoid duplicates
2. **Use the issue template** when creating new issues
3. **Provide detailed information**:
   - PowerShell version
   - PowerCLI version
   - vSphere version
   - Error messages (full stack trace)
   - Steps to reproduce

### Submitting Changes

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/new-stig-control`
3. **Make your changes**
4. **Test your changes** (see Testing section)
5. **Commit with clear messages**
6. **Push to your fork**
7. **Create a Pull Request**

## Development Setup

### Prerequisites
- PowerShell 5.1+ (Windows) or PowerShell 7+ (cross-platform)
- VMware PowerCLI
- Pester (for testing)
- PSScriptAnalyzer (for linting)

### Installation
```powershell
# Install development dependencies
Install-Module -Name VMware.PowerCLI -Scope CurrentUser
Install-Module -Name Pester -Scope CurrentUser
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser
```

## Adding New STIG Controls

### 1. Research the Control
- Review the official DISA STIG documentation
- Understand the security requirement
- Identify the PowerCLI commands needed
- Determine the expected vs. observed values

### 2. Implement the Check
Add your check to the main script following this pattern:

```powershell
# ESXI-80-XXXXXX Description of the control
$setting = (Get-AdvancedSetting -Entity $h -Name 'Setting.Name' -ErrorAction SilentlyContinue).Value
$st = if ($setting -eq 'expected_value') { 'Pass' } else { 'Fail' }
$results += New-CheckResult -Scope $h.Name -Component 'Category' `
  -RuleId 'ESXI-80-XXXXXX' -Expectation 'Description of expected state' `
  -Observed "Setting.Name=$setting" -Status $st
```

### 3. Add Documentation
Update the following files:
- `docs/STIG-CONTROLS.md` - Add detailed control description
- `README.md` - Add control to the summary table
- Add remediation examples

### 4. Add Tests
Create tests in `tests/vmware-vsphere-8-stig-auditor.Tests.ps1`:

```powershell
It 'Should check new control (ESXI-80-XXXXXX)' {
    $script | Should -Match 'ESXI-80-XXXXXX'
    $script | Should -Match 'Setting.Name'
}
```

## Testing

### Running Tests
```powershell
# Run all tests
Invoke-Pester -Path tests -Output Detailed

# Run specific test file
Invoke-Pester -Path tests/vmware-vsphere-8-stig-auditor.Tests.ps1
```

### Code Quality
```powershell
# Run PSScriptAnalyzer
Invoke-ScriptAnalyzer -Path . -Settings ./.config/PSScriptAnalyzerSettings.psd1 -Recurse
```

### Manual Testing
1. Test against a lab vSphere environment
2. Verify both compliant and non-compliant scenarios
3. Check that the control produces correct Pass/Fail results
4. Validate remediation steps work correctly

## Coding Standards

### PowerShell Style Guide
- Use **2 spaces** for indentation
- **PascalCase** for functions and parameters
- **camelCase** for variables
- Use **approved verbs** for function names
- Follow PowerShell best practices

### STIG Control Guidelines
- Use official DISA STIG rule IDs
- Include clear expectation descriptions
- Provide meaningful observed values
- Use appropriate status levels (Pass/Fail/Warn/Info)
- Add remediation examples in documentation

### Error Handling
- Use `try/catch` blocks for error handling
- Provide **meaningful error messages**
- Use appropriate **ErrorAction** parameters
- Handle missing settings gracefully

## Pull Request Guidelines

### Before Submitting
- [ ] Tests pass locally
- [ ] Code follows style guidelines
- [ ] Documentation is updated
- [ ] STIG control is properly researched
- [ ] Remediation steps are tested

### PR Description Template
```markdown
## Description
Brief description of the new STIG control or changes

## STIG Control Details
- **Rule ID**: ESXI-80-XXXXXX
- **Severity**: High/Medium/Low
- **Category**: Security category
- **Description**: What this control validates

## Testing
- [ ] Tested against compliant environment
- [ ] Tested against non-compliant environment
- [ ] Remediation steps verified
- [ ] Unit tests added/updated

## Documentation
- [ ] STIG-CONTROLS.md updated
- [ ] README.md updated
- [ ] Examples added if applicable

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests pass
- [ ] Documentation updated
- [ ] No breaking changes
```

## STIG Control Categories

When adding new controls, use these categories:
- **Access Control** - Authentication, authorization, lockdown
- **Account Security** - Password policies, lockout settings
- **Network Security** - vSwitch policies, firewall settings
- **Logging** - Syslog, audit logging
- **Time Management** - NTP, time synchronization
- **Shell Security** - SSH, shell timeouts
- **Session Management** - Session timeouts, idle handling
- **Device Control** - VM device policies
- **Service Management** - Service configurations
- **Certificate Management** - SSL/TLS certificates

## Resources

### DISA STIG Documentation
- [DISA STIG Library](https://public.cyber.mil/stigs/)
- [VMware vSphere 8.0 STIG](https://public.cyber.mil/stigs/downloads/)

### VMware Documentation
- [vSphere Security Configuration Guide](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-security/)
- [PowerCLI Reference](https://developer.vmware.com/docs/powercli/)

### PowerShell Resources
- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/dev-cross-plat/writing-portable-modules)
- [Pester Testing Framework](https://pester.dev/)

## Getting Help

### Communication Channels
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and ideas

### Development Questions
- Check existing issues and documentation
- Review DISA STIG requirements carefully
- Test in isolated lab environment first

## Recognition

Contributors will be acknowledged in:
- README.md contributors section
- Release notes
- Git commit history

Thank you for helping improve vSphere security compliance!
# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.1.x   | :white_check_mark: |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in this STIG auditor, please report it responsibly:

### How to Report
1. **Do NOT** create a public GitHub issue
2. Email security concerns to the maintainers
3. Include detailed information about the vulnerability
4. Provide steps to reproduce if possible

### What to Include
- Description of the vulnerability
- Potential impact assessment
- Steps to reproduce
- Suggested remediation (if known)
- Your contact information

### Response Timeline
- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Resolution**: Varies based on complexity

### Security Considerations

This tool is designed for security compliance auditing with the following principles:

#### Read-Only Operation
- **No configuration changes** are made to vSphere environments
- **No sensitive data** is stored or transmitted
- **Minimal permissions** required (read-only access)

#### Credential Handling
- Credentials are handled securely using PowerShell SecureString
- **No plaintext passwords** in logs or output
- Support for Windows Credential Manager integration
- Docker containers do not persist credentials

#### Network Security
- All communication uses **encrypted channels** (HTTPS/SSL)
- **Certificate validation** is enforced
- No data transmission to external services

#### Audit Trail
- All operations are **logged locally**
- **No sensitive information** in audit logs
- Compliance results contain **no credentials**

### Best Practices for Users

#### Credential Management
```powershell
# Store credentials securely
$credential = Get-Credential
$credential | Export-Clixml -Path "secure-creds.xml"

# Use stored credentials
$credential = Import-Clixml -Path "secure-creds.xml"
```

#### Network Isolation
- Run audits from **secure management networks**
- Use **dedicated service accounts** with minimal privileges
- Implement **network segmentation** for audit systems

#### Access Control
- Limit access to audit scripts and results
- Use **role-based access control** for vSphere permissions
- Regular **access reviews** for service accounts

### Vulnerability Disclosure

We follow responsible disclosure practices:

1. **Private notification** to maintainers
2. **Coordinated disclosure** timeline
3. **Public disclosure** after fix is available
4. **Credit** to security researchers (if desired)

### Security Updates

Security updates will be:
- **Prioritized** over feature development
- **Clearly marked** in release notes
- **Backported** to supported versions when possible

### Compliance and Standards

This tool helps organizations meet:
- **DISA STIG** requirements
- **NIST Cybersecurity Framework**
- **ISO 27001** controls
- **SOC 2** compliance requirements

### Contact

For security-related questions or concerns:
- Review existing security documentation
- Check GitHub security advisories
- Contact maintainers through appropriate channels

**Note**: This tool is provided for legitimate security compliance purposes only. Users are responsible for ensuring appropriate authorization before auditing any systems.
# vSphere 8 STIG Compliance Auditor

**Author:** LT  
**Version:** 1.0  

---

## Overview

This repository contains a **read-only PowerCLI script** that audits **VMware vSphere 8 environments** against selected **DISA STIG controls**.  

The script **does not perform any configuration changes** – it only queries settings and presents compliance results in the PowerShell/PowerCLI console.

At the end of execution, a **Compliance Summary** is shown with counts of `Pass`, `Fail`, `Warn`, and `Info`.

---

## License for This Repository
This repository’s own content (README, file list, structure) is licensed under the MIT License. See LICENSE for details.

---

## Disclaimer
This script is provided "as is", without any warranty of any kind.
Use it at your own risk. You are solely responsible for reviewing, testing, and implementing it in your own environment.

---

## Compliance Summary Example

Example output after running the script:

Compliance Summary:
Pass : 25
Fail : 3
Warn : 2
Info : 1


---

## Features

- **Read-only auditor** (safe to run with auditor/readonly account).  
- Checks common **vSphere 8 STIG requirements** for:
  - ESXi Host settings (Lockdown, SSH, NTP, Syslog, Account policies, vSwitch security).  
  - vCenter settings (session timeout).  
  - Virtual Machine settings (removable media, device connect controls).  
- Displays results in a formatted table.  
- Provides **compliance summary** at the end.  

---

## Requirements

- **VMware PowerCLI** module installed.  
- Access to **vCenter Server** (and associated ESXi hosts) with at least **read-only permissions**.  
- PowerShell 5.1+ or PowerShell 7.x.  

---

## Usage

1. Clone the repository or download the script:

   ```powershell
   git clone https://github.com/<your-org>/vsphere8-stig-auditor.git
   cd vsphere8-stig-auditor

---

Import PowerCLI if not already loaded:
Import-Module VMware.PowerCLI

Run the script:
.\vsphere8-stig-auditor.ps1 -VCenter vcenter.company.local

If you want to specify credentials:
$secPass = Read-Host "Enter Password" -AsSecureString
.\vsphere8-stig-auditor.ps1 -VCenter vcenter.company.local -Username "auditor@vsphere.local" -Password $secPass

The script will connect, run all compliance checks, print a detailed table of results, and finally show the summary.

---

Notes
* The script is non-intrusive – it does not modify any settings.
* Rule IDs are aligned with DISA vSphere 8 STIGs (e.g., ESXI-80-000008, VCSA-80-000089, VMCH-80-000210).
* Additional STIG checks can be added easily by extending the script.

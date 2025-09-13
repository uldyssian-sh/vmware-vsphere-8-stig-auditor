BeforeAll {
    $scriptPath = Join-Path $PSScriptRoot '..' 'vsphere8-stig-auditor.ps1'
    $script = Get-Content $scriptPath -Raw
}

Describe 'vSphere 8 STIG Auditor' {
    Context 'Script Structure' {
        It 'Should have proper PowerShell syntax' {
            { [scriptblock]::Create($script) } | Should -Not -Throw
        }

        It 'Should contain required parameters' {
            $script | Should -Match 'param\s*\('
            $script | Should -Match '\$VCenter'
            $script | Should -Match '\$Username'
            $script | Should -Match '\$Password'
        }

        It 'Should have SkipVCenterChecks switch' {
            $script | Should -Match '\$SkipVCenterChecks'
        }
    }

    Context 'STIG Rule Coverage' {
        It 'Should check ESXi lockdown mode (ESXI-80-000008)' {
            $script | Should -Match 'ESXI-80-000008'
            $script | Should -Match 'LockdownMode'
        }

        It 'Should check SSH service (ESXI-80-000193)' {
            $script | Should -Match 'ESXI-80-000193'
            $script | Should -Match 'TSM-SSH'
        }

        It 'Should check NTP configuration (ESXI-80-000124)' {
            $script | Should -Match 'ESXI-80-000124'
            $script | Should -Match 'NTP'
        }

        It 'Should check syslog configuration (ESXI-80-000114)' {
            $script | Should -Match 'ESXI-80-000114'
            $script | Should -Match 'Syslog.global.logHost'
        }

        It 'Should check vCenter session timeout (VCSA-80-000089)' {
            $script | Should -Match 'VCSA-80-000089'
            $script | Should -Match 'SessionTimeout'
        }

        It 'Should check VM CD/DVD settings (VMCH-80-000210)' {
            $script | Should -Match 'VMCH-80-000210'
            $script | Should -Match 'CDDrive'
        }
    }

    Context 'Helper Functions' {
        It 'Should have New-CheckResult function' {
            $script | Should -Match 'function New-CheckResult'
        }

        It 'Should validate status values' {
            $script | Should -Match "ValidateSet\('Pass','Fail','Warn','Info'\)"
        }
    }

    Context 'Output and Reporting' {
        It 'Should generate compliance summary' {
            $script | Should -Match 'Compliance Summary'
            $script | Should -Match 'Pass.*Fail.*Warn.*Info'
        }

        It 'Should format results as table' {
            $script | Should -Match 'Format-Table'
        }
    }

    Context 'Error Handling' {
        It 'Should handle connection errors' {
            $script | Should -Match 'Connect-VIServer.*ErrorAction Stop'
            $script | Should -Match 'catch'
        }

        It 'Should disconnect from vCenter' {
            $script | Should -Match 'Disconnect-VIServer'
        }
    }
}
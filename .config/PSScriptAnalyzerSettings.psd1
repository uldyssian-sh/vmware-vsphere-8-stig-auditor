@{
    Severity = @('Error', 'Warning')
    ExcludeRules = @(
        'PSAvoidUsingWriteHost'
    )
    Rules = @{
        PSPlaceOpenBrace = @{
            Enable = $true
            OnSameLine = $true
            NewLineAfter = $true
            IgnoreOneLineBlock = $true
        }
        PSUseConsistentIndentation = @{
            Enable = $true
            Kind = 'space'
            IndentationSize = 2
        }
        PSUseConsistentWhitespace = @{
            Enable = $true
            CheckInnerBrace = $true
            CheckOpenBrace = $true
            CheckOperator = $true
            CheckPipe = $true
        }
    }
}# Updated 20251109_123845
# Updated Sun Nov  9 12:52:08 CET 2025

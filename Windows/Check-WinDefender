Try 
{ 
    $defenderOptions = Get-MpComputerStatus 
 
    if([string]::IsNullOrEmpty($defenderOptions)) 
    { 
        Write-host "Windows Defender was not found running on the Server:" $env:computername -foregroundcolor "Green" 
    } 
    else 
    { 
        Write-host "Windows Defender was found on the Server:" $env:computername -foregroundcolor "Cyan" 
        Write-host "   Is Windows Defender Enabled?" $defenderOptions.AntivirusEnabled 
        Write-host "   Is Windows Defender Service Enabled?" $defenderOptions.AMServiceEnabled 
        Write-host "   Is Windows Defender Antispyware Enabled?" $defenderOptions.AntispywareEnabled 
        Write-host "   Is Windows Defender OnAccessProtection Enabled?"$defenderOptions.OnAccessProtectionEnabled 
        Write-host "   Is Windows Defender RealTimeProtection Enabled?"$defenderOptions.RealTimeProtectionEnabled 
    } 
} 
Catch 
{ 
    Write-host "Windows Defender was not found running on the Server:" $env:computername -foregroundcolor "red"
}

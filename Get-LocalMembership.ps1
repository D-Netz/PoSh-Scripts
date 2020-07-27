<#
checks local group membership for enabled users in the local machine
I will be updating to:
- make it into a function 
- allow pipeline input
- make it easier to work with pipline objects overall
#>

try {
    $MachineName = $ENV:COMPUTERNAME
    $NameQuery = "SELECT * FROM Win32_UserAccount WHERE localaccount = true AND disabled = false"
    $GroupQuery = "SELECT * from Win32_GroupUser"

    $UserInfo = Get-CimInstance -ComputerName $MachineName -Query $NameQuery

    $UserList = $UserInfo.name
    
    foreach ($user in $UserList) {
        $params = @{
            ComputerName = $MachineName;
            Query = $GroupQuery;
            ErrorAction = "Stop"
        }

        $Membership = Get-CimInstance @params `
        | Where-Object {$_.PartComponent.Name -eq $user}
        
        $NameCheck = $Membership.PartComponent.name -eq $user
        $GroupList = $Membership.GroupComponent.Name
        $properties = @{
            Property = @{Label='Domain';Expression={$Membership.PartComponent.Domain}}, `
                    @{Label='Name';Expression={$user}}, `
                    @{Label='GroupName';Expression={$_}}, `
                    @{Label="InGroup?";Expression={$NameCheck}}
        }
        
        $GroupList | Select-Object @properties   
    }
}
catch {
    Write-Host "An Error Occured:" -ForegroundColor Red
    Write-host $_.ScriptStackTrace "----->" $_.CategoryInfo.TargetName $_.CategoryInfo.Category -Foregroundcolor Blue
    Write-Host $_.Exception.Message -ForegroundColor Red
}
finally {
    $error.Clear()
}

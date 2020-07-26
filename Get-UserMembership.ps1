<# 
Read-UserMembership

A variation of Get-LocalMembership that querys WMI on local or remote machines, it list all the groups that a local user has membership to.
I didn't need to use a WQL query for Get-CiMInstance, more like I wanted to practice.
#>

$MachineName = $ENV:COMPUTERNAME
$NameQuery = "SELECT * FROM Win32_UserAccount Where localaccount = true AND disabled = false"

$UserInfo = Get-CimInstance `
-ComputerName $MachineName `
-Query $NameQuery

$UserList = $UserInfo.name

try {
    $GroupQuery = "Select * from Win32_GroupUser"
    
    foreach ($user in $UserList) {
        $params = @{
            ComputerName = $MachineName;
            Query = $GroupQuery;
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
    Write-Output $PSItem.Exception.Message
}

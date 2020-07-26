<# 
Read-UserMembership

A variation of Get-LocalMembership that querys WMI on local or remote machines
to list all the groups that a local user has membership to.
#>

$MachineName = $ENV:COMPUTERNAME 
$NameQuery = "SELECT * FROM Win32_UserAccount Where localaccount = true AND disabled = false"


$UserInfo = Get-CimInstance `
-ComputerName $MachineName `
-Query $NameQuery

$UserList = $UserInfo.name
#$UserList = @("Administrator", "dn3tz")

try {
    $GroupQuery = "Select * from Win32_GroupUser"
    
    foreach ($user in $UserList) {
        $params = @{
            ComputerName = $MachineName;
            Query = $GroupQuery;
        }

        $Membership = Get-CimInstance @params `
        | Where-Object {$_.PartComponent.Name -eq $user}
        
        $NameCheck = $Membership.partcomponent.name -eq $user
        $GroupList = $Membership.GroupComponent.Name
        
        $GroupList 
        | Select-Object `
        @{Label='Domain';Expression={$Membership.PartComponent.Domain}}, `
        @{Label='Name';Expression={$user}}, `
        @{Label='GroupName';Expression={$_}}, `
        @{Label="InGroup?";Expression={$NameCheck}}
        #@{Label="UserSID";Expression={$UserInfo.SID}}   
    }
}
catch {
    Write-Output $PSItem.Exception.Message
}

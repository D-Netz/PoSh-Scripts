#zentyal GPO setup
#this windows server core VM is joined to a Zentyal Domain Controller VM on azure.
# this is my attempt to add a GPO that deploys 7zip to server core.


#log into Azure
import-module az -verbose
Connect-AzAccount

#determine which subscription is active
get-azcontext -listavailable

#list all subscriptions in account
get-azsubscription

#change subscription
select-azsubscription -subscription "sub_name"

#search for all VMs in subscription
$allvms = Get-AzVM  

# narrow down results to resource groups and organize the output
$rg = $allvms.resourceGroupName[0]
$status = Get-AzVM -ResourceGroupName $rg -Status
$status | Select-Object Name, PowerState, ResourceGroupName, Location

# set variable of target VMs as an array
$vms = @($status.name[0],$status.name[2])

#start vms
Start-AzVM -ResourceGroupName $rg -Name $vms[0] -NoWait
Start-AzVM -ResourceGroupName $rg -Name $vms[1] -NoWait

#get the public IP name and address of the server
$pubname2 = (Get-AzPublicIpAddress -ResourceGroupName $rg).Name[2]
$pubip2 = (Get-AzPublicIpAddress -Name $pubname2).IpAddress
# enter port number open to connect remotely to machine
$port = Read-Host "Please enter a port number"

#create placeholders in order to concatenate
$remote = '{0}{1}{2}' -f $pubip2,':',$port

# connect to server using RDP
mstsc /v:$remote

# in remote machine download 7zip
$url = "https://www.7-zip.org/a/7z1900-x64.msi"
$dest = "c:\7zip.msi"
Import-Module BitsTransfer
Start-BitsTransfer -Source $url -Destination $dest

#move file from local drive to shared drive
Move-Item C:\7zip.msi \\zentyal_server_name\sysvol\domain_name\software\

# start group policy management console
gpmc.msc

#create 7zip GPO > link to domain > edit 7zip
#go to Computer Configurations > Policies > Software Settings > Software Installation
#create new package using the source as: \\zentyal_server_name\sysvol\domain_name\software\7zip.msi 
#exit

#update the policy and restart
gpupdate /force
restart-computer

#check to see if GPO installed 7zip
gpresult /V  /SCOPE COMPUTER

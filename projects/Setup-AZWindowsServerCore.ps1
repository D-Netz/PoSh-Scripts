#once Azure vm is created login via RDP
#make sure NSG allows inbound RDP connections from the internet

#get powershell version
$psversiontable

#get & set timezone
Get-TimeZone
Set-TimeZone -Id "eastern Standard Time"

#Get hostname and change it
$env:ComputerName
Rename-Computer -NewName "your_name_here"
Restart-Computer

#Get network ip address/gateway/dns address & change it | you can always use sconfig | lookat NetTCPIP cmdlets
#also.... always check your work!
netstat.exe -rn
Get-NetIPAddress #ipaddr of all ifindex(ies) 
Get-NetRoute -DestinationPrefix 0.0.0.0/0  #lists default gateway 
#if you must...
Remove-NetRoute -DestinationPrefix 0.0.0.0/0 -NextHop "GATEWAY"

Get-DnsClientServerAddress
Get-NetIPConfiguration

#change name of NIC
Get-NetAdapter -InterfaceIndex "IFINDEX"
Rename-NetAdapter -Name "ethernet" -NewName "NEWNAME"
Get-NetAdapter -Name "NEWNAME"

#=================================================================================================================================================================================
#Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty NextHop |#call ip from route table, not inputted manually
#Test-Connection -ComputerName (Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty NextHop) |#test it
#
# -#_#_-# create a function "test-gateway" that is persistent #-#_#_-#
#
#function Test-Gateway {Test-Connection -ComputerName (Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty NextHop) -Quiet}
#Test-Gateway
#Set-ExecutionPolicy remotesigned -force
#New-Item $profile -Force | Out-Null
#Add-Content $profile -Value {function Test-Gateway {Test-Connection -ComputerName (Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty NextHop) -Quiet}}
#
#=================================================================================================================================================================================

#you can also use new-netipaddress
Set-NetIPAddress -InterfaceIndex "index_#" -IPAddress "ip_address" -PrefixLength "subnet_prefix"
Set-DnsClientServerAddress -InterfaceIndex "#" -ServerAddresses "#,#,#"

#=======================================================================================================
#or...
get-DnsClientServerAddress -InterfaceAlias eth0 -AddressFamily ipv4 | Set-DnsClientServerAddress -Addresses 192.168.114.38,1.1.1.1,8.8.8.8
get-DnsClientServerAddress -InterfaceAlias eth0 -AddressFamily ipv4
#=======================================================================================================

New-NetRoute -DestinationPrefix 'ipaddr' -InterfaceIndex '#' -NextHop 'ipaddr' #or Set-NetRoute
Test-Connection -source "svr1" -ComputerName google.com #or test-netconnection -computername "google.com" -port 80 to check if ports are open or do a -traceroute

#if dhcp is default
$currentip = (Get-NetIPAddress -InterfaceIndex '#' -AddressFamily IPv4)
$currentip.PrefixOrigin | Get-Member


#===============================
#change/create a network profile
Get-Help Set-NetConnectionProfile
<#
Set-NetConnectionProfile `
-Name <String[]> `
-InterfaceIndex <UInt32[]> `
-NetworkCategory <NetworkCategory>
#>
Get-NetConnectionProfile

#enable remote desktop connections
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name 'fDenyTSConn
ections' -Value 0
#enable network level authentication
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\
' -Name "UserAuthentication"  -Value 1
#enable Windows Firewall rules to allow incoming RDP connection
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
#activate windows server | not needed for eval iso
slmgr -ato

#Configure automatic updates
cscript scregedit.wsf /AU 4
#check update
cscript scregedit.wsf /AU /v

#Setup printer
Install-WindowsFeature Print-Services
printui.exe /il

#open notepad create a newfile and try to print 
Get-content C:\test.txt | Out-Printer

#add drivers
pnputil.exe #look at the options

#create new Forest
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest `
-DomainName "DOMAIN.com" `
-DomainNetbiosName "DOMAIN" `
-CreateDnsDelegation:$false  `
-InstallDns:$true `
-DatabasePath "C:\Windows\NTDS" `
-SysvolPath "C:\Windows\SYSVOL" `
-LogPath "C:\Windows\NTDS" `
-DomainMode "7" `
-ForestMode "7" `
-SafeModeAdministratorPassword(ConvertTo-SecureString -AsPlainText "PASSWORDHERE" -Force) `
-NoRebootOnCompletion:$true

#confirm successful installation of the services
Get-Service adws,kdc,netlogon,dns
Get-ADDomainController
Get-ADDomainController skifree.ntz
Get-ADForest skifree.ntz

#check if DC is sharing SYSVOL folder
Get-smbshare SYSVOL

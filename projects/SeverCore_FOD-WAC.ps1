
### On a Windows 2019 Sever Core VM I am installing Features on Demand and then installing Windows Admin Center###
#this machine is joined to a Zentyal DC on Azure, they are both in the same Vnet.

### install Features on Demand
Add-WindowsCapability -Online -Name ServerCore.AppCompatibility~~~~0.0.1.0

### Install group policy management console
Add-WindowsFeature -Name GPMC

### change timezone to match domain
Set-TimeZone -Id 'Pacific Standard Time'

### change dns server to zentyal's ip
get-netadapter
$ifindex = (get-netadapter).ifIndex
$svrip = 10.0.0.4
set-dnsclientserveraddress -interfaceindex $ifindex -serveraddresses $svrip

Test-Netconnection netzel.lan
### in sconfig join netzel.lan domain

### add my home ip address as a trusted host & set up WinRM/firewall for remote mgmt
“Set-Item WSMan:\localhost\Client\TrustedHosts -Value "my_local_ip"
Enable-PsRemoting -Force
### Enable-PSRemoting -SkipNetworkProfileCheck -Force (if having trouble)

<#
 configure the Network Security Group 
 for the Azure VM to allow port 
 5985 (HTTP) or 5986 (HTTPS), ICMP to my home ip address and 10.0.0.0/24 network
#>

### set up my local machine for remote managmement: ###
set-item WSMan:\localhost\Client\TrustedHosts -Value '13.64.235.11'
Enable-PsRemoting -Force
Test-WSMan 13.64.235.11

### copies WAC msi file from local to svrcore2
### creates a new pssession and removes it when complete
Copy-Item `
–Path 'C:\learn\svrcore2\WindowsAdminCenter1910.2.msi' `
–Destination 'C:\' `
–ToSession (NewPSSession –ComputerName 13.64.235.11 -Credential .\daniel)

### On svrcore2 ###

mv C:\wac.msi \\dc1\sysvol\netzel.lan\scripts\WindowsAdminCenter
cd \\dc1\sysvol\netzel.lan\scripts\WindowsAdminCenter

### create script to be used for GPO
notepad wac.ps1

gpmc.msc

<#
 create a GPO named Default Software,
 link GPO to domain (netzel.lan)
 click netzel.lan > Default Software > edit. Group Policy Management Editor will open
 go to Computer Configuration > Policies > Windows Settings > Scripts > Startup
 In Startup Properties click on the Powershell Scripts tab > Show Files...
 copy wac.ps1 over to your policy's startup script folder. Copy the folder path.
 back in Startup Properties click on Add... > paste the folder path copied.
 exit
#>

gpupdate /force
restart-computer







### found a Quicker/more secure way of downloading WAC on to svrcore2 ###
$url = "https://aka.ms/WACDownload"
$output = "c:\wac.msi"

Import-Module BitsTransfer
Start-BitsTransfer -Source $url -Destination $output

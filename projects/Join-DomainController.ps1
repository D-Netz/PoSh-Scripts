# AWS Domain Joining Guide

# Use this ip address as your domain name server for your DHCP configuration in AWS
ipconfig
# or ipconfig /all
Set-TimeZone -Id "Eastern Standard Time"
pause
Rename-Computer -NewName "DC01" -Restart
# DNS and domain name should be automatically configured at startup
# if not, configure DNS in sconfig or you can use powershell:
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses your-dns-address

# Install an Active Directory forest
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "netzel.me" `
-DomainNetbiosName "NETZEL" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

 #create a new user
 New-ADUSer `
-Name 'Daniel Netzel' `
-GivenName 'Daniel' `
-Surname 'Netzel' `
-SamAccountName 'dnetzel' `
-UserPrincipalName 'dnetzel@netzel.me' `
-Path 'CN=Users,DC=netzel,DC=me'
-AccountPassword(Read-Host -AsSecureString 'Type Password for User') `
-Enabled $true

# confirm user creation
Get-ADUser dnetzel

# Add the user to Domain Admin group
Add-ADGroupMember -Identity 'Domain Admins' -Members 'dnetzel'

# confirm group addition
Get-ADGroupMember -Identity "Domain Admins"


#    --------
#   | # DC02 |
#    --------

Rename-Computer -NewName "DC02" -Restart
Set-TimeZone -Id "Eastern Standard Time"
# configure DNS settings if not already setup
# use ping, nslookup, Resolve-DnsName to test DNS connection
# make sure you can ping DC01's ip address and domain name or else you wont be able to join

#Join DC02 to DC01's Domain
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSDomainController  -DomainName "netzel.me" -credential $(get-credential)

# Use the following credentials:
# username = netzel.me\Administrator
# password = AWS decrypted password for DC01

# After installation, RDP to DC02 using:
# username = netzel.me\Administrator OR NETZEL\Administrator OR Administrator@netzel.me
# password = DC01 decrypted password
#--------------------------------
# RDP to DC02 with previously created user:
 username = netzel.me\dnetzel
 password = P@$$w0rd
#---------------------------------
# If you want to unjoin DC02 for whatever reason:
 Uninstall-ADDSDomainController

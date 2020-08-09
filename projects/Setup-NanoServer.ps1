# Building and configuring Nano Server from a Server Core 2016 Domain Controller on virtualbox, later replicated on to AWS

# Download windowsServer2016 and virtIO ISO

#server2016
https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2016?filetype=ISO
#virtIO, choose ### STABLE virtio-win iso ###
https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/

#copy ISOs to shared folder

#mount shared folder onto virtual machine
net use Z: \\vboxsvr\'shared_folder_name'

#copy ISOs from shared folder to local C: drive in server core
copy-item "2016_iso_file" "C:\" -recurse -verbose
copy-item "VirtIO_iso_file" "C:\" -recurse -verbose
#mount ISOs
mount-diskimage -imagepath "path_to_windows_iso"
mount-diskimage -imagepath "path_to_virtio_iso"

#locate nanoserver/nanoserverimagegenerator folder from 2016 ISO && import nanoserver commands
import-module "location_of_NanoServerImageGenerator.psd1"

# create nano server VHD, input path locations where specified
# modify to better suit your needs

New-NanoServerImage `
-AdministratorPassword(ConvertTo-SecureString 'P@$$w0rd' -AsPlainText -force) `
-MediaPath 'windows_iso_path_here' `
-Edition 'Datacenter' `
-DeploymentType Guest `
-TargetPath 'C:\Nano\Nano.vhd' `
-MaxSize 10GB `
-DomainName 'domain_name_here' `
-ReuseDomainNode `
-EnableRemoteManagementPort `
-SetupUI ('NanoServer.Containers') `
-DriverPath ('VirtIO_ISO_drive_letter_here:\NetKVM\2k16\amd64\netkvm.inf') `
-ComputerName 'nano' `
-SetupCompleteCommand ('tzutil.exe /s "Eastern Standard Time"') `
-LogPath 'C:\Nano\Logs\'

# Copy vhd to shared folder
copy-item "C:\Nano\Nano.vhd" "shared_folder_path_here"

#create a virtual machine and use the Nano.VHD as the storage
# set up the VM's networking and use the virtIO network adapter
#ideally use a nat network
#startup nano server vm
#login using local administrator credentials
## Administrator
## P@$$w0rd
## leave domain name blank for now

# go to networking > ethernet > press F11 (IPV4 Options)
# disable DHCP and give a static ip address to nano server
smb-in
icmp-v4-IN
# enable inbound and outbound firewall settings

# from domain controller ping nano server's ip address
ping "nanoserver's_ip_address"

# check timezone and date 
timezone 
date
# connect remotely to nanoserver from domain controller
set-item wsman:\localhosts\client\trustedhosts -value "nano_ip_address"
Enter-PSSession -computername "nanoserver's_ip" -credential "nanoserver's_ip"\Administrator

# confirm nanoserver's timezone and date are synchronized with DC1
timezone
date

#check adapter settings and ** take note of the index number **
get-netadapter

# setup dns addresses
get-dnsclientserveraddress
Set-DnsClientServerAddress -interfaceindex "index_number_here" -ServerAddresses "DC_ip_address, 1.1.1.1"

# ping your domain name  and DC ip address
ping "domain_name_here"
ping "DC_ip_here"

# exit and restart nano server
#login using domain credentials

## Administrator
## P@$$w0rd
## domain_name.me

# if successful reconnect to nano server from DC1
enter-pssession "nano"

 # check for updates and update nano server 
$ci = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession  
$result = $ci | Invoke-CimMethod -MethodName ScanForUpdates -Arguments @{SearchCriteria="IsInstalled=0";OnlineScan=$true}
$result.Updates

$ci = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
Invoke-CimMethod -InputObject $ci -MethodName ApplyApplicableUpdates
shutdown /r /t 10; exit

$ci = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
$result = $ci | Invoke-CimMethod -MethodName ScanForUpdates -Arguments @{SearchCriteria="IsInstalled=1";OnlineScan=$true}
$result.Updates

# Install nuget package provider
install-packageprovider name NuGet -minimumversion 2.8.5.201 -force -verbose


Save-Module -Path "$Env:ProgramFiles\WindowsPowerShell\Modules\" -Name NanoServerPackage -MinimumVersion 1.0.1.0
Import-PackageProvider NanoServerPackage


# look for and install nanoserver package manager
find-packageprovider -name nanoserverpackage -minimumversion 1.0.1.0 | install-packageprovider -verbose

#if there are issues with installing the NanoServerPackage module
Install-Module -Name NanoServerPackage -SkipPublisherCheck -Force -Verbose

#once installed we can view a list of features for nano server
find-nanoserverpackage -allversions -name *


#list installed packages
get-package -providername nanoserverpackage

get-package -providername nanoserverpackage | get-member | format-table -autosize

install-nanoserverpackage microsoft-nanoserver-iis-package
start-service WAS -verbose
start-service W3SVC -verbose

new-netfirewallrule -displayname 'http' direction Inbound -action allow -protocol TCP -localport 80

get-netroute
get-nettcpconnection | ? State -eq Established | RemoteAddress -notlike 127* | % {$_; Resolve-dnsname $_.Remoteaddress -type PTR -Erroraction SlientlyContinue }
        


<#
"storageProfile": {
    "imageReference": {
        "publisher": "MicrosoftWindowsServer",
        "offer": "WindowsServer",
        "sku": "2016-Datacenter-Server-Core-smalldisk",
        "version": "latest"
    },

$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);
#>

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Get Started
----------------------------------------------------------------------------------------------------------------------------------------------------------------

#create a resource group management and deployment
New-AzResourceGroup -ResourceGroupName "resource_group_name" -Location "EastUS"


<# server 2016 is the default if no image is specifed when creating a VM,
 find the image you want to use for your VM. #>
Get-AzVMImagePublisher -Location "EastUS"
Get-AzVMImageOffer -Location "EastUS" -PublisherName "MicrosoftWindowsServer"
Get-AzVMImageSku -Location "EastUS" -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer"

# find the VMsizes available 
Get-AzVMSize -Location "EastUS"

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Option 1
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# build settings for the new VM
$LocationName = "EastUS"
$ResourceGroupName = "name_of_resourcegroup"
$ComputerName = "Name_of_computer"
$VMName = "Name_of_VM"
$VMSize = "Standard_D4s_v3"
$cred = (Get-Credential)

$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Cred -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2016-Datacenter-Server-Core' -Version latest


#create Azure VM
New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine -SecurityGroupName "name_of_security_group" -Verbose

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Option 2
----------------------------------------------------------------------------------------------------------------------------------------------------------------
New-AzVm `
    -ResourceGroupName "myResourceGroupVM" `
    -Name "myVM2" `
    -Location "EastUS" `
    -VirtualNetworkName "Nested_VM2" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress2" `
    -ImageName "MicrosoftWindowsServer:WindowsServer:2016-Datacenter-Server-Core:latest" `
    -Size "Standard_D4s_v3" `
    -Credential $cred `
    -AsJob

# As-Job sends the installion as background job , you can view jobs by using Get-Job    
----------------------------------------------------------------------------------------------------------------------------------------------------------------
<#
 or...

New-AzVM `
-ResourceGroupName "Nested_VM" `
-Name "HyperV1" `
-Location "EastUS" `
-SecurityGroupName "myNSG" `
-ImageName "MicrosoftWindowsServer:WindowsServer:2016-Datacenter-Server-Core:latest" `
-Size "Standard-D4s_v3" ` #Standard_E2_v3
-OpenPorts 22,443,3389,5985 `
-DomainNameLabel "HyperV1" `
-Credential (Get-Credential)

# mydnsname.westus.cloudapp.azure.com
#>
----------------------------------------------------------------------------------------------------------------------------------------------------------------
connect to your VM
----------------------------------------------------------------------------------------------------------------------------------------------------------------
#after AzVM is built, find ip address to connect
Get-AzPublicIpAddress -ResourceGroupName "myResourceGroupVM"  | Select IpAddress

#you can use this to create a remote desktop connection, or you can use RDP app and input info through there
mstsc /v:<publicIpAddress>

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Manage your VM
----------------------------------------------------------------------------------------------------------------------------------------------------------------

#check state of VM
Get-AzVM `
-ResourceGroupName "myResourceGroupVM" `
-Name "myVM" `
-Status | Select @{n="Status"; e={$_.Statuses[1].Code}} 

#stops a VM
Stop-AzVM `
-ResourceGroupName "myResourceGroupVM" `
-Name "myVM" -Force

#starts a VM
Start-AzVM `
-ResourceGroupName "myResourceGroupVM" `
-Name "myVM"

# delete a resource group
Remove-AzResourceGroup `
-Name "myResourceGroupVM" `
-Force

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Install Hyper-V
----------------------------------------------------------------------------------------------------------------------------------------------------------------

#New-NetFirewallRule -displayname 'Allow All Traffic' -direction outbound -action allow
#New-NetFirewallRule -displayname 'Allow All Traffic' -direction inbound -action allow
Install-WindowsFeature -ComputerName HYPERV1 -Name 'hyper-v'
Install-WindowsFeature -ComputerName HYPERV1 -Name 'rsat-hyper-v-tools'
Install-WindowsFeature -ComputerName HYPERV1 -Name 'hyper-v-powershell' -Restart
    
----------------------------------------------------------------------------------------------------------------------------------------------------------------
Build nested VM
----------------------------------------------------------------------------------------------------------------------------------------------------------------

New-VMSwitch 'External' –NetAdapterName "Ethernet"  -SwitchType External –AllowManagementOS $false
New-VM `
-ComputerName [HyperV1] `
-Name VM1 `
-Generation 2 `
-MemoryStartupBytes 1GB `
-NewVHDPath ‘C:\VMs\VM1.vhdx’ `
-NewVHDSizeBytes 60000000000 `
-SwitchName External `
-WhatIf
Start-VM -ComputerName [HyperV1] -Name VM1
Get-VM -ComputerName [HyperV1] -Name VM1
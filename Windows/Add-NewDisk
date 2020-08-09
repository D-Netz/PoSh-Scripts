$disks = Get-StoragePool -IsPrimordial $true | 
Get-PhysicalDisk | Where-Object CanPool -eq $True

$storageSubsystem = Get-StorageSubSystem

New-StoragePool -FriendlyName StoragePool `
    -StorageSubsystemFriendlyName $storageSubsystem.FriendlyName `
    -PhysicalDisks $disks

New-VirtualDisk -FriendlyName VirtualDisk `
    -StoragePoolFriendlyName StoragePool `
    -ResiliencySettingName Parity `
    -ProvisioningType Fixed `
    -PhysicalDiskRedundancy 1 `
    -UseMaximumSize

Get-VirtualDisk -FriendlyName VirtualDisk | 
Get-Disk | Initialize-Disk -Passthru | 
New-Partition -AssignDriveLetter -UseMaximumSize | 
Format-Volume -FileSystem NTFS

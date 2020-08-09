Get-WindowsFeature | Where-Object {$_.Name -match 'NFS'}

Install-WindowsFeature FS-NFS-Service `
-IncludeAllSubfeatures `
-IncludeManagementTools

mkdir F:\Storage\NFS

New-NfsShare `
-Name nfs01 `
-Path F:\Storage\NFS `
-EnableUnmappedAccess $True

Get-NfsShare

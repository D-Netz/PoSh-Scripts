mkdir F:\Storage\Data\shares

New-SmbShare `
-Name Public `
-Path F:\Storage\Data `
-FolderEnumerationMode AccessBased

Get-SmbShare

New-SmbShare Legal_Dept `
-Path $Path `
#-FullAccess 'netzel.lan\sowens' `
-FolderEnumerationMode AccessBased 

#make sure that this machine can ping DC1

Install-WindowsFeature AD-Domain-Services
Import-Module ADDSDeployment

Install-ADDSDomainController `
-Credential (Get-Credential) `
-DomainName 'netzel.me' `
-InstallDNS:$true `
-ReadOnlyReplica:$true `
-SiteName "Default-First-Site-Name" `
-Force:$true

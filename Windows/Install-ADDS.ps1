$URK = "administrator@netzel.me"
$PSS = ConvertTo-SecureString -String 'P@$$w0rd' -AsPlainText -Force
$CredRK = New-Object System.Management.Automation.PSCredential $URK,$PSS
$IHT=@{
DomainName = 'netzel.me'
SafeModeAdministratorPassword = $PSS
SiteName = 'Default-First-Site-Name'
NoRebootOnCompletion = $true
Force = $true
 }
Install-ADDSDomainController @IHT -Credential $CredRK

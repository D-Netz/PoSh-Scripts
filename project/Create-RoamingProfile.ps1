#-----#
# DC1 #
#-----#
#set timezone, hostname, DNS settings and install necessary prerequisites

#create OUs
New-ADOrganizationalUnit -Name "Legal" -Path "OU=Departments,DC=netzel,DC=me"

New-ADOrganizationalUnit -Name "Legal Users" -Path "OU=Legal,OU=Departments,DC=netzel,DC=me"

#create user
New-ADUser `
-Name "Sandra Owens" `
-GivenName Sandra `
-Surname Owens `
-SamAccountName sowens `
-UserPrincipalName sowens@netzel.me `
-AccountPassword(Read-Host -AsSecureString "Type Password for User") `
-Enable $true
-Path "OU=Legal Users,OU=Legal,OU=Departments,DC=netzel,DC=me"

# add sowens to domain admins 
Add-ADGroupMember -Identity "Domain Admins" -Members sowens

# create sowens folder

$Path = "C:\Profiles\"
New-Item -Path $Path -Name Profiles -ItemType Directory
# or mkdir $Path 

# make folder a share folder
New-SmbShare Profiles `
-Path $Path `
-FolderEnumerationMode AccessBased `

# make folder a share 
Set-AdUser -Identity sowens -ProfilePath \\DC01\Profiles\%username%

# give sowens full rights and access
Grant-SmbShareAccess Profiles -AccessRight Full -AccountName sowens

Unblock-SmbShareAccess Profiles -AccountName sowens

Add-NTFSAccess `
-Path $Path `
-Account netzel.me\sowens `
-AccessRights FullControl `
-AccessType Allow `
-AppliesTo ThisFolderSubFoldersAndFiles

# give sowens recursive ownership of share path
Get-ChildItem -Path C:\Profiles\ -Recurse -Directory | Set-NTFSowner -Account 'netzel.me\sowens'

#make some Files
'Test File' | Out-File -FilePath C:\Profiles\sowens\test1.txt

#Check for correct configuration
# user info
Get-aduser sowens -Properties ProfilePath,MemberOf

#smb share info
get-SmbShare Profiles

# Display ACL security setting using access method
(get-acl -path $Path).Access 

# Displays current rights of folders in C:\Profiles 
Get-ChildItem -Path C:\Profiles\ -recurse `
| Get-NTFSEffectiveAccess -Account "sowens" `
| select Account, AccessControlType, AccessRights, Fullname 

#-------------------#
# Windows 10 client #
#-------------------#
# change hostname
rename-computer -newname Client1

# sync time and date with DC1
Set-TimeZone -ID "Eastern Standard Time"

# Configure DC1 as DNS
Get-NetAdapter
Set-DNSClientServerAddress -InterfaceIndex 8 -ServerAddresses 192.168.0.11, 1.1.1.1

# Join netzel.me domain
Add-Computer -DomainName netzel.me -Credential netzel.me\Administrator

# Mount Profiles smbshare to X:
New-SmbMapping -LocalPath X: -RemotePath \\DC01\Profiles

#create file 
'Hello world' | Out-File -FIlePath X:\sowens.V6\hello.txt

# Check for correct configuration
# gathers info on the shared directory
Get-SmbMapping -LocalPath X: | Select-Object -property *

# Displays items inside X:
Get-ChildItem -Path X:

# Displays estblished connection from the client to the server
Get-SmbConnection

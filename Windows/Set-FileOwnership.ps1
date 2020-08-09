# Make sowens the owner of a folder

$Path = C:\your\path\here
$ACL = get-acl $Path
$User = New-Object System.Security.Principal.NTAccount('netzel.lan', 'sowens')
$ACL.SetOwner($User)
Set-Acl -Path $Path -AclObject $ACL
#or 
$acl | set-acl \\server\share\files

#or
takeown -r -f C:\file\path\here

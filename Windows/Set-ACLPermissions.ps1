#create variable 
$acl = Get-Acl \\server\shared\files

# Set rule
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("netzel.lan\sowens","FullControl","Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl \\Server\shared\files

# Remove
$acl.RemoveAccessRule($AccessRule)
$acl | Set-Acl \\server\share\files

$userid = New-Object System.Security.Principal.NTAccount('netzel.lan', 'sowens')
$acl.PurgeAccessRules($userid)
$acl | set-Acl \\server\share\files

# Disable
$acl.SetAccessRuleProtection($true,$false)
#first parameter = blocks inheritance from parent
#second parameter = retains current inherited permissions
# this disables inheritance and deletes all inherited permissions

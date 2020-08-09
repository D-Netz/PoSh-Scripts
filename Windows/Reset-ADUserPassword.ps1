#reset user password on server core 2016

$user = Read-Host "Enter the user" 
$newpwd = Read-Host "Enter the new password" -AsSecureString
Set-ADAccountPassword $user -NewPassword $newpwd -reset

#write the password to pipeline with -PassThru
#you get user object that is piped to Set-ADUser
#forces pwd reset at logon
$pwdchange = Set-ADAccountPassword $user -NewPassword $newpwd -reset -PassThru | Set-ADUser -ChangePasswordAtLogon $True

#Get enabled marketing user accounts and force pwd reset
$CheckMarketing = Get-ADUser -Filter "department -eq 'marketing' -AND enabled -eq 'True'"
$CheckMarketing | $pwdchange

# enable user
Enable-ADAccount -Identity "SamAccountName"

# or pipe it
Get-AdUser $user | Enable-ADAccount

#move aduser OU
Get-ADUser $user | Move-ADObject -TargetPath "OU=Users,DC=netzel,DC=lan"

#get member type (AD management of ADUser)
get-aduser $user -Properties * \ Get-Member -MemberType Property

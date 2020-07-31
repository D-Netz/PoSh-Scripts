#Notes and Examples on new features of PowerShell 7


#ternary operators

$condition = $true
if {$condition} {$x = 1} else {$x=2}
$x

$x = if (-not $condition) {1} else {2}
$x

$x = $condtion ? 1 : 2
$x

$x = -not $condtion ? 1 : 2
$x
-------------------------------------------------
case sensitive comparision
$strcmp = $IsWindows ? [System.StringComparison]::OrdinalIgnorCase : [System.StringComparison]::Ordinal
$strcmp

$y -eq null
true
$z = if ($y -eq $null) {'a'} else {'b'}
$z # equals a

default to its value if not null
$z = if ($y -eq $null) {'a'} else {'b'}

shorter version of null
---------------------------------------------------
$y = $null
$z = $y ?? 'b'
$z  # b

$y = a 
$z = $y ?? 'b'
$z # a

$z ??= 'c'
$z # a because a was the value of z

$z = $null
$z ??= 'c'
$z # c because $z was null

#---------------------------------------------------
#Pipeline chain operators
#----------------------------------------------------
#bash example
sudo apt install powershell && pwsh -command Write-Host "heloo"

new-item -force .\alc.txt

#cmd version of giving permissons to file; same thing different formats
icalcs.exe .\acl.txt /grant "$(whoami):{(F)}"; if  ($?) {Write-Host "ACL set"}
icalcs.exe .\acl.txt /grant "$(whoami):{(F)}"; if  ($LASTEXITCODE -eq 0) {Write-Host "ACL set"}
icalcs.exe .\acl.txt /grant "$(whoami):{(F)}" && Write-Host "ACL Set"

icalcs.exe .\acl.txt /setowner Administrator

icalcs.exe .\acl.txt /setowner Administrator || $(throw 'Ownership not set')

#example of non-successful commands running through the pipeline; error is suppressed
get-item ./notexists.txt -ErrorAction ignore; $?

#better way to test for false or error and write to prompt
get-item ./notexists.txt -ErrorAction Ignore || Write-Host "File Not Found"

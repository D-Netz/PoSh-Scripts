<#
checks local group membership for enabled users in the local machine
I will be updating to:
- make it into a function 
- allow pipeline input
- make it easier to work with pipline objects overall
#>

$localusr = get-localuser -name * | 
Where-Object {$_.Enabled -eq $true -and $_.ObjectClass -match "([u,U]ser)"}

$groups = @("Administrators", "Users")


    try {
        ForEach ($group in $groups) {   
            $params = @{
                Group = $group ;
                Member = $localusr.Name ;
                ErrorAction = "Stop"
            }
            $properties = @{
                Property = @{Name='GroupName'; Expression={$group}},
                        "Name",
                        "ObjectClass",
                        #"PrincipalSource",
                        @{Name='InGroup?'; Expression={$true}}
            }
            Get-LocalGroupMember @params | Select-Object @properties  
        }
    }
    catch [Microsoft.PowerShell.Commands.PrincipalNotFoundException]{
        "-" * 50
        Write-Output "`nPrinicpal $localusr was not found in the $group group"
    }
    catch {
        Write-Output $PSItem.Exception.Message -ForegroundColor RED
    }
    finally {
        $Error.Clear()
    }

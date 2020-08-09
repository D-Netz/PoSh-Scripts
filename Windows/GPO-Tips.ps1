#GPO forced update
gpupdate /force
#or
invoke-gpupdate -computer "$computername" -Target "User" -force
invoke-gpupdate -computer "$computername" -Target "Computer" -force

#Group Policies Object can be applied to sites or domains or Organizational Unit

#you can block block inheritance

#centalize control over domain, site, application behavior, computer settings, user settings (user restrictions).

#local group policies (LGPO)
#>> useful for public locations
##>> kiosks

## change gpo policies gpedit.msc

## starter GPO's
#templates, quick way to get a policy set, can be changed tweaked, 
#>> server manager >> Tools >> Group Policy >> Management >> Domains >> starter GPO's

#check for snapin's of apps we can use in server core's FOD install.

#in order to use dsa.msc
#Remote server Admin Tools
Get-WindowsFeature -Name RSAT-AD-Tools
Install-WindowsFeature -Name RSAT-AD-Tools

#now run dsa.msc (Active directory user and computers snap-in)
#gpedit.msc
#gpmc.msc

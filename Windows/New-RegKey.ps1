$regpath = path_location
$name = name_of_regkey
$value = value_of_key
$type = type_of_key
$procname = process_name

#create new regkey
New-ItemProperty -Path $regpath -Name $name -Value $value -PropertyType $type

#make sure new item is listed
Get-ItemProperty -Path $regpath

#restart explorer to see changes
Stop-Process -ProcessName $procname

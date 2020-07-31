# turn on ip forwarding on remote machine, that has a public IP,
# if you want to use a Windows VM to redirect traffic in Azure

#connect via RDP
mstsc /v:machine_ip:port

#change regkey value
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters -Name IpEnableRouter -Value 1

#reset machine or explorer
restart-computer
#Stop-Process -ProcessName Explorer.exe

#enable ICMP to check on machine
New-NetFirewallRule –DisplayName "Allow ICMPv4-In" –Protocol ICMPv4

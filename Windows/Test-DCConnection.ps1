#Connectivity test to promote DC02 and DC3(RODC)

#Checks if DC01 can be resolved from DC02
 Resolve-DnsName `
 -Name DC01.contoso.com `
 -Server DC01 `
 -Type A
 
 #Checks the connection to DC01 over ports:
 # 445 (SMB over IP) &  389 (LDAP). 
 # Used to access group policy details by joined PC's.
Test-NetConnection `
-ComputerName DC01.contoso.com `
 -Port 445

Test-NetConnection `
-ComputerName DC01.contoso.com`
-Port 389

#ping and nslookup can also be used.

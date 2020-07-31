#run a docker container running on Ubuntu via WSL 2 on Windows 10 Azure VM
#Win 10 VM is a computer joined to a Zentyal DC, both in Azure ins the same VNet

#1st steps
#create windows 10 VM from portal and RDP into win10client
#add rules to win10client NSG allowing ports 8080, 80, 443 and ICMP from the outside

# change timezone to match domain
Set-TimeZone -Id 'Pacific Standard Time'

# change dns server to zentyal's ip
get-netadapter
$ifindex = (get-netadapter).ifIndex
$svrip = 10.0.0.4
set-dnsclientserveraddress -interfaceindex $ifindex -serveraddresses $svrip

#test connection to netzel.lan
nslookup netzel.lan 
nslookup dc1.netzel.lan    
ping dc1.netzel.lan 

#join netzel.lan via control panel

#enable windows subsystem for Linux
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

#enable virtual machine platform
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

#enable full diagnostics/telemetry
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection /v AllowTelemetry /t REG_DWORD /d 

#go to settings > windows insider program > sign up & sign in
#choose Fast rollout stream and update machine. Restart as necessary until machine is up to date for WSL 2

#verify Windows version is verison 2004, build 19041 or higher
winver

#allow port 8080 from the outside
new-netfirewallrule -displayname "allow 8080" -direction Inbound -Profile Any -LocalPort 8080 -Protocol TCP -InterfaceType Any -RemoteAddress Any

#download Ubuntu for WSL and install distro
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -Outfile C:\distros\ubuntu1804.appx -UseBasicParsing
Add-AppxPackage C:\distros\ubuntu1804.appx

#set WSL 2 as default version for all distros and make ubuntu run under WSL 2
wsl --set-default-version 2
wsl --set-verison Ubuntu-18.04 2

#list and start ubuntu
wsl -l
wsl -d Ubuntu-1804
#----------------------------------------------------------------------------
# create user/passwd in Ubuntu
sudo apt-get update; sudo apt-get upgrade -y

#download docker script to current directory, modify permissions, run script
curl -fsSL https://get.docker.now -o get-docker.sh
chmod 744 get-docker.sh
.\get-docker.sh

#when prompted add user to docker group (enabled after next login)
sudo usermod -aG docker daniel

#check status and start docker 
service docker status
sudo service docker start
service docker status

#download snipe-it image
docker pull snipe/snipe-it

#modify snipe-it env file 
vim snipe-it_env 
#--------------------------------------------------
# snipe-it_env parameters
#--------------------------------------------------
#Mysql Parameters
MYSQL_ROOT_PASSWORD=QSWAszax12!@
MYSQL_DATABASE=snipeit
MYSQL_USER=snipeit
MYSQL_PASSWORD=QSWAszax12!@

# Email Parameters
# - the hostname/IP address of your mailserver
MAIL_PORT_587_TCP_ADDR=smtp.whatever.com
#the port for the mailserver (probably 587, could be another)
MAIL_PORT_587_TCP_PORT=587
# the default from address, and from name for emails
MAIL_ENV_FROM_ADDR=WinterMu_@outlook.com
MAIL_ENV_FROM_NAME=WinterMu
# - pick 'tls' for SMTP-over-SSL, 'tcp' for unencrypted
MAIL_ENV_ENCRYPTION=tcp
# SMTP username and password
MAIL_ENV_USERNAME=snipeit
MAIL_ENV_PASSWORD=QSWAszax12!@

# Snipe-IT Settings
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:JW6jAAB2ABNaP3KX+rD61YWIJaXIrjwUFOarD54Jk2Y=
APP_URL=http://gateway.docker.internal:8080
APP_TIMEZONE=US/Pacific
APP_LOCALE=en

#--------------------------------------------------------
# note: APP-KEY base64 is generated in later steps
#--------------------------------------------

#start MYSQL container, make sure you are in the same location as the snipe-it_env file
docker run --name snipe-mysql --env-file=snipe-it_env --mount source=snipesql-vol,target=/var/lib/mysql -d -P mysql:5.6

#start snip-it container to generate a value for APP_KEY and quickly remove container; add base64 to snipeit-env variable APP_KEY=
docker run --rm snipe/snipe-it
vim ./snipe-it_env


#start snipe-it container linking to mysql as its database, maping volumes and linking host 8080 to container 80
docker run -d p 8080:80 --name"snipeit" --link snipe-mysql:mysql --env-file=snipe-it_env -mount= source=snipe-vol,dst=/var/lib/snipeit snipe/snipe-it

#-----------------------------------------------------------------------------------------------------------------
#In windows 10 host
#---------------------
#open new powershell window and download docker desktop
Invoke-WebRequest -Uri https://download.docker.com/win/stable/Docker%20Desktop%20Installer.exe -Outfile dockerdesk.exe -UseBasicParsing

#install docker desktop
.\dockerdesk.exe
#once installed go to docker desktop dashboard > wsl integration > click on 'enable integration.....' and turn on integration with Ubuntu


#test connection to snipeit container from host
ping gateway.docker.internal

#verify snipe-it is reachable via localhost in browser
http://localhost:8080

#connect to its public ip address and port 8080
http://win10client_ipaddr:8080

#start Snipe-IT setup via web browser

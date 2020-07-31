#create a ssh tunnel from zentyal in azure to local machine
ssh -L 8443:127.0.0.1:8443 username@azure_vm_ip

#create a user
sudo useradd zentyal -M -s /sbin/nologin -c "Zentyal Administrator"

#no files or directories made#  #cant log in#
#Add to supplementary groups (sudo rights)
sudo usermod -aG sudo zentyal

#Add password
sudo password zentyal
#add your password#

#Create a 1gig swap file or 2048 2gig
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024

#make the swap file (copy UUID)
sudo /sbin/mkswap /var/swap.1

#change permissions
sudo chmod 600 /var/swap.1

#modify fstab file, add new line
sudo vi /etc/fstab
/var/swap.1 swap swap defaults 0 0

#turn on swap file
sudo /sbin/swapon /var/swap.1

#mount the swap file
sudo mount -a

#make the changes to fstab talk to kernel and recognize changes
#partprobe

#you should see swap
free -m

#log into zentyal

#you should have access whether you choose external in zentyal
#since you are locally connected to your machine

#choose external networks

#after you finish installation:
#filter rules from external networks to zentyal:

#accept any zentyal webadmin zentyal webadmin
#accept any ssh ssh


and traffic coming out from zentyal
 

$ssh into zentyal go into:
cd /usr/share/zentyal-samba

#look at groups-import.pl users-import.pl

#match the fields of the csv file as indicated in users-import.pl

#call csv file users.csv

#run pearl script with the argument as: users.csv 

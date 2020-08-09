New-ADOrganizationalUnit -Name "Departments" -Path "dc=netzel, dc=lan"


New-ADOrganizationalUnit -Name "Accounting" -Path "ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Marketing" -Path "ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Information Technology" -Path "ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Human Resources" -Path "ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Sales" -Path "ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Research" -Path "ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Engineering" -Path "ou=Departments, dc=netzel, dc=lan"


New-ADOrganizationalUnit -Name "Accounting Users" -Path "ou=Accounting, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Marketing Users" -Path "ou=Marketing, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Information Technology Users" -Path "ou=Information Technology, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Human Resources Users" -Path "ou=Human Resources, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Sales Users" -Path "ou=Sales, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Research Users" -Path "ou=Research, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Engineering Users" -Path "ou=Engineering, ou=Departments, dc=netzel, dc=lan"


New-ADOrganizationalUnit -Name "Accounting Printers" -Path "ou=Accounting, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Marketing Printers" -Path "ou=Marketing, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Information Technology Printers" -Path "ou=Information Technology, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Human Resources Printers" -Path "ou=Human Resources, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Sales Printers" -Path "ou=Sales, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Research Printers" -Path "ou=Research, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Engineering Printers" -Path "ou=Engineering, ou=Departments, dc=netzel, dc=lan"


New-ADOrganizationalUnit -Name "Accounting Computers" -Path "ou=Accounting, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Marketing Computers" -Path "ou=Marketing, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Information Technology Computers" -Path "ou=Information Technology, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Human Resources Computers" -Path "ou=Human Resources, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Sales Computers" -Path "ou=Sales, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Research Computers" -Path "ou=Research, ou=Departments, dc=netzel, dc=lan"
New-ADOrganizationalUnit -Name "Engineering Computers" -Path "ou=Engineering, ou=Departments, dc=netzel, dc=lan"


pause

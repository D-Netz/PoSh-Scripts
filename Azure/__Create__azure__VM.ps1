#some of the steps to create an Azure VM

#set variables
$loc = 'westus'
$pipname = 'win10client-ip'
$creds = Get-Credital

#get networking info
$vnet = Get-AzVirtualNetwork
$vnname = $vnet[0].Name
$rg = $vnet[0].ResourceGroupName
$subnet = $vnet[0].subnets.name


#get publisher name
$pubs = Get-AzVMImagePublisher -Location $loc | ? PublisherName -Match "microsoft*windows*"
$pub = $pubs[0].PublisherName # MicrosoftWindowsDesktop

# get publisher offerings
$offers = Get-AzVMImageOffer -Location $loc -PublisherName $pub | ? Offer -Match 'windows*'
$offer = $offers[0].Offer # Windows-10

# get sku of offerings
$skus = Get-AzVMImageSku -location $loc -publishername $pub -offer $offer
$sku = $skus[16].Skus # 19h2-Pro

#get vm size
$sizes = Get-AzVMSize -Location westus | ? {$_.Name -match "v3"}
$size = $sizes[14].Name # Standard_E2_V3

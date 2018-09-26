 # function Azurelogin 

 function azuredeploy  {
   
 
   
   $numbers = 1..3

    ForEach ($number in $numbers)  
    {  
      
 
        $resourceGroup = "SrvDeploymentRG"
        $location = "EastUS"
        $vmName = "SRV$number"

        $resourceGroupname = Get-AzureRmResourceGroup

if($resourceGroupname.resourcegroupname -eq "SrvDeploymentRG"){

      Write-Host "Resource Group Exist"
       # Write-Host "" 

        Write-Host "Create user object"

$secpasswd = ConvertTo-SecureString "P@ssword@2018" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("Glen", $secpasswd)



Write-Host " Create a virtual machine" 

New-AzureRmVM `
  -ResourceGroupName $resourceGroup `
  -Name $vmName `
  -Location $location `
  -ImageName "Win2016Datacenter" `
  -VirtualNetworkName "GAvnet" `
  -SubnetName "GAnet1" `
  -SecurityGroupName "NSG" `
  -PublicIpAddressName "myPublicIp$vmName" `
  -Credential $cred `
  -OpenPorts 3389 `
  -Size 'Standard_B1ms'`
  -Verbose 

  }



else {

# Create user object

$secpasswd = ConvertTo-SecureString "P@ssword@2018" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("Glen", $secpasswd)

# Create a resource group

New-AzureRmResourceGroup -Name $resourceGroup -Location $location

# Create a virtual machine

New-AzureRmVM `
  -ResourceGroupName $resourceGroup `
  -Name $vmName `
  -Location $location `
  -ImageName "Win2016Datacenter" `
  -VirtualNetworkName "GAvnet" `
  -SubnetName "GAnet1" `
  -SecurityGroupName "NSG" `
  -PublicIpAddressName "myPublicIp$vmName" `
  -Credential $cred `
  -OpenPorts 3389 `
  -Size 'Standard_B1ms'`
  -Verbose

  }


}

 }

   # Azurelogin 

    Measure-Command -Expression {azuredeploy } -Verbose 

   



    

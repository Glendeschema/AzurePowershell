<#
Created Credential Object to login Into Azure (Note: only for Windows)
For Mac ,  this wont work , so please use Connect-Azurermaccount

The $Cred is used to create the SQL Server as supplied Creds


    1. Enter Resource Group Name and SQL Server Name
    2.Validates if RG Exists , if not it will create a new one and re-initilize variable
    3.Get public IP of this current host
    4.Create a Firewall Rule to allow this machine to use Azure SQL
#>

$username = Get-Credential 
$Cred =New-Object System.Management.Automation.PSCredential($username.UserName , $username.Password)
$location = "east US"
$RGName = Read-Host "Enter Resource group Name"
$SQLServerName = Read-Host "Enter SQL Server Name (Must be unique)"
$DBName = Read-Host "Enter DB Name"


$RG = Get-AzureRmResourceGroup 


if(!$RGName.ResourceGroupName){

    $RG = New-AzureRmResourceGroup -Name $RGName -Location "East US" 
}

<#
1.Create new Azure SQL
2. Create a new SQL Database on the existing SQL server
3. Registering new firewall rule to allow access to SQL Server.
#>

$DBServer =New-AzureRmSqlServer -ServerName $SQLServerName -Location $location -ResourceGroupName $RG.ResourceGroupName `
-SqlAdministratorCredentials $Cred -Verbose -ErrorAction SilentlyContinue

  
$DBName = New-AzureRmSqlDatabase -DatabaseName $DBName -ServerName $DBServer.ServerName`
 -ResourceGroupName $RG.ResourceGroupName -MaxSizeBytes 2GB -ErrorAction SilentlyContinue

#Getting Public Address 
$publicIp = (Invoke-WebRequest http://myexternalip.com/raw -UseBasicParsing).Content -replace "`n"

New-AzureRmSqlServerFirewallRule -FirewallRuleName "Allow IP" `
-StartIpAddress $publicIp -EndIpAddress $publicIp `
-ServerName $DBServer.ServerName `
-ResourceGroupName $DBServer.ResourceGroupName -Verbose -ErrorAction SilentlyContinue
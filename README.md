# APPS30Ignite
Personal Note for Apps30 Modernizing Your Application with Containers

1.Create CosmoDB and SQL Server via create-db2.sh
````
#!/bin/bash
set -e

# Credentials
azureResourceGroup=001igniteapps30
adminUser=engsooncheah
adminPassword= **Please enter your sqldb password**
subname=121cfc68-5c49-459d-8f68-0dda20c4479d
location=eastus

# DB Name

cosmosdbname=001igniteapps30cosmo
sqldbname=001igniteapps30sql

# Create Resource Group
az group create --subscription $subname --name $azureResourceGroup --location $location

# Create Azure Cosmos DB
az cosmosdb create --name $cosmosdbname --resource-group $azureResourceGroup --kind MongoDB --subscription $subname 

cosmosConnectionString=$(az cosmosdb list-connection-strings --name $cosmosdbname  --resource-group $azureResourceGroup --query connectionStrings[0].connectionString -o tsv --subscription $subname)

# Create Azure SQL Insance
az sql server create --location $location --resource-group $azureResourceGroup --name $sqldbname --admin-user $adminUser --admin-password $adminPassword --subscription $subname
az sql server firewall-rule create --resource-group $azureResourceGroup --server $sqldbname --name azure --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0 --subscription $subname
az sql db create --resource-group $azureResourceGroup --server $sqldbname --name tailwind --subscription $subname
sqlConnectionString=$(az sql db show-connection-string --server $sqldbname --name tailwind -c ado.net --subscription $subname)

echo $cosmosConnectionString
echo $sqlConnectionString
````

2. Upload create-db2.sh to Azure Cloud Shell via Bash and enter following command, need wait around 15 minutes
````
bash create-db2.sh
````
3. VNET Creation
````
az network vnet create --name 001igniteapps30vnet --subscription  "Microsoft Azure Sponsorship 2019-2020" --resource-group 001igniteapps30 --subnet-name default
````
4. Create Azure Container Registry
````
az acr create --resource-group 001igniteapps30 --name 001igniteapps30acr --sku Basic --subscription  "Microsoft Azure Sponsorship 2019-2020" --admin-enabled true
````
5. Clone the repo in cloud shell
````
mkdir 001igniteapps30
git clone https://github.com/anthonychu/TailwindTraders-Website.git 001igniteapps30/ 
cd 001igniteapps30/Source/Tailwind.Traders.Web
git checkout monolith
````
6. Create app service plan
````
az appservice plan create --name 001igniteapps30plan --resource-group 001igniteapps30 --sku B1 --is-linux --subscription  "Microsoft Azure Sponsorship 2019-2020"
````
7. Build and push container
````
az acr build --subscription  "Microsoft Azure Sponsorship 2019-2020" --registry 001igniteapps30acr --image twtapp:v1 .
````
8. Create web app
````
az webapp create  --subscription  "Microsoft Azure Sponsorship 2019-2020" --resource-group 001igniteapps30 --plan 001igniteapps30plan --name 001twtwebapp30 --deployment-container-image-name 001igniteapps30acr.azurecr.io/twtapp:v1
````
9. Navigate to App Settings in portal, Add Connection String
SQL DB
````
SqlConnectionString="Server=tcp:twtsqlmod20.database.windows.net,1433;Initial Catalog=twtmod10;Persist Security Info=False;User ID=twtmod10;Password=**Remember enter your password**;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" 
````
MongoDB
````
MongoConnectionString="mongodb://:Hi5L2yajHopNUTDZRU8uDQf6hXYrK7WUPM4FVgk4P9h2VIRHircIkyKB7NFH0bTqC9WPBvHXc1YGGn2Y8XrHPw==@twtnosql.documents.azure.com:10255/?ssl=true&amp;replicaSet=globaldb" 
````
Additional Env Vars
````
apiUrl=/api/v1 
ApiUrlShoppingCart=/api/v1 

productImagesUrl="https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail"
````
10. View webapp url and verify running app
![Image of Apps30Result](https://github.com/cheahengsoon/APPS30Ignite/blob/master/Apps30Result.png)

#!/bin/bash
set -e

# Credentials
azureResourceGroup=001igniteapps30
adminUser=engsooncheah
adminPassword=Kpmg@singapore1331
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

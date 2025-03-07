#!/bin/bash

resource_group="ridomin-dev"
tunnel_id="ridomin-dev"


if ! az account show &> /dev/null; then
    echo "Please login to Azure CLI."
    echo "az login"
    exit 1
fi

if ! devtunnel user show &> /dev/null; then
    echo "Please login to DevTunnel."
    echo "devtunnel user login"
    exit 1
fi

if ! devtunnel show $tunnel_id &> /dev/null; then
    devtunnel create $tunnel_id -a
    devtunnel port create $tunnel_id -p 3978
fi

tunnel_details=$(devtunnel show $tunnel_id -j -v)
tunnel_url=$(echo $tunnel_details | grep -oP '(?<="portForwardingUris": \[ ")[^"]+(?=" \])')
echo $tunnel_url

appId=$(az ad app create --display-name $tunnel_id --sign-in-audience "AzureADMyOrg" --query appId -o tsv)
echo "Created AppId: "  $appId
secretJson=$(az ad app credential reset --id $appId | jq .)

clientId=$(echo $secretJson | jq .appId | tr -d '"')
tenantId=$(echo $secretJson | jq .tenant | tr -d '"')
clientSecret=$(echo $secretJson | jq .password | tr -d '"')

echo "clientId=$clientId" > "$tunnel_id.env"
echo "tenantId=$tenantId" >> "$tunnel_id.env"
echo "clientSecret=$clientSecret" >> "$tunnel_id.env"
echo "DEBUG=agents:*.info" >> "$tunnel_id.env"

endpoint=$tunnel_url"api/messages"

botJson=$(az bot create \
    --app-type SingleTenant \
    --appid $appId \
    --tenant-id $tenantId \
    --name $tunnel_id \
    --resource-group $resource_group \
    --endpoint $endpoint)

echo $botJson
$teamsBotJson=$(az bot msteams create -n $tunnel_id -g $resource_group)

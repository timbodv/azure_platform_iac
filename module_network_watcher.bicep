param location string
param prefix string
param short_code string

var network_watcher_generated_name = '${prefix}-${short_code}-watcher'
var storage_account_type = 'Standard_LRS'
var storage_account_name = 'flowlogs${uniqueString(resourceGroup().id)}'

resource storage_account 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storage_account_name
  location: location
  sku: {
    name: storage_account_type
  }
  kind: 'StorageV2'
  properties: {}
}

resource network_watcher 'Microsoft.Network/networkWatchers@2022-01-01' = {
  name: network_watcher_generated_name
  location: location
  properties: {}
}

output network_watcher_name string = network_watcher.name
output network_watcher_resource_group_name string = resourceGroup().name
output network_flow_storage_account_id string = storage_account.id
output network_watcher_object object = network_watcher

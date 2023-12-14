param location string
param network_watcher_name string
param network_flow_storage_account_id string
param network_security_group_id string
param subnet_name string


resource network_watcher 'Microsoft.Network/networkWatchers@2022-01-01' existing = {
  name: network_watcher_name
}

resource flow_log 'Microsoft.Network/networkWatchers/flowLogs@2022-01-01' = {
  name: '${subnet_name}-flow'
  location: location
  parent: network_watcher
  properties: {
    targetResourceId: network_security_group_id
    storageId: network_flow_storage_account_id
    enabled: true
    retentionPolicy: {
      days: 1
      enabled: true
    }
    format: {
      type: 'JSON'
      version: 2
    }
  }
}

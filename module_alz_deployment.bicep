targetScope = 'subscription'

param location string = 'australiaeast'
param addressPrefixes string
param subnetCollection array
param shortCode string

resource network_resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'alz-network'
  location: location
  properties: {}
}

module network_module 'module_network.bicep' = {
  name: 'alz_network_deployment'
  scope: resourceGroup(network_resource_group.name)
  params: {
    location:  location
    addressPrefixes : addressPrefixes
    subnetCollection: subnetCollection
    shortCode: shortCode
    prefix: 'alz'
  }
}

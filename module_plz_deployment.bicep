targetScope = 'subscription'

param location string = 'australiaeast'

var plzSubnetCollection = [
  {
    name: 'edge'
    subnetCidr: '10.1.0.0/24'
  }
  {
    name: 'identity'
    subnetCidr: '10.1.1.0/24'
  }
]

resource network_resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'plz-network'
  location: location
  properties: {}
}

module network_module 'module_network.bicep' = {
  name: 'plz_network_deployment'
  scope: resourceGroup(network_resource_group.name)
  params: {
    location: location
    addressPrefixes: '10.1.0.0/22'
    subnetCollection: plzSubnetCollection
    prefix: 'plz'
    shortCode: 'hub'
  }
}

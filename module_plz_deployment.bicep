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

var peeringCollection = [
  {
    name: 'alz-dev-vnet'
    id: '/subscriptions/967d672b-7700-45c3-81cc-bfca8da60a25/resourceGroups/alz-network/providers/Microsoft.Network/virtualNetworks/alz-dev-vnet'
  }
  {
    name: 'alz-shd-vnet'
    id: '/subscriptions/8e9d95eb-7ef8-4c08-a817-b44fa8655224/resourceGroups/alz-network/providers/Microsoft.Network/virtualNetworks/alz-shd-vnet'
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
    peeringCollection: peeringCollection
  }
}

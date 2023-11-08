targetScope = 'subscription'

param location string = 'australiaeast'
param addressPrefixes string
param subnetCollection array
param shortCode string

var peeringCollection = [
  {
    vnet_name: 'plz-hub-vnet'
    id: '/subscriptions/8e9d95eb-7ef8-4c08-a817-b44fa8655224/resourceGroups/plz-network/providers/Microsoft.Network/virtualNetworks/plz-hub-vnet'
  }
]

resource network_resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'alz-network'
  location: location
  properties: {}
}

module network_module 'module_network.bicep' = {
  name: 'alz_network_deployment'
  scope: resourceGroup(network_resource_group.name)
  params: {
    location: location
    addressPrefixes: addressPrefixes
    subnetCollection: subnetCollection
    shortCode: shortCode
    prefix: 'alz'
    peeringCollection: peeringCollection
    route_table_id: route_module.outputs.route_table_id
    is_spoke_network: true
  }
}

module route_module 'module_spoke_route.bicep' = {
  name: 'alz_route_deployment'
  scope: resourceGroup(network_resource_group.name)
  params: {
    location: location
  }
}

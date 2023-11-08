targetScope = 'subscription'

param location string = 'australiaeast'

var plzNetwork = {
  name: 'Hub'
  shortCode: 'hub'
  subscriptionId: '8e9d95eb-7ef8-4c08-a817-b44fa8655224'
  addressPrefixes: '10.1.0.0/22'
  subnetCollection: [
    {
      name: 'edge'
      subnetCidr: '10.1.0.0/24'
      nat_gateway_id: { id: nat_module.outputs.nat_gateway_resource_id }
    }
  ]
}

var peeringCollection = [
  {
    vnet_name: 'alz-dev-vnet'
    id: '/subscriptions/967d672b-7700-45c3-81cc-bfca8da60a25/resourceGroups/alz-network/providers/Microsoft.Network/virtualNetworks/alz-dev-vnet'
  }
  {
    vnet_name: 'alz-shd-vnet'
    id: '/subscriptions/8e9d95eb-7ef8-4c08-a817-b44fa8655224/resourceGroups/alz-network/providers/Microsoft.Network/virtualNetworks/alz-shd-vnet'
  }
]

resource network_resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'plz-network'
  location: location
  properties: {}
}

resource edge_resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'plz-edge'
  location: location
  properties: {}
}

module network_module 'module_network.bicep' = {
  name: 'plz_network_deployment'
  scope: resourceGroup(network_resource_group.name)
  params: {
    location: location
    addressPrefixes: plzNetwork.addressPrefixes
    subnetCollection: plzNetwork.subnetCollection
    prefix: 'plz'
    shortCode: plzNetwork.shortCode
    peeringCollection: peeringCollection
    route_table_id: route_module.outputs.route_table_id
    // nat_gateway_id: { id: nat_module.outputs.nat_gateway_resource_id }
    is_spoke_network: false
  }
}

module nat_module 'module_nat.bicep' = {
  name: 'plz_edge_deployment'
  scope: resourceGroup(edge_resource_group.name)
  params: {
    location: location
  }
}

module route_module 'module_hub_route.bicep' = {
  name: 'plz_route_deployment'
  scope: resourceGroup(network_resource_group.name)
  params: {
    location: location
  }
}

module edge_virtual_machine 'module_linux_vm.bicep' = {
  name: '${uniqueString(deployment().name, location)}-edge_virtual_machine'
  scope: resourceGroup(edge_resource_group.name)
  params: {
    vm_name: 'edge-02'
    cloud_init_data: ''
    ssh_public_key: loadTextContent('./id_rsa.pub')
    subnet_resource_id: network_module.outputs.subnets[0].id
    vm_size: 'Standard_B2als_v2'
    location: location
    deployPublicIp: true
    enable_ip_forwarding: true
  }
}

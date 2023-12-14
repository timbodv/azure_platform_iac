param location string
param address_prefixes string
param subnet_collection array
param short_code string
param prefix string
//param peering_collection array
param route_table_id string
param nat_gateway_id object
//param is_spoke_network bool
param network_watcher_name string
param network_watcher_resource_group_name string
param network_flow_storage_account_id string

var vnet_name = '${prefix}-${short_code}-vnet'

resource virtual_network 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        address_prefixes
      ]
    }
    // dhcpOptions: {
    //   dnsServers: [
    //     '10.1.1.4'
    //   ]
    // }
    subnets: [for (subnet, index) in subnet_collection: {
      name: subnet.name
      // using the union function, we add a nat_gateway_id setting _if_ there is one present
      properties: union(nat_gateway_id, {
        addressPrefix: subnet.subnet_cidr
        routeTable: {
          id: route_table_id
        }
        networkSecurityGroup: {
          id: network_security_groups[index].id
        }
        privateEndpointNetworkPolicies: 'Enabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      })
        
        //natGateway: nat_gateway_id
        //natGateway: ((!empty(nat_gateway_id)) ? reference(nat_gateway_id, '2022-10-01').customerId : null)
        

        //   //id: !empty(subnet.natGatewayId) ? subnet.natGatewayId : ''
        //   !empty(subnet.natGatewayId) ? id: subnet.natGatewayId : ''
        // }
    }]
  }
}

resource network_security_groups 'Microsoft.Network/networkSecurityGroups@2021-08-01' = [for (subnet, index) in subnet_collection: {
  name: '${prefix}-${short_code}-${subnet.name}-nsg'
  location: location
  properties: {
    securityRules: subnet.security_rules
  }
}]

// resource peer_virtual_network 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-08-01' = [for (peer, index) in peeringCollection: {
//   name: '${vnet_name}-to-${peer.vnet_name}'
//   parent: virtual_network
//   properties: {
//     allowForwardedTraffic: is_spoke_network
//     allowVirtualNetworkAccess: true
//     remoteVirtualNetwork: {
//       id: peer.id
//     }
//   }
// }]

// resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
//   name: storageAccountName
//   location: location
//   sku: {
//     name: storageAccountType
//   }
//   kind: 'StorageV2'
//   properties: {}
// }

// resource networkWatcher 'Microsoft.Network/networkWatchers@2022-01-01' = {
//   name: watcher_name
//   location: location
//   properties: {}
// }

module flow_log_module 'module_network_flow_log.bicep' = [for (subnet, index) in subnet_collection: {
  name: '${subnet.name}-flow'
  scope: resourceGroup(network_watcher_resource_group_name)
  params: {
    location: location
    network_watcher_name: network_watcher_name
    network_flow_storage_account_id: network_flow_storage_account_id
    network_security_group_id: network_security_groups[index].id
    subnet_name: subnet.name
  }
}
]

output subnets array = virtual_network.properties.subnets

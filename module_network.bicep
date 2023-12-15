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
param dns_servers array

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
    dhcpOptions: {
      dnsServers: dns_servers
    }
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
output virtual_network_id string = virtual_network.id
output virtual_network_name string = virtual_network.name

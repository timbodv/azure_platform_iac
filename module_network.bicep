param location string
param addressPrefixes string
param subnetCollection array
param shortCode string
param prefix string
param peeringCollection array
param route_table_id string
param is_spoke_network bool

var vnet_name = '${prefix}-${shortCode}-vnet'

//@description('Optional. Add additional site config properties to function app.')
//param nat_gateway_id object = {}

resource virtual_network 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixes
      ]
    }
    // dhcpOptions: {
    //   dnsServers: [
    //     '10.1.1.4'
    //   ]
    // }
    subnets: [for (subnet, index) in subnetCollection: {
      // this supports defining a manual subnet name, or an automatically generated one
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetCidr
        routeTable: {
          id: route_table_id
        }
        networkSecurityGroup: {
          id: network_security_groups[index].id
        }
        privateEndpointNetworkPolicies: 'Enabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
        natGateway: subnet.nat_gateway_id
        //   //id: !empty(subnet.natGatewayId) ? subnet.natGatewayId : ''
        //   !empty(subnet.natGatewayId) ? id: subnet.natGatewayId : ''
        // }

      }
    }]
  }
}

resource network_security_groups 'Microsoft.Network/networkSecurityGroups@2021-08-01' = [for (subnet, index) in subnetCollection: {
  name: '${prefix}-${shortCode}-${subnet.name}-nsg'
  location: location
  properties: {
    securityRules: subnet.security_rules
  }
}]

resource peer_virtual_network 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-08-01' = [for (peer, index) in peeringCollection: {
  name: '${vnet_name}-to-${peer.vnet_name}'
  parent: virtual_network
  properties: {
    allowForwardedTraffic: is_spoke_network
    allowVirtualNetworkAccess: true
    remoteVirtualNetwork: {
      id: peer.id
    }
  }
}]

output subnets array = virtual_network.properties.subnets

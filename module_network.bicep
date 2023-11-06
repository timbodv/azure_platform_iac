param location string
param addressPrefixes string
param subnetCollection array
param shortCode string
param prefix string
//param peerToHub bool
//param hubVirtualNetworkId string = ''
param peeringCollection array

var vnetName = '${prefix}-${shortCode}-vnet'

resource virtual_network 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
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
        // routeTable: {
        //   id: routeTable.id
        // }
        // networkSecurityGroup: {
        //   id: storageSubnetNetworkSecurityGroup[index].id
        // }
        privateEndpointNetworkPolicies: 'Enabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
    }]
  }
}

resource peer_virtual_network 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-08-01' = [for (peer, index) in peeringCollection: {
  name: '${vnetName}-to-${peer.name}'
  parent: virtual_network
  properties: {
    allowForwardedTraffic: true
    remoteVirtualNetwork: {
      id: peer.id
    }
  }
}]

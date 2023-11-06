targetScope = 'subscription'

param location string = 'australiaeast'

module plz_deployment_module 'module_plz_deployment.bicep' = {
  name: 'plz-deployment'
  // Shared Services
  scope: subscription('8e9d95eb-7ef8-4c08-a817-b44fa8655224')
  params: {
    location: location
  }
}


// resource plz_virtual_network 'Microsoft.Network/virtualNetworks@2019-11-01' = {
//   name: 'plz-vnet'
//   scope: resourceGroup(plz_network_resource_group.name)
//   location: location
//   properties: {
//     addressSpace: {
//       addressPrefixes: [
//         '10.1.0.0/22'
//       ]
//     }
//     // dhcpOptions: {
//     //   dnsServers: [
//     //     '10.1.1.4'
//     //   ]
//     // }
//     subnets: [for (subnet, index) in subnetCollection: {
//       // this supports defining a manual subnet name, or an automatically generated one
//       name: subnet.name
//       properties: {
//         addressPrefix: subnet.subnetCidr
//         // routeTable: {
//         //   id: routeTable.id
//         // }
//         // networkSecurityGroup: {
//         //   id: storageSubnetNetworkSecurityGroup[index].id
//         // }
//         privateEndpointNetworkPolicies: 'Enabled'
//         privateLinkServiceNetworkPolicies: 'Enabled'
//       }
//     }]
//   }
// }

// resource coreVirtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
//   name: 'iaas-core-vnet'
//   scope: resourceGroup(coreNetworkSubscriptionId, coreNetworkResourceGroup)
// }

// resource peeringToExistingShared 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-08-01' = {
//   name: 'peering-to-iaas-core-vnet'
//   parent: workloadVirtualNetwork
//   properties: {
//     allowForwardedTraffic: true
//     remoteVirtualNetwork: {
//       id: coreVirtualNetwork.id
//     }
//   }
// }

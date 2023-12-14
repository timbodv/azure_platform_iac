param vnet_name string
param remote_vnet_name string
param remote_vnet_id string
param is_spoke_network bool = true

resource virtual_network 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: vnet_name
}

resource peer_virtual_network 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-08-01' = {
  name: '${vnet_name}-to-${remote_vnet_name}'
  parent: virtual_network
  properties: {
    allowForwardedTraffic: is_spoke_network
    allowVirtualNetworkAccess: true
    remoteVirtualNetwork: {
      id: remote_vnet_id
    }
  }
}

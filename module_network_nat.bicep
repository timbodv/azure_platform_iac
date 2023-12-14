param location string
param prefix string
param short_code string

var public_ip_address_name = '${prefix}-${short_code}-pip-01'
var nat_gateway_name = '${prefix}-${short_code}-nat'

module public_ip_address 'br/public:avm-res-network-publicipaddress:0.1.0' = {
  name: '${uniqueString(deployment().name, location)}-${public_ip_address_name}'
  params: {
    name: public_ip_address_name
    ddosSettings: null
    diagnosticSettings: null
    dnsSettings: null
    location: location
    lock: null
    publicIpPrefixResourceId: null
    roleAssignments: null
    tags: {}
    zones: []
  }
}

resource nat_gateway 'Microsoft.Network/natGateways@2023-04-01' = {
  name: nat_gateway_name
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIpAddresses: [
      {
        id: public_ip_address.outputs.resourceId
      }
    ]
  }
}

output nat_gateway_resource_id string = nat_gateway.id

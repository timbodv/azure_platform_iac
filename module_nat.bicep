param location string = 'australiaeast'
//param subnet_resource_id string

module public_ip_address 'br/public:avm-res-network-publicipaddress:0.1.0' = {
  name: '${uniqueString(deployment().name, location)}-edge-pip-01'
  params: {
    // Required parameters
    name: 'edge-pip-01'
    // Non-required parameters
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
  name: 'edge-nat-01'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    //idleTimeoutInMinutes: int
    publicIpAddresses: [
      {
        id: public_ip_address.outputs.resourceId
      }
    ]
  }
}

//var ssh_public_key = loadTextContent('./id_rsa.pub')
//var cloud_init_data = loadTextContent('./cloud-init-ubuntu_1.yml')



output nat_gateway_resource_id string = nat_gateway.id

targetScope = 'subscription'

param location string = 'australiaeast'

var alzCollection = [
  {
    name: 'Development'
    shortCode: 'dev'
    subscriptionId: '967d672b-7700-45c3-81cc-bfca8da60a25'
    addressPrefixes: '10.1.8.0/22'
    subnetCollection: []
    //natGatewayId: null
  }
  {
    name: 'Shared Services'
    shortCode: 'shd'
    subscriptionId: '8e9d95eb-7ef8-4c08-a817-b44fa8655224'
    addressPrefixes: '10.1.4.0/22'
    subnetCollection: [
      {
        name: 'identity'
        subnetCidr: '10.1.4.0/24'
        nat_gateway_id: null
        security_rules : null
      }
    ]
  }
]

module alz_deployment_module 'module_alz_deployment.bicep' = [for (alz, index) in alzCollection: {
  name: replace('${alz.name} ALZ Deployment', ' ', '_')
  scope: subscription(alz.subscriptionId)
  params: {
    location: location
    addressPrefixes: alz.addressPrefixes
    subnetCollection: alz.subnetCollection
    shortCode: alz.shortCode
  }
}]


param location string

resource route_table 'Microsoft.Network/routeTables@2023-04-01' = {
  name: 'alz-spoke-rtbl'
  location: location
  properties: {
    routes: [
      {
        name: 'all-traffic-to-edge'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: '10.1.0.4'
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
  }
}

output route_table_id string = route_table.id

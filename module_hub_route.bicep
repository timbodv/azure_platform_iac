param location string

resource plz_route_table 'Microsoft.Network/routeTables@2023-04-01' = {
  name: 'plz-hub-rtbl'
  location: location
  properties: {
    routes: [
      {
        name: 'site-phar-lap-server'
        properties: {
          addressPrefix: '10.2.0.0/18'
          nextHopIpAddress: '10.1.0.4'
          nextHopType: 'VirtualAppliance'
        }
      }
      {
        name: 'site-phar-lap-other'
        properties: {
          addressPrefix: '192.168.0.0/16'
          nextHopIpAddress: '10.1.0.4'
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
  }
}

output route_table_id string = plz_route_table.id

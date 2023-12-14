param location string
param routes array
param prefix string
param short_code string

resource route_table 'Microsoft.Network/routeTables@2023-04-01' = {
  name: '${prefix}-${short_code}-rtbl'
  location: location
  properties: {
    routes: routes
  }
}

output route_table_id string = route_table.id

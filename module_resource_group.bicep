targetScope = 'subscription'

param location string = 'australiaeast'
param resource_group_name string

resource resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resource_group_name
  location: location
  properties: {}
}

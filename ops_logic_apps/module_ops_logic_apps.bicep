targetScope = 'subscription'

param location string
param resource_group_name string
param managed_identity_name string = 'ops-logic-apps-user'

resource resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resource_group_name
  location: location
  properties: {}
}

module managed_identity 'module_managed_identity.bicep' = {
  name: '${uniqueString(deployment().name, location)}-managed_identity'
  scope: resourceGroup(resource_group.name)
  params: {
    location: location
    managed_identity_name: managed_identity_name
  }
}

module start_vm_logic_app 'module_logic_app.bicep' = {
  name: '${uniqueString(deployment().name, location)}-start_vm_logic_app'
  scope: resourceGroup(resource_group.name)
  params: {
    location: location
    logic_app_name: 'start_vm'
    logic_app_properties: loadJsonContent('start_vm.json')
    managed_identity_id: managed_identity.outputs.managed_identity_id
  }
}

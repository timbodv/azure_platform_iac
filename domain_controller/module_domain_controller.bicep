targetScope = 'subscription'

param location string = 'australiaeast'

var subnet_id = '/subscriptions/8e9d95eb-7ef8-4c08-a817-b44fa8655224/resourceGroups/alz-network/providers/Microsoft.Network/virtualNetworks/alz-shd-vnet/subnets/identity'

resource identity_resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'iaas-identity'
  location: location
  properties: {}
}

module domain_controller_vm 'module_windows_vm.bicep' = {
  name: '${uniqueString(deployment().name, location)}-dc03_virtual_machine'
  scope: resourceGroup(identity_resource_group.name)
  params: {
    vm_name: 'addc-03'
    cloud_init_data: ''
    subnet_resource_id: subnet_id
    vm_size: 'Standard_B2als_v2'
    location: location
    enable_ip_forwarding: false
  }
}

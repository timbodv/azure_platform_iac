param location string = 'australiaeast'
param vm_name string
//param vm_size string ='Standard_D2as_v5'
// includes temp disk
param vm_size string
@secure()
param admin_secret string = 'NraGcfAqze2UZv!'
param cloud_init_data string
param subnet_resource_id string
param enable_ip_forwarding bool

var admin_user = 'azureuser'

// resource virtual_network 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
//   name: 'iaas-dev1-vnet'
//   scope: resourceGroup('iaas-dev1-net')
// }

// resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
//   name: 'ntier-subnet'
//   parent: virtual_network
// }

// resource user_identity_for_vm 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
//   name: 'shared-ident'
//   location: location
// }

resource network_interface 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: '${vm_name}-vm-nic-01'
  location: location

  properties: {
    enableAcceleratedNetworking: true
    enableIPForwarding: enable_ip_forwarding
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet_resource_id
          }
        }
      }
    ]
  }
}

resource windows_virtual_machine 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: '${vm_name}-vm'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vm_size
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: network_interface.id
        }
      ]
    }
    osProfile: {
      adminUsername: admin_user
      adminPassword: admin_secret
      computerName: vm_name
      //customData: base64(cloud_init_data)
    }
    securityProfile: {
      encryptionAtHost: true
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
    }
    storageProfile: {
      imageReference: {
        offer: 'WindowsServer'
        publisher: 'MicrosoftWindowsServer'
        sku: '2022-datacenter-smalldisk-g2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        name: '${vm_name}-vm-osdisk'
        osType: 'Windows'
      }
    }
  }
}


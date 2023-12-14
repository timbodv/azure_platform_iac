param location string = 'australiaeast'
param vm_name string
//param vm_size string ='Standard_D2as_v5'
// includes temp disk
param vm_size string
//@secure()
//param admin_secret string = 'NraGcfAqze2UZv!'
param ssh_public_key string
param cloud_init_data string
param subnet_resource_id string
param deployPublicIp bool
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

module public_ip_address 'br/public:avm-res-network-publicipaddress:0.1.0' = if (deployPublicIp) {
  name: '${uniqueString(deployment().name, location)}-edge-pip-01'
  params: {
    // Required parameters
    name: '${vm_name}-vm-pip-01'
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
          publicIPAddress: {
            id: !empty(public_ip_address.outputs.resourceId) ? public_ip_address.outputs.resourceId : null
          }
          subnet: {
            id: subnet_resource_id
          }
        }
      }
    ]
  }
}

resource linux_virtual_machine 'Microsoft.Compute/virtualMachines@2022-11-01' = {
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
      //adminPassword: admin_secret
      computerName: vm_name
      //customData: base64(cloud_init_data)
      linuxConfiguration: {
        ssh: {
          publicKeys: [
            {
              keyData: ssh_public_key
              path: '/home/${admin_user}/.ssh/authorized_keys'
            }
          ]
        }
      }
    }
    securityProfile: {
      encryptionAtHost: true
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: false
      }
    }
    storageProfile: {
      imageReference: {
        offer: '0001-com-ubuntu-minimal-jammy'
        publisher: 'Canonical'
        sku: 'minimal-22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        name: '${vm_name}-vm-osdisk'
        osType: 'Linux'
      }
    }
  }
}

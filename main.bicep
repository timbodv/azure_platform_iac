targetScope = 'managementGroup'

param location string = 'australiaeast'

// deploy ALZ network watchers
// deploy PLZ network, in shared services
// deploy ALZ networks
// peer networks
// create PLZ shared resources
//  custom roles
//  maintenance configurations
// create ALZ shared resources
//  recovery vaults
// deploy PLZ policies
// deploy ALZ policies

var alz_prefix = 'alz'
var alz_subscriptions = [
  {
    name: 'Shared Services'
    short_code: 'shd'
    network_resource_group_name: 'alz-network'
    recovery_resource_group_name: 'alz-recovery'
    shared_resource_group_name: 'alz-shared-resources'
    subscription_id: '8e9d95eb-7ef8-4c08-a817-b44fa8655224'
    address_prefixes: '10.1.4.0/22'
    dns_servers: [
      '10.1.4.4'
    ]
    subnet_collection: [
      {
        name: 'identity'
        subnet_cidr: '10.1.4.0/24'
        //nat_gateway_id: null
        security_rules: null
      }
    ]
  }
  {
    name: 'Development'
    short_code: 'dev'
    network_resource_group_name: 'alz-network'
    recovery_resource_group_name: 'alz-recovery'
    shared_resource_group_name: 'alz-shared-resources'
    subscription_id: '967d672b-7700-45c3-81cc-bfca8da60a25'
    address_prefixes: '10.1.8.0/22'
    dns_servers: [
      '10.1.4.4'
    ]
    subnet_collection: []
  }
]
var alz_routes = [
  {
    name: 'all-traffic-to-hub'
    properties: {
      addressPrefix: '0.0.0.0/0'
      nextHopIpAddress: '10.1.0.4'
      nextHopType: 'VirtualAppliance'
    }
  }
]

var plz_prefix = 'plz'
var plz_subscription = {
  name: 'Shared Services - Hub'
  short_code: 'hub'
  network_resource_group_name: 'plz-network'
  recovery_resource_group_name: 'plz-recovery'
  shared_resource_group_name: 'plz-shared-resources'
  security_resource_group_name: 'plz-secops-resources'
  subscription_id: '8e9d95eb-7ef8-4c08-a817-b44fa8655224'
  address_prefixes: '10.1.0.0/22'
  dns_servers: [
    '10.1.4.4'
  ]
  subnet_collection: [
    {
      name: 'edge'
      subnet_cidr: '10.1.0.0/24'
      //nat_gateway_id: { id: plz_nat_module.outputs.nat_gateway_resource_id }
      security_rules: [
        {
          name: 'allow-inbound-wireguard'
          properties: {
            access: 'Allow'
            //description: 'string'
            destinationAddressPrefix: '10.1.0.4'
            // destinationAddressPrefixes: [
            //   'string'
            // ]
            destinationPortRange: '51820'
            // destinationPortRanges: [
            //   'string'
            // ]
            direction: 'Inbound'
            priority: 110
            protocol: 'Udp'
            sourceAddressPrefix: 'Internet'
            // sourceAddressPrefixes: [
            //   'string'
            // ]
            sourcePortRange: '*'
            // sourcePortRanges: [
            //   'string'
            // ]
          }
        }
        {
          name: 'allow-inbound-ssh-from-internal'
          properties: {
            access: 'Allow'
            //description: 'string'
            destinationAddressPrefix: '10.1.0.4'
            // destinationAddressPrefixes: [
            //   'string'
            // ]
            destinationPortRange: '22'
            // destinationPortRanges: [
            //   'string'
            // ]
            direction: 'Inbound'
            priority: 120
            protocol: 'Tcp'
            //sourceAddressPrefix: 'Internet'
            sourceAddressPrefix: 'VirtualNetwork'
            // sourceAddressPrefixes: [
            //   'string'
            // ]
            sourcePortRange: '*'
            // sourcePortRanges: [
            //   'string'
            // ]
          }
        }
        {
          name: 'allow-inbound-internet-traffic-from-internal'
          properties: {
            access: 'Allow'
            description: 'Inbound HTTP and HTTPS will be forwarded via the edge and NATd out to the Internet'
            destinationAddressPrefix: 'Internet'
            // destinationAddressPrefixes: [
            //   'string'
            // ]
            // destinationPortRange: '51820'
            destinationPortRanges: [
              '80'
              '443'
            ]
            direction: 'Inbound'
            priority: 130
            protocol: 'Tcp'
            sourceAddressPrefix: 'VirtualNetwork'
            // sourceAddressPrefixes: [
            //   'string'
            // ]
            sourcePortRange: '*'
            // sourcePortRanges: [
            //   'string'
            // ]
          }
        }
        {
          name: 'allow-dns-to-cloudflare'
          properties: {
            access: 'Allow'
            destinationAddressPrefix: '1.1.1.1'
            // destinationAddressPrefixes: [
            //   'string'
            // ]
            // destinationPortRange: '51820'
            destinationPortRanges: [
              '53'
            ]
            direction: 'Inbound'
            priority: 140
            protocol: '*'
            sourceAddressPrefix: '10.1.4.4'
            // sourceAddressPrefixes: [
            //   'string'
            // ]
            sourcePortRange: '*'
            // sourcePortRanges: [
            //   'string'
            // ]
          }
        }
      ]
    } ]
}
var plz_routes = [
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

// ALZ NETWORK WATCHER
module alz_network_resource_groups 'module_resource_group.bicep' = [for (alz_subscription, index) in alz_subscriptions: {
  name: replace('${alz_subscription.name} PLZ resource group deployment', ' ', '_')
  scope: subscription(alz_subscription.subscription_id)
  params: {
    location: location
    resource_group_name: alz_subscription.network_resource_group_name
  }
}]

module alz_network_watcher_module 'module_network_watcher.bicep' = [for (alz_subscription, index) in alz_subscriptions: {
  name: replace('${alz_subscription.name} ALZ network watcher deployment', ' ', '_')
  scope: resourceGroup(alz_subscription.subscription_id, alz_subscription.network_resource_group_name)
  params: {
    location: location
    prefix: alz_prefix
    short_code: alz_subscription.short_code
  }
}]

// PLZ NETWORK
module plz_network_resource_groups 'module_resource_group.bicep' = {
  name: replace('${plz_subscription.name} PLZ resource group deployment', ' ', '_')
  scope: subscription(plz_subscription.subscription_id)
  params: {
    location: location
    resource_group_name: plz_subscription.network_resource_group_name
  }
}

module plz_nat_module 'module_network_nat.bicep' = {
  name: replace('${plz_subscription.name} PLZ NAT gateway deployment', ' ', '_')
  scope: resourceGroup(plz_subscription.subscription_id, plz_subscription.network_resource_group_name)
  params: {
    location: location
    prefix: plz_prefix
    short_code: plz_subscription.short_code
  }
}

module plz_route_table_module 'module_route_table.bicep' = {
  name: replace('${plz_subscription.name} PLZ hub route table deployment', ' ', '_')
  scope: resourceGroup(plz_subscription.subscription_id, plz_subscription.network_resource_group_name)
  params: {
    location: location
    routes: plz_routes
    prefix: plz_prefix
    short_code: plz_subscription.short_code
  }
}

module plz_network_module 'module_network.bicep' = {
  name: replace('${plz_subscription.name} PLZ hub network deployment', ' ', '_')
  scope: resourceGroup(plz_subscription.subscription_id, plz_subscription.network_resource_group_name)
  params: {
    location: location
    address_prefixes: plz_subscription.address_prefixes
    subnet_collection: plz_subscription.subnet_collection
    prefix: plz_prefix
    short_code: plz_subscription.short_code
    route_table_id: plz_route_table_module.outputs.route_table_id
    dns_servers: plz_subscription.dns_servers
    // for this to work, we supply the bicep that will be appended to the properties for the subnet
    nat_gateway_id: { natGateway: { id: plz_nat_module.outputs.nat_gateway_resource_id } }
    // use the network flow details from the Shared Services ALZ
    network_flow_storage_account_id: alz_network_watcher_module[0].outputs.network_flow_storage_account_id
    network_watcher_name: alz_network_watcher_module[0].outputs.network_watcher_name
    network_watcher_resource_group_name: alz_network_watcher_module[0].outputs.network_watcher_resource_group_name
  }
}

// ALZ NETWORKS
module alz_route_table_module 'module_route_table.bicep' = [for (alz_subscription, index) in alz_subscriptions: {
  name: replace('${alz_subscription.name} ALZ spoke route table deployment', ' ', '_')
  scope: resourceGroup(alz_subscription.subscription_id, alz_subscription.network_resource_group_name)
  params: {
    location: location
    routes: alz_routes
    prefix: alz_prefix
    short_code: 'spoke'
  }
}]

module alz_networks_module 'module_network.bicep' = [for (alz_subscription, index) in alz_subscriptions: {
  name: replace('${alz_subscription.name} ALZ spoke network deployment', ' ', '_')
  scope: resourceGroup(alz_subscription.subscription_id, alz_subscription.network_resource_group_name)
  params: {
    location: location
    address_prefixes: alz_subscription.address_prefixes
    subnet_collection: alz_subscription.subnet_collection
    prefix: alz_prefix
    short_code: alz_subscription.short_code
    route_table_id: alz_route_table_module[index].outputs.route_table_id
    nat_gateway_id: {}
    dns_servers: alz_subscription.dns_servers
    network_flow_storage_account_id: alz_network_watcher_module[index].outputs.network_flow_storage_account_id
    network_watcher_name: alz_network_watcher_module[index].outputs.network_watcher_name
    network_watcher_resource_group_name: alz_network_watcher_module[index].outputs.network_watcher_resource_group_name
  }
}
]

// NETWORK PEERINGS
module alz_peering_module 'module_network_peering.bicep' = [for (alz_subscription, index) in alz_subscriptions: {
  name: replace('${alz_subscription.name} ALZ peering deployment', ' ', '_')
  scope: resourceGroup(alz_subscription.subscription_id, alz_subscription.network_resource_group_name)
  params: {
    is_spoke_network: true
    vnet_name: alz_networks_module[index].outputs.virtual_network_name
    remote_vnet_id: plz_network_module.outputs.virtual_network_id
    remote_vnet_name: plz_network_module.outputs.virtual_network_name
  }
}]

module plz_peering_module 'module_network_peering.bicep' = [for (alz_subscription, index) in alz_subscriptions: {
  name: replace('${alz_subscription.name} PLZ peering deployment', ' ', '_')
  scope: resourceGroup(plz_subscription.subscription_id, plz_subscription.network_resource_group_name)
  params: {
    is_spoke_network: false
    vnet_name: plz_network_module.outputs.virtual_network_name
    remote_vnet_id: alz_networks_module[index].outputs.virtual_network_id
    remote_vnet_name: alz_networks_module[index].outputs.virtual_network_name
  }
}]

// PLZ SHARED RESOURCES
module plz_shared_resource_group 'module_resource_group.bicep' = {
  name: replace('${plz_subscription.name} PLZ shared resource group deployment', ' ', '_')
  scope: subscription(plz_subscription.subscription_id)
  params: {
    location: location
    resource_group_name: plz_subscription.shared_resource_group_name
  }
}

module plz_security_resource_group 'module_resource_group.bicep' = {
  name: replace('${plz_subscription.name} PLZ security resource group deployment', ' ', '_')
  scope: subscription(plz_subscription.subscription_id)
  params: {
    location: location
    resource_group_name: plz_subscription.security_resource_group_name
  }
}

module plz_default_maintenance_configuration 'module_maintenance_configuration.bicep' = {
  name: replace('${plz_subscription.name} PLZ maintenance configuration deployment', ' ', '_')
  scope: resourceGroup(plz_subscription.subscription_id, plz_subscription.shared_resource_group_name)
  params: {
    location: location
  }
}

module plz_operations_log_analytics 'module_log_analytics.bicep' = {
  name: replace('${plz_subscription.name} PLZ operations log analytics deployment', ' ', '_')
  scope: resourceGroup(plz_subscription.subscription_id, plz_subscription.shared_resource_group_name)
  params: {
    location: location
    retentionInDays: 30
    short_code: 'ops'
    include_sentinel: false
    prefix: plz_prefix
  }
}

module plz_secops_log_analytics 'module_log_analytics.bicep' = {
  name: replace('${plz_subscription.name} PLZ secops log analytics deployment', ' ', '_')
  scope: resourceGroup(plz_subscription.subscription_id, plz_subscription.security_resource_group_name)
  params: {
    location: location
    retentionInDays: 90
    short_code: 'secops'
    include_sentinel: true
    prefix: plz_prefix
  }
}

// https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access?tabs=portal#set-table-level-read-access
module custom_role 'module_custom_role.bicep' = {
  name: replace('${plz_subscription.name} PLZ maintenance configuration deployment', ' ', '_')
  params: {
    role_name: 'Log Analytics Table Reader'
    role_description: 'Grants users read access to specific table data in a Log Analytics workspace'
    actions: [
      'Microsoft.OperationalInsights/workspaces/read'
      'Microsoft.OperationalInsights/workspaces/query/read'
      'Microsoft.OperationalInsights/workspaces/analytics/query/action'
      'Microsoft.OperationalInsights/workspaces/search/action'
    ]
    data_actions: []
    not_actions: [
      'Microsoft.OperationalInsights/workspaces/sharedKeys/read'
    ]
    not_data_actions: []
  }
}

// create ALZ shared resources
module alz_recovery_resource_groups 'module_resource_group.bicep' = [for (alz_subscription, index) in alz_subscriptions: {
  name: replace('${alz_subscription.name} ALZ recovery resource group deployment', ' ', '_')
  scope: subscription(alz_subscription.subscription_id)
  params: {
    location: location
    resource_group_name: alz_subscription.recovery_resource_group_name
  }
}]

module alz_recovery_resources 'module_recovery.bicep' = [for (alz_subscription, index) in alz_subscriptions: {
  name: replace('${alz_subscription.name} ALZ recovery resources deployment', ' ', '_')
  scope: resourceGroup(alz_subscription.subscription_id, alz_subscription.recovery_resource_group_name)
  params: {
    location: location
    prefix: alz_prefix
  }
}]

// deploy PLZ policies
module plz_policies 'module_policies_plz.bicep' = {
  name: replace('${plz_subscription.name} PLZ policies deployment', ' ', '_')
  params: {
    location: location
    default_maintenance_configuration_id: plz_default_maintenance_configuration.outputs.maintenance_configuration_id
  }
}

// deploy ALZ policies
module alz_policies 'module_policies_alz.bicep' = [for (alz_subscription, index) in alz_subscriptions: {
  name: replace('${alz_subscription.name} ALZ policies deployment', ' ', '_')
  scope: subscription(alz_subscription.subscription_id)
  params: {
    location: location
    default_vm_backup_policy_id: alz_recovery_resources[index].outputs.default_vm_backup_policy_id
  }
}]

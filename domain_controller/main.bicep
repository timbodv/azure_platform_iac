targetScope = 'subscription'

var subscription_id = '8e9d95eb-7ef8-4c08-a817-b44fa8655224'

param location string = 'australiaeast'

module domain_controller_module 'module_domain_controller.bicep' = {
  name: 'domain_controller_deploy'
  scope: subscription(subscription_id)
  params: {
    location: location
  }
}


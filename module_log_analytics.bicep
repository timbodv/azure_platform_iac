param location string
param prefix string
param short_code string
param include_sentinel bool

param retentionInDays int = 30

var workspace_name = '${prefix}-${short_code}-${uniqueString(resourceGroup().id)}-log'
var sentinel_solution_name = 'SecurityInsights(${workspace.name})'

resource workspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: workspace_name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
  }
}

resource sentinel_solution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = if (include_sentinel) {
  name: sentinel_solution_name
  location: location
  properties: {
    workspaceResourceId: workspace.id
  }
  plan: {
    name: sentinel_solution_name
    publisher: 'Microsoft'
    product: 'OMSGallery/SecurityInsights'
    promotionCode: ''
  }
}

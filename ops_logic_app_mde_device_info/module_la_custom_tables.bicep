param data_collection_rule_name string
param log_analytics_workspace_name string
param custom_table_name string
param data_collector_endpoint_name string
param table_columns array
param stream_columns array
param transform_kql string

param location string = 'australiaeast'

resource log_analytics_workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: log_analytics_workspace_name
}

resource data_collector_endpoint 'Microsoft.Insights/dataCollectionEndpoints@2022-06-01' existing = {
  name: data_collector_endpoint_name
}

// https://learn.microsoft.com/en-us/azure/templates/microsoft.operationalinsights/workspaces/tables?pivots=deployment-language-bicep
resource custom_table 'Microsoft.OperationalInsights/workspaces/tables@2022-10-01' = {
  name: '${custom_table_name}_CL'
  parent: log_analytics_workspace
  properties: {
    schema: {
      columns: table_columns
      name: '${custom_table_name}_CL'
    }
  }
}

// https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-bicep
resource data_collection_rule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: '${data_collection_rule_name}-dcr'
  location: location
  dependsOn: [
    custom_table
  ]
  properties: {
    dataCollectionEndpointId: data_collector_endpoint.id
    dataFlows: [
      {
        streams: [
          'Custom-${custom_table_name}_CL'
        ]
        destinations: [
          // send to the destination defined a little lower, using the same function to generate the name
          uniqueString(data_collection_rule_name)
        ]
        transformKql: transform_kql
        outputStream: 'Custom-${custom_table_name}_CL'
      }
    ]
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: log_analytics_workspace.id
          //workspaceId: log_analytics_workspace.properties.
          name: uniqueString(data_collection_rule_name)
        }
      ]
    }
    streamDeclarations: {
      'Custom-${custom_table_name}_CL': {
        columns: stream_columns
      }
    }
  }
}

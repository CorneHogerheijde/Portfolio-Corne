targetScope = 'resourceGroup'

@description('Name of the Static Web App.')
param name string = 'swa-portfolio-corne'

@description('Location for the Static Web App.')
param location string = 'westeurope'

@description('SKU for the Static Web App. Free tier is sufficient for a portfolio.')
@allowed(['Free', 'Standard'])
param sku string = 'Free'

@description('Custom domains for the portfolio.')
param customDomains array = [
  'hogerheijde.nl'
]

@description('Attach custom domain during deployment. Keep false until DNS validation is configured.')
param enableCustomDomain bool = false

@description('GitHub repository URL.')
param repositoryUrl string = 'https://github.com/CorneHogerheijde/Portfolio-Corne'

@description('Branch to deploy from.')
param branch string = 'main'

@description('Azure Static Web Apps build token (from GitHub Actions).')
@secure()
param repositoryToken string = ''

@description('Tags to apply to all resources.')
param tags object = {
  project: 'portfolio'
  owner: 'corne@hogerheijde.nl'
  environment: 'production'
}

// ---------------------------------------------------------------------------
// Azure Static Web App - Native Microsoft.Web/staticSites resource
// ---------------------------------------------------------------------------
resource staticWebApp 'Microsoft.Web/staticSites@2024-04-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  tags: tags
  properties: {}
}

// Custom domain configuration - apply when enableCustomDomain is true
resource customDomainBindings 'Microsoft.Web/staticSites/customDomains@2024-04-01' = [for domain in customDomains: if (enableCustomDomain) {
  parent: staticWebApp
  name: domain
  properties: {
    validationMethod: 'dns-txt-token'
  }
}]

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------
@description('The default hostname of the Static Web App.')
output defaultHostname string = staticWebApp.properties.defaultHostname

@description('The resource ID of the Static Web App.')
output resourceId string = staticWebApp.id

@description('Command to fetch the SWA deployment token after the resource is created.')
output deploymentTokenCommand string = 'az staticwebapp secrets list --name ${name} --resource-group ${resourceGroup().name} --query "properties.apiKey" -o tsv'

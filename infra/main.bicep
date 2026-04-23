targetScope = 'resourceGroup'

@description('Name of the Static Web App.')
param name string = 'swa-portfolio-corne'

@description('Location for the Static Web App.')
param location string = 'westeurope'

@description('SKU for the Static Web App. Free tier is sufficient for a portfolio.')
@allowed(['Free', 'Standard'])
param sku string = 'Free'

@description('Custom domain for the portfolio (e.g. hogerheijde.nl).')
param customDomain string = 'hogerheijde.nl'

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
// Azure Static Web App – deployed via AVM module
// ---------------------------------------------------------------------------
var staticWebAppParams = union({
  name: name
  location: location
  sku: sku
  repositoryUrl: repositoryUrl
  branch: branch
  repositoryToken: repositoryToken
  buildProperties: {
    appLocation: 'src'
    outputLocation: 'public'
    skipGithubActionWorkflowGeneration: true
  }
  tags: tags
}, enableCustomDomain ? {
  // Attach the custom domain only when explicitly enabled.
  customDomains: [customDomain]
  validationMethod: 'dns-txt-token'
} : {})

module staticWebApp 'br/public:avm/res/web/static-site:0.9.4' = {
  name: 'staticWebAppDeploy'
  params: staticWebAppParams
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------
@description('The default hostname of the Static Web App.')
output defaultHostname string = staticWebApp.outputs.defaultHostname

@description('The resource ID of the Static Web App.')
output resourceId string = staticWebApp.outputs.resourceId

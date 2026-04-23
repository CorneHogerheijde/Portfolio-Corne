using './main.bicep'

param name = 'swa-portfolio-corne'
param location = 'westeurope'
param sku = 'Free'
param customDomain = 'hogerheijde.nl'
param enableCustomDomain = false
param repositoryUrl = 'https://github.com/CorneHogerheijde/Portfolio-Corne'
param branch = 'main'
// repositoryToken is injected via CI/CD – do not store secrets here
param tags = {
  project: 'portfolio'
  owner: 'corne@hogerheijde.nl'
  environment: 'production'
}

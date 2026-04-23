# Portfolio – Corné Hogerheijde

Personal portfolio website for [hogerheijde.nl](https://hogerheijde.nl).

## Tech Stack

- **Static Site**: [Hugo](https://gohugo.io/) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme
- **CMS**: [Decap CMS](https://decapcms.org/) (admin at `/admin`)
- **Hosting**: Azure Static Web Apps
- **IaC**: Bicep with Azure Verified Modules

## Local Development

```bash
# Install Hugo Extended (if not already installed)
winget install Hugo.Hugo.Extended

# Clone with submodules (for PaperMod theme)
git clone --recurse-submodules https://github.com/CorneHogerheijde/Portfolio-Corne

# Start local development server
cd src
hugo server --buildDrafts
```

Open [http://localhost:1313](http://localhost:1313) in your browser.

## Content Editing

Edit Markdown files in `src/content/`:

| File | Page |
|---|---|
| `content/_index.md` | Homepage |
| `content/about.md` | About |
| `content/experience.md` | Experience |
| `content/skills.md` | Skills |
| `content/contact.md` | Contact |
| `content/posts/*.md` | Blog posts |

Or use the **Decap CMS** admin panel at `https://hogerheijde.nl/admin`.

## Blog Toggle

In `src/hugo.toml`, set `enableBlog = false` to hide the Blog section from navigation.

## Infrastructure Deployment

```bash
# Login to Azure
az login

# Create resource group
az group create --name rg-portfolio-corne --location westeurope

# Deploy infrastructure with deployment stack
az stack group create \
  --name stack-portfolio-corne-prod \
  --resource-group rg-portfolio-corne \
  --template-file infra/main.bicep \
  --parameters infra/main.bicepparam \
  --action-on-unmanage deleteResources \
  --deny-settings-mode none \
  --yes
```

## Required GitHub Secrets

| Secret | Description |
|---|---|
| `AZURE_STATIC_WEB_APPS_API_TOKEN` | SWA deployment token (from Azure portal) |
| `AZURE_CLIENT_ID` | Service principal client ID |
| `AZURE_TENANT_ID` | Azure tenant ID |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID |

## DNS Configuration

Point `hogerheijde.nl` to Azure Static Web Apps:
1. Add a CNAME record: `www → <swa-name>.azurestaticapps.net`
2. For apex domain: use ALIAS/ANAME record or Azure DNS

After adding the custom domain in Azure portal, add the validation TXT record provided by Azure to your DNS.

## AI Agent Context

Copilot and other AI agents will automatically pick up context from `.github/copilot-instructions.md`.

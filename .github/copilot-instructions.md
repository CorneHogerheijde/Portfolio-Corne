# Copilot Instructions – Portfolio Corné Hogerheijde

## Project Overview

This is the personal portfolio website of **Corné Hogerheijde**, a Software Engineer & Solution Architect based in Hillegom, Netherlands.

- **Live site**: [hogerheijde.nl](https://hogerheijde.nl)
- **GitHub**: [github.com/CorneHogerheijde](https://github.com/CorneHogerheijde)
- **LinkedIn**: [linkedin.com/in/cornehogerheijde](https://www.linkedin.com/in/cornehogerheijde)
- **Email**: corne@hogerheijde.nl

## Tech Stack

| Layer | Technology |
|---|---|
| Static Site Generator | [Hugo](https://gohugo.io/) with [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme |
| CMS | [Decap CMS](https://decapcms.org/) (Git-based, admin UI at `/admin`) |
| Hosting | Azure Static Web Apps (Free tier) |
| Infrastructure as Code | Bicep using [AVM `avm/res/web/static-site` v0.9.4](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/web/static-site) |
| CI/CD | GitHub Actions |
| Domain | hogerheijde.nl |

## Repository Structure

```
.
├── .github/
│   ├── copilot-instructions.md   ← You are reading this
│   └── workflows/
│       ├── deploy.yml            ← Build Hugo + deploy to Azure SWA
│       └── infra.yml             ← Deploy Bicep infrastructure
├── infra/
│   ├── main.bicep                ← AVM-based Azure Static Web App
│   └── main.bicepparam           ← Parameters (no secrets stored)
├── src/                          ← Hugo project root
│   ├── hugo.toml                 ← Hugo & PaperMod configuration
│   ├── content/                  ← Markdown content pages
│   │   ├── _index.md             ← Homepage
│   │   ├── about.md
│   │   ├── experience.md
│   │   ├── skills.md
│   │   ├── contact.md
│   │   └── posts/                ← Blog posts (optional)
│   ├── static/
│   │   ├── admin/                ← Decap CMS (index.html + config.yml)
│   │   └── img/                  ← Images (profile.jpg, etc.)
│   ├── assets/css/extended/      ← Custom CSS overrides
│   ├── layouts/partials/
│   │   └── nav.html              ← Overrides nav to support blog toggle
│   └── themes/PaperMod/          ← Git submodule
├── staticwebapp.config.json      ← Azure SWA routing rules
└── sources/                      ← Source materials (CV, photo) – not deployed
```

## Blog Toggle

The blog feature can be switched on/off in `src/hugo.toml`:

```toml
[params]
  enableBlog = true   # set to false to hide Blog from navigation
```

When `enableBlog = false`, the Blog menu item is hidden via the `layouts/partials/nav.html` override. The `/posts/` route still exists but is not linked.

## Decap CMS

- Admin panel: `https://hogerheijde.nl/admin`
- Authentication: GitHub OAuth via Azure Static Web Apps built-in auth
- Config: `src/static/admin/config.yml`
- Content is committed directly to the `main` branch via GitHub API

To configure Decap CMS auth:
1. Create a GitHub OAuth App at https://github.com/settings/developers
2. Set callback URL to: `https://hogerheijde.nl/.auth/login/github/callback`
3. Add `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` to Azure SWA app settings

## Infrastructure

The Azure Static Web App is defined in `infra/main.bicep` using the AVM module.
Deploy with:

```bash
az deployment group create \
  --resource-group rg-portfolio-corne \
  --template-file infra/main.bicep \
  --parameters infra/main.bicepparam
```

Required GitHub Secrets for CI/CD:
- `AZURE_STATIC_WEB_APPS_API_TOKEN` – SWA deployment token (from Azure portal)
- `AZURE_CLIENT_ID` – Service principal for infra deployment
- `AZURE_TENANT_ID` – Azure tenant
- `AZURE_SUBSCRIPTION_ID` – Azure subscription

## Owner Profile (for content reference)

- **Full name**: Corné Hogerheijde
- **Role**: Software Engineer / Solution Architect
- **Company**: The Future Group (independent entrepreneur)
- **Core skills**: C#, .NET, Azure, Bicep, IaC, DevOps, SQL, JavaScript
- **Experience**: 10+ years, Expert level in Development, DevOps, Database, Cloud
- **Education**: MSc Forensic Science (UvA), BSc Biology (RuG), MCSD, Architect's Masterclass (iDesign)
- **Interests**: Bird protection (SOVON), Surfing (wave + kite), Running, Piano, Reading

## Coding Conventions

- Hugo content: Markdown with YAML frontmatter
- Bicep: Follow AVM best practices, use `br/public:` registry references
- CSS: Minimal overrides in `assets/css/extended/`; prefer PaperMod built-in config options
- Always run `hugo server` from the `src/` directory to preview changes

## Key URLs

- Portfolio: https://hogerheijde.nl
- GitHub repo: https://github.com/CorneHogerheijde/Portfolio-Corne
- Azure portal: https://portal.azure.com (resource group: `rg-portfolio-corne`)
- CMS: https://hogerheijde.nl/admin

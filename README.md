# DockNextFlare — Secure Private Cloud Architecture

Self-hosted private cloud stack built with **Nextcloud**, **MariaDB**, **Docker Compose** and **Cloudflare Tunnel**.  
The goal is to provide secure remote access to a private document cloud without exposing inbound router ports.

> Portfolio focus: Linux administration, Docker Compose, secure tunneling, private cloud deployment, backup thinking and operational documentation.

## What this project demonstrates

- Linux-based service deployment with Docker Compose
- Nextcloud + MariaDB container orchestration
- Cloudflare Zero Trust Tunnel for outbound-only remote access
- Environment-based configuration using `.env`
- Operational runbook, troubleshooting and security documentation
- Backup and restore procedure awareness

## Architecture

```text
User Browser
    │
    ▼
Cloudflare Edge / Zero Trust
    │ encrypted outbound tunnel
    ▼
cloudflared container
    │ Docker bridge network
    ▼
Nextcloud app container
    │
    ▼
MariaDB container
```

No public host port is required for production usage. Cloudflare Tunnel reaches the Nextcloud container over the private Docker network.

## Repository structure

```text
docknextflare/
├── cloudflared/
│   └── config.yml
├── docs/
│   ├── architecture.md
│   ├── backup-restore.md
│   ├── deployment.md
│   ├── runbook.md
│   ├── security.md
│   ├── troubleshooting.md
│   └── screenshots/
├── .env.example
├── .gitignore
├── CHANGELOG.md
├── docker-compose.yml
├── LICENSE
└── README.md
```

## Quick start

```bash
git clone https://github.com/Student13Thirteen/docknextflare.git
cd docknextflare
cp .env.example .env
nano .env
docker compose up -d
```

Then configure your Cloudflare Zero Trust tunnel to route your public hostname to:

```text
http://nextcloud-app:80
```

## First Nextcloud setup

When opening the public URL for the first time, use these database settings:

| Field | Value |
|---|---|
| Database user | `nextcloud` |
| Database password | `MYSQL_PASSWORD` from `.env` |
| Database name | `nextcloud` |
| Database host | `db` |

## Documentation

| Document | Purpose |
|---|---|
| [`docs/architecture.md`](docs/architecture.md) | System design and container flow |
| [`docs/deployment.md`](docs/deployment.md) | Step-by-step deployment procedure |
| [`docs/runbook.md`](docs/runbook.md) | Daily operations and useful checks |
| [`docs/troubleshooting.md`](docs/troubleshooting.md) | Common issues and fixes |
| [`docs/security.md`](docs/security.md) | Security boundaries and hardening notes |
| [`docs/backup-restore.md`](docs/backup-restore.md) | Backup and restore procedure |

## Useful commands

```bash
# Check running containers
docker compose ps

# View logs
docker compose logs -f

# Restart the application
docker compose restart app

# Enter the Nextcloud container
docker exec -it nextcloud-app bash

# Run Nextcloud occ commands
docker exec --user www-data nextcloud-app php occ status
```

## Security notes

- Never commit `.env`, tunnel tokens, database dumps or runtime folders.
- Prefer no host port exposure in production; use Cloudflare Tunnel only.
- Use strong unique passwords for MariaDB.
- Enable MFA on the Cloudflare account.
- Keep Docker images updated and backup before upgrades.

## Related project

This service can be monitored using my Uptime Kuma monitoring setup:  
[uptimemonitoring](https://github.com/Student13Thirteen/uptimemonitoring)

## License

MIT — see [`LICENSE`](LICENSE).

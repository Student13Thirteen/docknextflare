# Changelog

## 2.0.0 — One-command operations

- Added the `docknextflare` guided setup and operations command.
- Automated strong credential generation and first Nextcloud installation.
- Removed the redundant local Cloudflare tunnel-ID configuration.
- Added MariaDB and Nextcloud health checks with ordered startup.
- Split the tunnel and database into separate Docker networks.
- Added doctor, backup, update, logs and credential commands.
- Rewrote documentation around the project's narrow utility and limits.
- Added static validation through GitHub Actions.

## 1.0.0

- Initial Nextcloud, MariaDB and Cloudflare Tunnel Compose stack.
- Added deployment, runbook, troubleshooting, security and backup notes.

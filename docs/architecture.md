# Architecture — DockNextFlare

## Goal

Deploy a private cloud service with secure remote access and minimal network exposure.

## Components

| Component | Role |
|---|---|
| Nextcloud | File sharing and private cloud application |
| MariaDB | Persistent relational database for Nextcloud |
| cloudflared | Outbound Cloudflare Zero Trust tunnel |
| Docker bridge network | Isolated container-to-container communication |
| `.env` | Local secret/configuration file not committed to Git |

## Request flow

```text
User → Cloudflare Edge → Cloudflare Tunnel → cloudflared → nextcloud-app:80 → db:3306
```

The tunnel is outbound-only from the server to Cloudflare. No inbound router port forwarding is required.

## Data persistence

```text
./html      → Nextcloud application and user data
./database  → MariaDB data directory
```

Both directories are runtime data and must not be committed to Git.

## Portfolio value

This project demonstrates a practical private-cloud architecture using containerized services, DNS/tunnel configuration, operational documentation and a security-first deployment approach.

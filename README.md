# ☁️ DockNextFlare: Secure Private Cloud

A complete, production-ready Docker stack to deploy a self-hosted **Nextcloud** instance powered by **MariaDB**, securely exposed to the internet through a **Cloudflare Zero Trust Tunnel** (`cloudflared`).

## ✨ Why this stack?

Traditional self-hosted clouds require opening ports on your router, managing dynamic IPs, and manually renewing SSL certificates. This stack eliminates all of that:

- **Zero Exposed Ports:** Your router stays completely locked down.
- **Built-in SSL & DDoS Protection:** Cloudflare handles HTTPS and security at the edge.
- **Stable Remote Access:** The tunnel is configured with keepalive settings to prevent SSH and connection drops.
- **Portability:** The entire infrastructure is defined in a single `docker-compose.yml`. Migrate to a new server in minutes.

## 🏗️ Architecture

```
Internet → Cloudflare Edge → cloudflared (tunnel) → nextcloud-app:80 → nextcloud-db
                                                         (private-net bridge — no ports exposed)
```

1. **Nextcloud (App):** The core cloud platform, reachable internally on port `8080`.
2. **MariaDB (Database):** A dedicated, optimized database container.
3. **Cloudflared (Tunnel):** Outbound-only encrypted tunnel to Cloudflare's edge — no inbound firewall rules needed.
4. **Private Network:** All containers communicate through an isolated Docker bridge network (`private-net`).

## 📁 Repository Structure

```
docknextflare/
├── docker-compose.yml
├── cloudflared/
│   └── config.yml          # Tunnel keepalive settings
├── .env.example            # Template — copy to .env and fill in your values
├── .gitignore
└── README.md
```

## 🚀 Quick Start Guide

### Prerequisites

- Docker and Docker Compose installed
- A domain name managed via Cloudflare
- A Cloudflare Zero Trust account (free tier is enough)

### Installation

**1. Clone the repository:**
```bash
git clone https://github.com/Student13Thirteen/docknextflare.git
cd docknextflare
```

**2. Create your environment file:**
```bash
cp .env.example .env
nano .env
```
Fill in your own secure passwords. Never commit this file.

**3. Set up the Cloudflare Tunnel:**
- Go to Cloudflare Zero Trust Dashboard → Networks → Tunnels
- Create a new tunnel and route it to `http://nextcloud-app:80`
- Copy your tunnel **token** and your tunnel **ID**
- Paste the token into `.env`:
  ```env
  CLOUDFLARE_TOKEN=your_token_here
  ```
- Paste the tunnel ID into `cloudflared/config.yml`:
  ```yaml
  tunnel: your-tunnel-id-here
  ```

**4. Deploy the stack:**
```bash
docker compose up -d
```

**5. First Setup:**

Navigate to your public domain (e.g., `https://cloud.yourdomain.com`). Nextcloud will prompt you to create an admin account and configure the database. Use these values:

| Field | Value |
|---|---|
| Database user | `nextcloud` |
| Database password | the `MYSQL_PASSWORD` from your `.env` |
| Database name | `nextcloud` |
| Database host | `db` |

## 🛡️ Security Notes

- **Never commit `.env`** — it's in `.gitignore` by default.
- Use strong, unique passwords for both `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD`.
- The Cloudflare tunnel token grants access to your tunnel — treat it like a private key.
- After first setup, configure `'overwrite.cli.url'` and `'overwriteprotocol' => 'https'` in Nextcloud's `config/config.php` to avoid mixed-content errors behind Cloudflare.

## 🔧 Useful Commands

```bash
# View live logs
docker compose logs -f

# Restart a single container
docker restart nextcloud-app

# Run Nextcloud occ commands
docker exec --user www-data nextcloud-app php occ <command>

# Update all images
docker compose pull && docker compose up -d
```

## 💾 Backup

Never copy the `database/` folder directly — always use a proper dump:

```bash
# Stop Nextcloud (keep DB running)
docker stop nextcloud-app

# Dump the database
docker exec nextcloud-db mysqldump -u nextcloud -p"${MYSQL_PASSWORD}" nextcloud > backup_$(date +%Y%m%d).sql

# Archive Nextcloud files
tar -czf backup_html_$(date +%Y%m%d).tar.gz ./html

# Restart
docker start nextcloud-app
```

## 📈 Monitoring & Alerts
This service is actively monitored using a self-hosted **Uptime Kuma** instance. 
It performs health checks every 5 minutes and sends real-time push notifications via a Telegram Bot in case of downtime. 

For more details on the monitoring infrastructure and setup, check out my dedicated repository:
👉 **[Homelab Monitoring with Uptime Kuma]([(https://github.com/Student13Thirteen/uptimemonitoring)])**

## 📝 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

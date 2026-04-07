# ☁️ DockNextFlare: Secure Private Cloud

A complete, production-ready Docker stack to deploy a self-hosted **Nextcloud** instance powered by **MariaDB**, securely exposed to the internet through a **Cloudflare Zero Trust Tunnel** (`cloudflared`).

## ✨ Why this stack?

Traditional self-hosted clouds require opening ports on your router, managing dynamic IPs, and manually renewing SSL certificates (Let's Encrypt). This stack eliminates all of that:
- **Zero Exposed Ports:** Your router stays completely locked down.
- **Built-in SSL & DDoS Protection:** Cloudflare handles HTTPS and security at the edge.
- **Portability:** The entire infrastructure (Database + App + Tunnel) is defined in a single `docker-compose.yml` file. You can migrate your entire company cloud to a new server in seconds.

## 🏗️ Architecture

1. **Nextcloud (App):** The core cloud platform running on port `8080` internally.
2. **MariaDB (Database):** A dedicated, optimized database container for high performance.
3. **Cloudflared (Tunnel):** A lightweight connector that establishes an outbound-only encrypted tunnel to Cloudflare's edge network, mapping your local `8080` port to your public domain.
4. **Private Network:** All containers communicate securely through an isolated Docker bridge network (`private-net`).

## 🚀 Quick Start Guide

### Prerequisites
- Docker and Docker Compose installed.
- A domain name managed via Cloudflare.
- A Cloudflare Zero Trust account (free tier).

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Student13Thirteen/docknextflare.git
   cd docknextflare
   ```

2. **Configure your credentials:**
   Open the `docker-compose.yml` file and replace the placeholder passwords with your own secure passwords:
   - `MYSQL_ROOT_PASSWORD`
   - `MYSQL_PASSWORD`

3. **Set up the Cloudflare Tunnel:**
   - Go to your Cloudflare Zero Trust Dashboard > Networks > Tunnels.
   - Create a new Cloudflared tunnel and route it to `http://nextcloud-app:80` (or `http://localhost:8080`).
   - Copy your unique tunnel token.
   - Paste the token into the `command` line of the `tunnel` service in the `docker-compose.yml` file:
     ```yaml
     command: tunnel --no-autoupdate run --token YOUR_CLOUDFLARE_TOKEN_HERE
     ```

4. **Deploy the stack:**
   ```bash
   docker compose up -d
   ```

5. **First Setup:**
   Navigate to your public domain (e.g., `https://cloud.yourdomain.com`). Nextcloud will prompt you to create an admin account. The database is already connected automatically!

## 🛡️ Security Notes
- **Never commit your `.env` files or hardcoded passwords/tokens to GitHub.**
- The `OVERWRITEPROTOCOL=https` environment variable is already handled by the setup (or configurable within Nextcloud's `config.php`) to prevent mixed-content errors when running behind Cloudflare.

## 📝 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

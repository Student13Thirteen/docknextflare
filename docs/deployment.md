# Deployment Guide — DockNextFlare

## 1. Server prerequisites

```bash
docker --version
docker compose version
```

Recommended server baseline:

- Linux host, preferably Ubuntu Server
- Docker + Docker Compose plugin
- Domain managed through Cloudflare
- Cloudflare Zero Trust tunnel

## 2. Environment setup

```bash
cp .env.example .env
nano .env
```

Set strong values for:

```env
MYSQL_ROOT_PASSWORD=
MYSQL_PASSWORD=
CLOUDFLARE_TOKEN=
```

## 3. Cloudflare tunnel route

In Cloudflare Zero Trust, create a tunnel and route the desired hostname to:

```text
http://nextcloud-app:80
```

## 4. Start services

```bash
docker compose up -d
docker compose ps
```

## 5. First application setup

Open the public hostname and configure Nextcloud with:

```text
Database user: nextcloud
Database password: MYSQL_PASSWORD from .env
Database name: nextcloud
Database host: db
```

## 6. Post-deployment checks

```bash
docker compose logs --tail=100 app
docker compose logs --tail=100 db
docker compose logs --tail=100 tunnel
docker exec --user www-data nextcloud-app php occ status
```

## 7. Suggested next steps

- Configure Nextcloud trusted domains.
- Verify HTTPS redirect behavior behind Cloudflare.
- Configure Uptime Kuma monitoring.
- Configure periodic backups.

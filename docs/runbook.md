# Runbook — DockNextFlare

## Daily/weekly checks

```bash
docker compose ps
docker compose logs --tail=50 app
docker compose logs --tail=50 tunnel
docker exec --user www-data nextcloud-app php occ status
```

## Restart service

```bash
docker compose restart app
```

## Restart full stack

```bash
docker compose restart
```

## Update images

Backup first, then:

```bash
docker compose pull
docker compose up -d
docker image prune -f
```

## Check disk usage

```bash
df -h
du -sh html database
```

## Incident response checklist

1. Check `docker compose ps`.
2. Read container logs.
3. Verify Cloudflare tunnel status.
4. Verify DNS/public hostname.
5. Restart affected container only.
6. If database errors appear, stop and backup before deeper changes.
7. Document the incident and fix.

# Troubleshooting — DockNextFlare

## Public URL does not load

Check tunnel logs:

```bash
docker compose logs -f tunnel
```

Verify in Cloudflare Zero Trust:

```text
Public hostname → Service → http://nextcloud-app:80
```

## Nextcloud shows database connection error

```bash
docker compose ps
docker compose logs --tail=100 db
docker compose logs --tail=100 app
```

Check `.env` values and ensure the database host is `db` during first setup.

## Mixed content or wrong protocol warning

Behind Cloudflare, Nextcloud may need overwrite settings in `config/config.php`:

```php
'overwriteprotocol' => 'https',
'overwrite.cli.url' => 'https://cloud.your-domain.com',
```

## Container keeps restarting

```bash
docker inspect nextcloud-app --format '{{.State.ExitCode}}'
docker compose logs --tail=200 app
```

Common causes:

- wrong environment variables
- database not ready
- permission issues in mounted volume
- broken Nextcloud config

## Disk full

```bash
df -h
du -sh html database
```

Clean unused Docker resources only after checking what is safe:

```bash
docker system df
docker image prune
```

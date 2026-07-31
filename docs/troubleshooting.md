# Troubleshooting

Start with:

```bash
bash docknextflare doctor
```

## Public hostname does not load

```bash
bash docknextflare logs tunnel
```

Verify the Cloudflare Public Hostname service is exactly:

```text
http://app:80
```

Also confirm the tunnel token belongs to the selected tunnel and the DNS hostname is active in Cloudflare.

## Tunnel is connected but Nextcloud is unavailable

```bash
bash docknextflare status
bash docknextflare logs app
```

The tunnel starts only after the application health check passes. A tunnel container that is not created yet may simply mean Nextcloud is still installing or unhealthy.

## Database health check fails

```bash
bash docknextflare logs db
```

Common causes:

- insufficient disk space;
- wrong ownership or permissions under `data/mariadb`;
- an interrupted first initialization;
- reusing an incompatible existing database directory.

Do not delete database files to “try again” unless a verified backup exists.

## Nextcloud redirects to HTTP or the wrong hostname

Confirm `.env` contains only the hostname:

```env
NEXTCLOUD_HOSTNAME=cloud.example.com
```

Do not include `https://` or a path. For a previously installed instance, environment variables do not necessarily remove older values already written to `config.php`; inspect the active configuration with:

```bash
docker compose exec -T -u www-data app php occ config:list system
```

## Permission errors in persistent directories

```bash
ls -ld data data/nextcloud data/mariadb
bash docknextflare logs app
bash docknextflare logs db
```

Avoid recursively changing ownership without first identifying which container and UID created the files.

## Disk full

```bash
df -h
du -sh data/nextcloud data/mariadb backups
docker system df
```

Remove old backups or unused Docker images only after confirming they are not the sole recovery copy.

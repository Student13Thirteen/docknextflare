# Backup & Restore — DockNextFlare

## Backup principle

Back up both:

1. MariaDB database dump
2. Nextcloud data/application directory

## Manual backup

```bash
mkdir -p backups

# Optional: enable maintenance mode
docker exec --user www-data nextcloud-app php occ maintenance:mode --on

# Dump database
docker exec nextcloud-db sh -c 'mysqldump -u nextcloud -p"$MYSQL_PASSWORD" nextcloud' > backups/nextcloud_db_$(date +%Y%m%d_%H%M).sql

# Archive Nextcloud files
tar -czf backups/nextcloud_html_$(date +%Y%m%d_%H%M).tar.gz html

# Disable maintenance mode
docker exec --user www-data nextcloud-app php occ maintenance:mode --off
```

## Restore outline

1. Stop application containers.
2. Restore `html/` archive.
3. Restore database dump into MariaDB.
4. Start containers.
5. Run Nextcloud maintenance/repair checks.

## Notes

Test restore procedures before relying on backups in production.

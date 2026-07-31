# Backup and restore

## Create a backup

```bash
bash docknextflare backup
```

The command:

1. enables Nextcloud maintenance mode;
2. writes a logical MariaDB dump;
3. archives the complete Nextcloud directory;
4. writes SHA-256 checksums when a checksum utility is available;
5. disables maintenance mode even if an intermediate step fails.

Output is stored under:

```text
backups/YYYYMMDD_HHMMSS/
|- nextcloud.sql
|- nextcloud-files.tar.gz
`- SHA256SUMS
```

A backup on the same disk protects against some operator mistakes, not against disk loss, theft or server compromise. Copy selected backups to a separate trusted destination.

## Restore outline

A restore is intentionally not automated because it is destructive and should be reviewed case by case.

1. Stop the stack:

   ```bash
   bash docknextflare stop
   ```

2. Preserve the current `data/` directory before replacing anything.
3. Restore `nextcloud-files.tar.gz` so that `data/nextcloud` is recreated.
4. Start only MariaDB and wait for it:

   ```bash
   docker compose up -d db
   ```

5. Import the SQL dump:

   ```bash
   set -a; source .env; set +a
   docker compose exec -T db mariadb -u nextcloud "-p$MYSQL_PASSWORD" nextcloud < backups/TIMESTAMP/nextcloud.sql
   ```

6. Start the complete stack and repair if required:

   ```bash
   bash docknextflare start
   docker compose exec -T -u www-data app php occ maintenance:repair
   bash docknextflare doctor
   ```

Test the procedure on non-critical data before relying on it.

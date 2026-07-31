# Runbook

## Normal checks

```bash
bash docknextflare status
bash docknextflare doctor
```

The doctor command checks the local configuration, Docker, service health, Nextcloud OCC and the public hostname when `curl` is available.

## Logs

```bash
bash docknextflare logs app
bash docknextflare logs db
bash docknextflare logs tunnel
```

## Restart

```bash
bash docknextflare stop
bash docknextflare start
```

Stopping the stack does not remove `data/`.

## Update

```bash
bash docknextflare update
```

The update command creates a backup first, pulls newer images, reconciles the stack and waits for application health.

Review upstream release notes before major upgrades. A successful image pull is not proof that an application migration is reversible.

## Disk checks

```bash
df -h
du -sh data/nextcloud data/mariadb backups
```

## Incident sequence

1. Run `bash docknextflare doctor`.
2. Check the failing service logs.
3. Verify the Cloudflare Tunnel and public-hostname route.
4. Confirm free disk space and host time.
5. Restart only after preserving useful logs.
6. Back up before manual database or filesystem repairs.
7. Record the cause and the recovery action.

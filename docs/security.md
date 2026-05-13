# Security Notes — DockNextFlare

## Security boundary

This repository provides a self-hosted private cloud deployment. It is not a managed enterprise security platform. The operator is responsible for OS patching, backups, access control and incident response.

## Secrets

Never commit:

```text
.env
Cloudflare tunnel token
database dumps
html/
database/
backup archives
```

## Recommended hardening

- Enable MFA on Cloudflare and Nextcloud admin accounts.
- Use strong unique database passwords.
- Keep the server and Docker images updated.
- Restrict SSH access to key-based authentication.
- Use Uptime Kuma monitoring and alerting.
- Keep offline backups outside the server.

## Network exposure

Production setup should rely on Cloudflare Tunnel and avoid public host ports. If a debug port is needed, bind it to localhost only:

```yaml
ports:
  - "127.0.0.1:8080:80"
```

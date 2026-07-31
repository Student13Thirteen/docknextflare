# Security

## What the design reduces

- no public Nextcloud host port;
- no public MariaDB port;
- no router port forwarding;
- database isolation from the tunnel network;
- secrets excluded from Git;
- generated long credentials instead of documented defaults.

## What it does not solve

Cloudflare Tunnel is a transport and exposure mechanism. It does not replace:

- Nextcloud authentication and authorization;
- user lifecycle and sharing governance;
- host patching;
- container-image update decisions;
- malware scanning or data-loss prevention;
- tested offline backups;
- incident response.

## Secret handling

Treat these as secrets:

```text
.env
Cloudflare tunnel token
Nextcloud administrator password
MariaDB passwords
backup archives and SQL dumps
```

The guided setup writes `.env` with mode `600`. Do not copy it into tickets, screenshots, shell history or public CI variables.

A remotely-managed tunnel token can run that tunnel. Rotate it from Cloudflare if it is disclosed.

## Recommended hardening

- enable MFA for Cloudflare and Nextcloud administration;
- use SSH keys and restrict server administration access;
- keep the host firewall enabled even though no app ports are published;
- review enabled Nextcloud apps and public shares;
- configure brute-force protection and security headers according to Nextcloud guidance;
- store at least one backup outside the server;
- monitor uptime, disk capacity and certificate/tunnel failures;
- test restore procedures periodically.

## Local data

`data/nextcloud` contains application configuration and user files. `data/mariadb` contains the database. Host users with sufficient privileges can read or alter these paths; filesystem access remains part of the security boundary.

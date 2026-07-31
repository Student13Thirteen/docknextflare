# Architecture

## Objective

Make a private Nextcloud instance available from any device while keeping the host free of public application and database ports.

## Components

| Component | Responsibility |
|---|---|
| `cloudflared` | establishes the outbound tunnel to Cloudflare |
| Nextcloud Apache image | web application, file API and initial auto-configuration |
| MariaDB LTS image | persistent relational data |
| `docknextflare` command | setup, health checks, backups and controlled updates |
| `.env` | local configuration and credentials; never committed |

## Network separation

```text
Internet
   |
Cloudflare edge
   |
cloudflared
   |
[edge network]
   |
Nextcloud
   |
[backend network: internal]
   |
MariaDB
```

Only Nextcloud joins both networks. MariaDB joins only the internal backend network, and neither service publishes a host port.

## Request path

```text
browser
  -> HTTPS to Cloudflare
  -> existing outbound Tunnel connection
  -> cloudflared container
  -> http://app:80 over Docker DNS
  -> Nextcloud
  -> MariaDB only when application data is needed
```

## Persistence

```text
data/nextcloud -> /var/www/html
data/mariadb   -> /var/lib/mysql
```

The directories are easy to locate and include in an operator-controlled backup. Container recreation does not delete them.

## Startup behavior

1. MariaDB initializes and must pass its health check.
2. Nextcloud starts with the official image's database and administrator variables.
3. Nextcloud becomes healthy only after `status.php` reports an installed instance.
4. The tunnel starts after Nextcloud is healthy.

This ordering avoids exposing a half-installed application and reduces first-boot race conditions.

## Trust boundaries

- Cloudflare is trusted to terminate public HTTPS and route the request.
- The tunnel token is sufficient to run the tunnel and is therefore secret.
- Nextcloud remains responsible for users, sessions, sharing and application permissions.
- MariaDB is reachable only from the internal application network.
- The host operator remains responsible for patches, backups and incident response.

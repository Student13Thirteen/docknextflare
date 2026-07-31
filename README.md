# DockNextFlare

[![Validate](https://github.com/Student13Thirteen/docknextflare/actions/workflows/validate.yml/badge.svg)](https://github.com/Student13Thirteen/docknextflare/actions/workflows/validate.yml)

**Your own Nextcloud, reachable from anywhere — without router port forwarding and without a reverse-proxy maze.**

DockNextFlare deliberately does one job: it runs Nextcloud and MariaDB on an isolated Docker network, then exposes only the web application through an outbound Cloudflare Tunnel.

After the tunnel exists, the complete local setup is one guided command:

```bash
bash docknextflare setup
```

The script checks Docker, generates strong credentials, validates the Compose model, starts the services, waits for Nextcloud and prints the login details.

> Portfolio focus: reducing operational friction without hiding the architecture. The automation is small enough to read, diagnose and modify.

## The idea in one diagram

```text
phone / laptop anywhere
          |
          | HTTPS
          v
   Cloudflare edge
          |
          | outbound tunnel only
          v
      cloudflared -------- edge network -------- Nextcloud
                                                   |
                                                   | isolated backend network
                                                   v
                                                MariaDB
```

No application or database port is published on the host. The database is not connected to the tunnel network.

## Two-minute setup

### 1. Create the tunnel

In Cloudflare, create a **remotely-managed Tunnel**, add the public hostname you want, and set its service to:

```text
http://app:80
```

Copy the tunnel token.

### 2. Run the guided command

```bash
git clone https://github.com/Student13Thirteen/docknextflare.git
cd docknextflare
bash docknextflare setup
```

You will be asked only for:

- the public hostname, such as `cloud.example.com`;
- the Cloudflare tunnel token;
- the desired initial admin username.

Passwords are generated automatically and stored in a local `.env` file with restrictive permissions.

## One small operations CLI

| Command | Purpose |
|---|---|
| `bash docknextflare setup` | guided first deployment |
| `bash docknextflare start` | start or reconcile the stack |
| `bash docknextflare stop` | stop containers without deleting data |
| `bash docknextflare status` | show container and health state |
| `bash docknextflare doctor` | verify Docker, configuration, services, OCC and public reachability |
| `bash docknextflare logs app` | follow one service log; also accepts `db` or `tunnel` |
| `bash docknextflare backup` | database dump + Nextcloud files archive + checksums |
| `bash docknextflare update` | create a backup, pull images and restart |
| `bash docknextflare credentials` | show the locally stored initial login |

This is the memorable part of the project: not another large control panel, but a readable command that covers the repetitive and failure-prone operations.

## What the setup automates

- prerequisite and Docker daemon checks;
- secure random database and administrator credentials;
- `.env` creation with mode `600`;
- persistent data directory creation;
- Compose interpolation and syntax validation;
- image pull and idempotent startup;
- database readiness and application health waiting;
- automatic Nextcloud installation;
- trusted-domain and HTTPS overwrite configuration;
- a final URL and credential summary.

The official Nextcloud image supports initial administrator, trusted-domain and reverse-proxy settings through environment variables. Cloudflare remotely-managed tunnels need only their token to run, so a local tunnel ID or credentials file is unnecessary.

## Design decisions

| Problem | Smallest useful decision |
|---|---|
| Router cannot or should not expose ports | outbound Cloudflare Tunnel |
| Database should never face the tunnel | separate internal `backend` network |
| First installation is repetitive | official Nextcloud auto-configuration variables |
| Secrets are easy to mistype | generated credentials and private `.env` |
| Startup races with MariaDB | health check and conditional dependency |
| Updates are risky without a recovery point | backup automatically before update |
| “It is down” gives little information | one `doctor` command spanning host, containers and app |

## Repository map

```text
docknextflare/
|- docknextflare              # setup and operations command
|- docker-compose.yml         # three-service architecture
|- .env.example               # documented configuration contract
|- docs/
|  |- architecture.md
|  |- backup-restore.md
|  |- deployment.md
|  |- runbook.md
|  |- security.md
|  `- troubleshooting.md
`- .github/workflows/validate.yml
```

Runtime state is kept under `data/`; backups are written under `backups/`. Both are ignored by Git.

## Security boundary

DockNextFlare reduces network exposure; it does not remove the operator's responsibilities.

- protect `.env` and the tunnel token;
- enable MFA for Cloudflare and the Nextcloud administrator;
- patch the host and update images deliberately;
- keep offline or remote copies of backups;
- test a restore before trusting the backup process;
- review Nextcloud users, apps and sharing policies.

The tunnel token can run the tunnel and must be treated as a secret. Cloudflare terminates the public HTTPS connection, while Nextcloud remains responsible for application authentication and authorization.

## Scope

This is a compact, understandable deployment for a personal cloud, homelab or small internal use case. It is not presented as:

- a replacement for the official Nextcloud All-in-One distribution;
- a highly available multi-node platform;
- a managed backup service;
- an audited enterprise security product;
- a zero-maintenance appliance.

The value is the combination of a useful service, a narrow security model and automation that remains explainable.

## Documentation

| Document | Purpose |
|---|---|
| [`docs/deployment.md`](docs/deployment.md) | exact first-deployment flow |
| [`docs/architecture.md`](docs/architecture.md) | network and trust boundaries |
| [`docs/runbook.md`](docs/runbook.md) | routine operations and diagnosis |
| [`docs/backup-restore.md`](docs/backup-restore.md) | backup contents and restore procedure |
| [`docs/security.md`](docs/security.md) | threats, limits and hardening |
| [`docs/troubleshooting.md`](docs/troubleshooting.md) | symptom-driven recovery |

## Related project

[UptimeMonitoring](https://github.com/Student13Thirteen/uptimemonitoring) can monitor the public endpoint and send Telegram alerts.

## License

MIT — see [`LICENSE`](LICENSE).

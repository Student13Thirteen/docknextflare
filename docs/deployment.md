# Deployment

## Prerequisites

- Linux host with Docker Engine and Docker Compose v2;
- a domain managed by Cloudflare;
- a remotely-managed Cloudflare Tunnel;
- a public hostname route targeting `http://app:80`.

No router port forwarding is required.

## Guided deployment

```bash
git clone https://github.com/Student13Thirteen/docknextflare.git
cd docknextflare
bash docknextflare setup
```

The command asks for the hostname, tunnel token and administrator username. It then generates all passwords, writes `.env`, creates persistent directories, validates Compose, pulls images and starts the stack.

## Cloudflare dashboard step

For the selected Tunnel, create a Public Hostname:

```text
Hostname: cloud.example.com
Type:     HTTP
URL:      app:80
```

The `app` hostname is resolved by Docker inside the shared `edge` network. Do not point Cloudflare at a host port because the Compose file deliberately publishes none.

## Verify

```bash
bash docknextflare status
bash docknextflare doctor
```

Then open:

```text
https://cloud.example.com
```

The initial login can be displayed locally with:

```bash
bash docknextflare credentials
```

## Existing installations

The automatic administrator and database variables affect initial installation. They do not re-create or overwrite an existing database under `data/`.

Before moving an existing installation into this layout:

1. back up the database and Nextcloud directory;
2. preserve the existing `config.php` and data directory;
3. adapt paths deliberately rather than running a fresh setup over them;
4. test the migration on a copy.

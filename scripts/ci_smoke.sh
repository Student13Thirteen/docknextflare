#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

cleanup() {
  docker compose down -v --remove-orphans >/dev/null 2>&1 || true
  docker run --rm -v "$ROOT_DIR:/workspace" alpine:3.21 \
    sh -c 'rm -rf /workspace/data /workspace/backups' >/dev/null 2>&1 || true
  rm -f .env
}

show_diagnostics() {
  printf '\n--- docker compose ps ---\n' >&2
  docker compose ps -a >&2 || true
  printf '\n--- MariaDB logs ---\n' >&2
  docker compose logs --no-color --tail=200 db >&2 || true
  printf '\n--- Nextcloud logs ---\n' >&2
  docker compose logs --no-color --tail=250 app >&2 || true
}

trap cleanup EXIT
trap show_diagnostics ERR

cat > .env <<'ENV'
NEXTCLOUD_HOSTNAME=cloud.example.com
NEXTCLOUD_ADMIN_USER=admin
NEXTCLOUD_ADMIN_PASSWORD=CI_admin_password_1234
MYSQL_ROOT_PASSWORD=CI_root_password_1234
MYSQL_PASSWORD=CI_database_password_1234
CLOUDFLARE_TOKEN=ci-placeholder-token
PHP_MEMORY_LIMIT=512M
PHP_UPLOAD_LIMIT=1G
ENV

mkdir -p data/nextcloud data/mariadb backups

docker compose config --quiet
# The tunnel needs a real Cloudflare token, so CI starts and verifies the
# complete private-cloud core while the workflow separately validates its model.
docker compose up -d db app

healthy=false
for _ in $(seq 1 100); do
  state="$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' "$(docker compose ps -q app)" 2>/dev/null || true)"
  if [[ "$state" == healthy ]]; then
    healthy=true
    break
  fi
  [[ "$state" =~ ^(unhealthy|exited|dead)$ ]] && false
  sleep 5
done
[[ "$healthy" == true ]]

STATUS_JSON="$(docker compose exec -T -u www-data app php occ status --output=json)"
python3 -c 'import json,sys; data=json.load(sys.stdin); assert data["installed"] is True; assert data["maintenance"] is False' <<<"$STATUS_JSON"

docker compose exec -T app php -r '
$j=json_decode(file_get_contents("http://127.0.0.1/status.php"), true);
if (!is_array($j) || empty($j["installed"]) || empty($j["version"])) exit(1);
'

DB_NETWORKS="$(docker inspect --format '{{range $name, $_ := .NetworkSettings.Networks}}{{$name}} {{end}}' "$(docker compose ps -q db)")"
APP_NETWORKS="$(docker inspect --format '{{range $name, $_ := .NetworkSettings.Networks}}{{$name}} {{end}}' "$(docker compose ps -q app)")"
[[ "$DB_NETWORKS" == *backend* ]]
[[ "$DB_NETWORKS" != *edge* ]]
[[ "$APP_NETWORKS" == *backend* && "$APP_NETWORKS" == *edge* ]]
[[ -z "$(docker compose ps -q tunnel)" ]]

trap - ERR
echo 'DockNextFlare clean-room core smoke test passed.'

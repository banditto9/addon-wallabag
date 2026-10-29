#!/usr/bin/env bash
# Build-time helper: stop nginx from logging routine, successful requests
# (API polling, assets, JS routing). Errors (non-2xx/3xx) are still logged.
set -euo pipefail

NGINX_DIR=/etc/nginx
MAP_FILE="${NGINX_DIR}/conf.d/00-loggable.conf"

# The map must be loaded in the http context, otherwise nginx will refuse
# to start with "unknown variable $loggable".
if ! grep -qE 'include[[:space:]]+/etc/nginx/conf\.d/\*\.conf' "${NGINX_DIR}/nginx.conf"; then
    echo "ERROR: ${NGINX_DIR}/nginx.conf does not include conf.d/*.conf." >&2
    echo "Add the map from this script to the http{} block manually." >&2
    exit 1
fi

mkdir -p "${NGINX_DIR}/conf.d"
cat > "${MAP_FILE}" <<'EOF'
# 0 = do not log, 1 = log. Only successful (2xx/3xx) noisy requests are skipped.
map "$request_uri:$status" $loggable {
    default 1;
    "~^/(api/|js/routing|wallassets/|annotations/|oauth/v2/token).*:[23][0-9][0-9]$" 0;
}
EOF

# Append "if=$loggable" to every active access_log directive (idempotent).
while IFS= read -r f; do
    [ "$f" = "${MAP_FILE}" ] && continue
    sed -Ei '/^[[:space:]]*access_log[[:space:]]+off[[:space:]]*;/! { /if=/! s/^([[:space:]]*access_log[[:space:]]+[^;]*[^[:space:];])[[:space:]]*;/\1 if=$loggable;/ }' "$f"
done < <(grep -rlE '^[[:space:]]*access_log[[:space:]]' "${NGINX_DIR}" || true)

if ! grep -rqF 'if=$loggable' "${NGINX_DIR}" --exclude="$(basename "${MAP_FILE}")"; then
    echo "ERROR: no access_log directive was patched; check your nginx config." >&2
    exit 1
fi

echo "nginx access log filter installed."
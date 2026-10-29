#!/usr/bin/env bash
# Build-time helper: stop nginx from logging routine, successful requests
# (API polling, assets, JS routing, manifest). Errors (non-2xx/3xx) are still logged.
set -euo pipefail

NGINX_DIR=/etc/nginx
NGINX_CONF="${NGINX_DIR}/nginx.conf"
MAP_FILE="${NGINX_DIR}/loggable.map.conf"

# 1) Create the map in its own file
cat > "${MAP_FILE}" <<'EOF'
# 0 = do not log, 1 = log. Only successful (2xx/3xx) noisy requests are skipped.
map "$request_uri:$status" $loggable {
    default 1;
    "~^/(api/|js/routing|wallassets/|annotations/|oauth/v2/token|manifest\.json).*:[23][0-9][0-9]$" 0;
}
EOF

# 2) Include it right after the opening "http {" of nginx.conf (idempotent)
if ! grep -qF "${MAP_FILE}" "${NGINX_CONF}"; then
    if ! grep -qE '^[[:space:]]*http[[:space:]]*\{' "${NGINX_CONF}"; then
        echo "ERROR: no 'http {' block found in ${NGINX_CONF}." >&2
        exit 1
    fi
    sed -Ei "0,/^[[:space:]]*http[[:space:]]*\{/ s//&\n    include ${MAP_FILE//\//\\/};/" "${NGINX_CONF}"
fi

if ! grep -qF "include ${MAP_FILE};" "${NGINX_CONF}"; then
    echo "ERROR: failed to insert the map include into ${NGINX_CONF}." >&2
    exit 1
fi

# 3) Append "if=$loggable" to every active access_log directive (idempotent)
patched=0
while IFS= read -r f; do
    sed -Ei '/^[[:space:]]*access_log[[:space:]]+off[[:space:]]*;/! { /if=/! s/^([[:space:]]*access_log[[:space:]]+[^;]*[^[:space:];])[[:space:]]*;/\1 if=$loggable;/ }' "$f"
    patched=1
don
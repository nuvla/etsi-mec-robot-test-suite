#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}"

if [[ -z "${ROBOT_BIN:-}" ]]; then
  if [[ -x "${REPO_ROOT}/.venv/bin/robot" ]]; then
    ROBOT_BIN="${REPO_ROOT}/.venv/bin/robot"
  else
    ROBOT_BIN="robot"
  fi
fi
NUVLA_BASE_URL="${NUVLA_BASE_URL:-http://127.0.0.1:8200}"
SESSION_URL="${SESSION_URL:-${NUVLA_BASE_URL}/api/session}"
OUTPUT_DIR="${OUTPUT_DIR:-/tmp/robot-adapted-all}"
AUTH_HEADER_NAME="${AUTH_HEADER_NAME:-nuvla-authn-info}"
API_ROOT="${API_ROOT:-/api/mec/mm1}"

usage() {
  cat <<'EOF'
Run the ETSI MEC Robot suites adapted for local Nuvla testing.

Usage:
  NUVLA_API_KEY=credential/... NUVLA_API_SECRET=... ./run-adapted-etsi-tests.sh [robot args...]

Environment:
  NUVLA_API_KEY        Required. Nuvla API key credential ID.
  NUVLA_API_SECRET     Required. Nuvla API secret.
  NUVLA_BASE_URL       Optional. Defaults to http://127.0.0.1:8200
  SESSION_URL          Optional. Defaults to $NUVLA_BASE_URL/api/session
  ROBOT_BIN            Optional. Defaults to ./.venv/bin/robot, then robot on PATH
  OUTPUT_DIR           Optional. Defaults to /tmp/robot-adapted-all
  AUTH_HEADER_NAME     Optional. Defaults to nuvla-authn-info
  API_ROOT             Optional. Defaults to /api/mec/mm1

Examples:
  NUVLA_API_KEY=credential/... \
  NUVLA_API_SECRET=... \
  ./run-adapted-etsi-tests.sh

  NUVLA_API_KEY=credential/... \
  NUVLA_API_SECRET=... \
  OUTPUT_DIR=/tmp/robot-pkgm-only \
  ./run-adapted-etsi-tests.sh -t TC_MEC_MEC010p2_MEO_PKGM_001_OK
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

: "${NUVLA_API_KEY:?Set NUVLA_API_KEY in the environment}"
: "${NUVLA_API_SECRET:?Set NUVLA_API_SECRET in the environment}"

if [[ ! -x "${ROBOT_BIN}" ]] && ! command -v "${ROBOT_BIN}" >/dev/null 2>&1; then
  echo "Robot executable not found (tried ${ROBOT_BIN}). Set ROBOT_BIN or install Robot Framework." >&2
  exit 1
fi

read -r BASE_SCHEME BASE_HOST BASE_PORT <<<"$(
  NUVLA_BASE_URL="${NUVLA_BASE_URL}" python3 <<'PY'
from urllib.parse import urlparse
import os

parsed = urlparse(os.environ["NUVLA_BASE_URL"])
scheme = parsed.scheme or "http"
host = parsed.hostname or "127.0.0.1"
port = parsed.port or (443 if scheme == "https" else 80)
print(scheme, host, port)
PY
)"

AUTH_HEADER_VALUE="$(
  NUVLA_API_KEY="${NUVLA_API_KEY}" \
  NUVLA_API_SECRET="${NUVLA_API_SECRET}" \
  SESSION_URL="${SESSION_URL}" \
  python3 <<'PY'
import base64
import json
import os
import urllib.request

payload = {
    "template": {
        "href": "session-template/api-key",
        "key": os.environ["NUVLA_API_KEY"],
        "secret": os.environ["NUVLA_API_SECRET"],
    }
}

req = urllib.request.Request(
    os.environ["SESSION_URL"],
    data=json.dumps(payload).encode(),
    headers={"Content-Type": "application/json"},
)

with urllib.request.urlopen(req) as response:
    cookie = response.headers["Set-Cookie"].split(";", 1)[0].split("=", 1)[1]

part = cookie.split(".")[1]
part += "=" * (-len(part) % 4)
claims = json.loads(base64.urlsafe_b64decode(part.encode()))

print(f"{claims['user-id']} {claims['user-id']} {claims['claims']}")
PY
)"

mkdir -p "${OUTPUT_DIR}"

exec "${ROBOT_BIN}" \
  -v "NUVLA_API_KEY:${NUVLA_API_KEY}" \
  -v "NUVLA_API_SECRET:${NUVLA_API_SECRET}" \
  -v "AUTH_HEADER_NAME:${AUTH_HEADER_NAME}" \
  -v "AUTH_HEADER_VALUE:${AUTH_HEADER_VALUE}" \
  -v "apiRoot:${API_ROOT}" \
  -v "MEO_SCHEMA:${BASE_SCHEME}" \
  -v "MEO_HOST:${BASE_HOST}" \
  -v "MEO_PORT:${BASE_PORT}" \
  -v "MEPM_SCHEMA:${BASE_SCHEME}" \
  -v "MEPM_HOST:${BASE_HOST}" \
  -v "MEPM_PORT:${BASE_PORT}" \
  --outputdir "${OUTPUT_DIR}" \
  "$@" \
  "${REPO_ROOT}/MEC010p2/MEO/PKGM/AppPkgMgt.robot" \
  "${REPO_ROOT}/MEC010p2/MEX/LCM/AppInstanceMgmt.robot"

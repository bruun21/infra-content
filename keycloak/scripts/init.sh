#!/bin/sh
set -eu

KEYCLOAK_URL=${KEYCLOAK_URL:-http://keycloak:8080}
ADMIN_USER=${KEYCLOAK_ADMIN_USER:-admin}
ADMIN_PASS=${KEYCLOAK_ADMIN_PASS:-admin}
REALM=${KEYCLOAK_REALM:-creator-platform}

echo "[keycloak-config] Waiting for Keycloak admin to be ready..."
ATTEMPTS=0
until /opt/keycloak/bin/kcadm.sh config credentials \
  --server "${KEYCLOAK_URL}" \
  --realm master \
  --user "${ADMIN_USER}" \
  --password "${ADMIN_PASS}" >/dev/null 2>&1; do
  ATTEMPTS=$((ATTEMPTS+1))
  if [ $ATTEMPTS -gt 60 ]; then
    echo "[keycloak-config] Timeout waiting for admin login." >&2
    exit 1
  fi
  sleep 2
done

echo "[keycloak-config] Waiting for realm '${REALM}' to exist..."
ATTEMPTS=0
until /opt/keycloak/bin/kcadm.sh get realms/"${REALM}" >/dev/null 2>&1; do
  ATTEMPTS=$((ATTEMPTS+1))
  if [ $ATTEMPTS -gt 60 ]; then
    echo "[keycloak-config] Timeout waiting for realm '${REALM}'." >&2
    exit 1
  fi
  sleep 2
done

# Create confidential client with a known secret (idempotent)
CLIENT_ID=${KEYCLOAK_CLIENT_ID:-api-client}
CLIENT_SECRET=${KEYCLOAK_CLIENT_SECRET:-super-secret-123}
echo "[keycloak-config] Ensuring client '${CLIENT_ID}' exists..."
if ! /opt/keycloak/bin/kcadm.sh get clients -r "${REALM}" -q clientId="${CLIENT_ID}" | grep -q '"id"'; then
  /opt/keycloak/bin/kcadm.sh create clients -r "${REALM}" \
    -s clientId="${CLIENT_ID}" \
    -s enabled=true \
    -s protocol=openid-connect \
    -s publicClient=false \
    -s serviceAccountsEnabled=true \
    -s standardFlowEnabled=true \
    -s directAccessGrantsEnabled=true \
    -s clientAuthenticatorType=client-secret \
    -s secret="${CLIENT_SECRET}" \
    -s 'redirectUris=["http://localhost:8080/*","http://localhost/*"]' \
    -s 'webOrigins=["*"]'
else
  echo "[keycloak-config] Client already exists; updating secret..."
  CID=$(/opt/keycloak/bin/kcadm.sh get clients -r "${REALM}" -q clientId="${CLIENT_ID}" | sed -n 's/.*"id"\s*:\s*"\([^"]*\)".*/\1/p' | head -n1)
  if [ -n "$CID" ]; then
    /opt/keycloak/bin/kcadm.sh update clients/"$CID"/client-secret -r "${REALM}" -s value="${CLIENT_SECRET}" || true
  fi
fi

# Create test user and assign realm role CREATOR (idempotent)
TEST_USER=${KEYCLOAK_TEST_USER:-tester}
TEST_PASS=${KEYCLOAK_TEST_PASS:-tester}
echo "[keycloak-config] Ensuring user '${TEST_USER}' exists..."
if ! /opt/keycloak/bin/kcadm.sh get users -r "${REALM}" -q username="${TEST_USER}" | grep -q '"id"'; then
  /opt/keycloak/bin/kcadm.sh create users -r "${REALM}" \
    -s username="${TEST_USER}" \
    -s enabled=true \
    -s email="${TEST_USER}@example.com"
  /opt/keycloak/bin/kcadm.sh set-password -r "${REALM}" --username "${TEST_USER}" --new-password "${TEST_PASS}" --temporary=false
fi

echo "[keycloak-config] Assigning realm role 'CREATOR' to '${TEST_USER}'..."
/opt/keycloak/bin/kcadm.sh add-roles -r "${REALM}" --uusername "${TEST_USER}" --rolename CREATOR || true

echo "[keycloak-config] Requesting password grant token for user '${TEST_USER}'..."
TOKEN_JSON=$(wget -qO- \
  --header="Content-Type: application/x-www-form-urlencoded" \
  --post-data="grant_type=password&client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&username=${TEST_USER}&password=${TEST_PASS}" \
  "${KEYCLOAK_URL}/realms/${REALM}/protocol/openid-connect/token" || true)

# Tenta extrair apenas o access_token; se falhar, imprime o JSON completo
ACCESS_TOKEN=$(printf "%s" "$TOKEN_JSON" | sed -n 's/.*"access_token"\s*:\s*"\([^"]*\)".*/\1/p' || true)
if [ -n "$ACCESS_TOKEN" ]; then
  echo "[keycloak-config] TEST ACCESS TOKEN (paste into Authorization: Bearer):"
  echo "$ACCESS_TOKEN"
else
  echo "[keycloak-config] Token JSON response (jq not available; copy 'access_token'):" 
  echo "$TOKEN_JSON"
fi

echo "[keycloak-config] Done. Client='${CLIENT_ID}', Secret='${CLIENT_SECRET}', User='${TEST_USER}'."

# Keycloak Setup — creator-platform realm (local)

Objective: provision a Keycloak realm for the Carousel Service using the exact issuer, ports, roles, and clients expected by the app.

—

## Service expectations
- Issuer URI: `http://localhost:8081/realms/creator-platform`
- Realm name: `creator-platform`
- Accepted roles: `ROLE_CREATOR` or `ROLE_SYSTEM`
  - Create realm roles: `CREATOR` and `SYSTEM` (the service maps them to `ROLE_*`).
- Token claim used: `realm_access.roles`
- Env var in app: `KEYCLOAK_ISSUER_URI=http://localhost:8081/realms/creator-platform`

—

## Running Keycloak (dev)
- Image: `quay.io/keycloak/keycloak:26.0`
- Dev mode command: `start-dev --http-port=8080`
- Host port mapping: `8081:8080`
- Admin credentials:
  - `KEYCLOAK_ADMIN=admin`
  - `KEYCLOAK_ADMIN_PASSWORD=admin`
- Access admin console: `http://localhost:8081`

### Reference docker-compose (standalone microservice)
Use this in a separate repository to run Keycloak for local dev:
```
version: '3.9'
services:
  keycloak:
    image: quay.io/keycloak/keycloak:26.0
    command: start-dev --http-port=8080
    environment:
      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD: admin
    ports:
      - "8081:8080"
```

Optionally, if you want to import a realm JSON at startup, add `--import-realm` to the command and mount a read-only folder at `/opt/keycloak/data/import`.

—

## Minimal UI setup (Admin Console)
1) Create Realm
   - Name: `creator-platform`

2) Create Realm Roles
   - `CREATOR`
   - `SYSTEM`

3) Create Clients
   - Client A (public, for human users)
     - Client ID: `carousel-api-client`
     - Client Type: Public
     - Standard Flow: Off (optional)
     - Direct Access Grants: On (to allow password grant for testing)
   - Client B (confidential, for system-to-system)
     - Client ID: `carousel-system-client`
     - Client Type: Confidential
     - Service Accounts Enabled: On
     - Copy the generated Client Secret (Credentials tab)

4) Grant Roles
   - Users → create a user (e.g., `creator1`), set password (disable Temporary), assign Realm Role `CREATOR`.
   - Clients → `carousel-system-client` → Service Account Roles → assign Realm Role `SYSTEM`.

5) Verify Endpoints
   - Issuer: `http://localhost:8081/realms/creator-platform`
   - Token endpoint: `http://localhost:8081/realms/creator-platform/protocol/openid-connect/token`

—

## Automated setup with kcadm.sh (inside container)
1) Exec into Keycloak container and login as admin
```
docker exec -it keycloak /bin/bash
/opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080 --realm master --user admin --password admin
```

2) Create realm
```
/opt/keycloak/bin/kcadm.sh create realms -s realm=creator-platform -s enabled=true
```

3) Create realm roles
```
/opt/keycloak/bin/kcadm.sh create roles -r creator-platform -s name=CREATOR
/opt/keycloak/bin/kcadm.sh create roles -r creator-platform -s name=SYSTEM
```

4) Create clients
```
# Public client for password grant
/opt/keycloak/bin/kcadm.sh create clients -r creator-platform \
  -s clientId=carousel-api-client \
  -s publicClient=true \
  -s directAccessGrantsEnabled=true \
  -s standardFlowEnabled=false \
  -s serviceAccountsEnabled=false

# Confidential client for client_credentials (service account)
/opt/keycloak/bin/kcadm.sh create clients -r creator-platform \
  -s clientId=carousel-system-client \
  -s publicClient=false \
  -s serviceAccountsEnabled=true \
  -s directAccessGrantsEnabled=false \
  -s standardFlowEnabled=false \
  -s protocol=openid-connect
```

5) Assign SYSTEM role to the service account
```
CID=$( /opt/keycloak/bin/kcadm.sh get clients -r creator-platform -q clientId=carousel-system-client --fields id --format csv --noquotes )
SID=$( /opt/keycloak/bin/kcadm.sh get clients/$CID/service-account-user -r creator-platform --fields id --format csv --noquotes )
RID=$( /opt/keycloak/bin/kcadm.sh get roles -r creator-platform -q name=SYSTEM --fields id --format csv --noquotes )
/opt/keycloak/bin/kcadm.sh add-roles -r creator-platform --uusername $(/opt/keycloak/bin/kcadm.sh get users/$SID -r creator-platform --fields username --format csv --noquotes) --rolename SYSTEM
```

6) Create test user with CREATOR role
```
/opt/keycloak/bin/kcadm.sh create users -r creator-platform -s username=creator1 -s enabled=true
UID=$( /opt/keycloak/bin/kcadm.sh get users -r creator-platform -q username=creator1 --fields id --format csv --noquotes )
/opt/keycloak/bin/kcadm.sh set-password -r creator-platform --userid $UID --new-password creatorpass --temporary=false
/opt/keycloak/bin/kcadm.sh add-roles -r creator-platform --uusername creator1 --rolename CREATOR
```

—

## Getting tokens
- Client Credentials (ROLE_SYSTEM via service account)
```
curl -s -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=carousel-system-client" \
  -d "client_secret=<CLIENT_SECRET>" \
  http://localhost:8081/realms/creator-platform/protocol/openid-connect/token
```

- Password Grant (ROLE_CREATOR for user)
```
curl -s -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password" \
  -d "client_id=carousel-api-client" \
  -d "username=creator1" \
  -d "password=creatorpass" \
  http://localhost:8081/realms/creator-platform/protocol/openid-connect/token
```

—

## Calling the Carousel API
```
ACCESS_TOKEN=... # from one of the flows above
curl -s -X POST http://localhost:8080/api/generate-carousel \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "workflowId": "550e8400-e29b-41d4-a716-446655440000",
    "baseText": "Texto com pelo menos 300 caracteres...",
    "quantidade": 6,
    "estilo": "motivacional",
    "nicho": "educacional"
  }'
```

Expected: 200 OK when token has `realm_access.roles` including `CREATOR` or `SYSTEM`. Without a valid token → 401/403.

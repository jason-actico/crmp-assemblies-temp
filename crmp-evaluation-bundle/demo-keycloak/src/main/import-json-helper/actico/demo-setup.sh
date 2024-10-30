/opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8614 --realm master --user admin --password admin

# create realm
/opt/keycloak/bin/kcadm.sh create realms -s realm=actico-demo -s id=actico-demo -s enabled=true

# create john, mary, admin and some roles etc.
/opt/keycloak/bin/kcadm.sh create users -s username=john -s enabled=true -r actico-demo
/opt/keycloak/bin/kcadm.sh create users -s username=mary -s enabled=true -r actico-demo
/opt/keycloak/bin/kcadm.sh create users -s username=admin -s enabled=true -r actico-demo

# add user credentials
/opt/keycloak/bin/kcadm.sh set-password -r actico-demo --new-password=john --username=john
/opt/keycloak/bin/kcadm.sh set-password -r actico-demo --new-password=mary --username=mary
/opt/keycloak/bin/kcadm.sh set-password -r actico-demo --new-password=admin --username=admin

# set displayNameHtml to default to show actico logo
/opt/keycloak/bin/kcadm.sh update realms/actico-demo --set 'displayNameHtml="<div class="kc-logo-text"><span>Keycloak</span></div>"'

# create model hub client
/opt/keycloak/bin/kcadm.sh create clients -r actico-demo -s directAccessGrantsEnabled=true -s clientId=demo-client-model-hub -s id=demo-client-model-hub -s enabled=true -s publicClient=true -s 'redirectUris=["http://localhost:8080/*"]' -s 'webOrigins=["+"]' -s 'attributes={"post.logout.redirect.uris": "+", "login_theme": "actico-platform-theme"}'

# create model hub client roles
/opt/keycloak/bin/kcadm.sh create realms/actico-demo/clients/demo-client-model-hub/roles -r actico-demo -s "name=Business Analyst" -s "description=Business Analyst"
/opt/keycloak/bin/kcadm.sh create realms/actico-demo/clients/demo-client-model-hub/roles -r actico-demo -s name=Supervisor -s "description=Supervisor"

# assign model hub client roles to users
/opt/keycloak/bin/kcadm.sh add-roles -r actico-demo --uusername john --cclientid demo-client-model-hub --rolename "Business Analyst"
/opt/keycloak/bin/kcadm.sh add-roles -r actico-demo --uusername admin --cclientid demo-client-model-hub --rolename "Business Analyst"
/opt/keycloak/bin/kcadm.sh add-roles -r actico-demo --uusername admin --cclientid demo-client-model-hub --rolename Supervisor

# create workplace client
/opt/keycloak/bin/kcadm.sh create clients -r actico-demo -s directAccessGrantsEnabled=true -s clientId=demo-client-workplace -s id=demo-client-workplace -s enabled=true -s publicClient=true -s 'redirectUris=["http://localhost:8050/*", "http://localhost:8049/*"]' -s 'webOrigins=["+"]' -s 'attributes={"post.logout.redirect.uris": "+", "login_theme": "actico-platform-theme"}'

# create workplace client roles
/opt/keycloak/bin/kcadm.sh create realms/actico-demo/clients/demo-client-workplace/roles -r actico-demo -s name=ROLE_EURENT_AGENT -s "description=EU Rent Agent"
/opt/keycloak/bin/kcadm.sh create realms/actico-demo/clients/demo-client-workplace/roles -r actico-demo -s name=ROLE_SYSTEM_ADMIN -s "description=System Admin"

# assign workplace client roles to users
/opt/keycloak/bin/kcadm.sh add-roles -r actico-demo --uusername john --cclientid demo-client-workplace --rolename ROLE_EURENT_AGENT
/opt/keycloak/bin/kcadm.sh add-roles -r actico-demo --uusername john --cclientid demo-client-workplace --rolename ROLE_SYSTEM_ADMIN
/opt/keycloak/bin/kcadm.sh add-roles -r actico-demo --uusername mary --cclientid demo-client-workplace --rolename ROLE_EURENT_AGENT
/opt/keycloak/bin/kcadm.sh add-roles -r actico-demo --uusername admin --cclientid demo-client-workplace --rolename ROLE_SYSTEM_ADMIN

# create execution server client
/opt/keycloak/bin/kcadm.sh create clients -r actico-demo -s directAccessGrantsEnabled=true -s clientId=demo-client-execution-server -s id=demo-client-execution-server -s enabled=true -s publicClient=true -s 'redirectUris=["http://localhost:9090/*"]' -s 'webOrigins=["+"]' -s 'attributes={"post.logout.redirect.uris": "+", "login_theme": "actico-platform-theme"}'

# export realm.json
mkdir /opt/keycloak/actico-export
/opt/keycloak/bin/kc.sh export --file /opt/keycloak/actico-export/actico-demo-realm.json --realm actico-demo --users same_file
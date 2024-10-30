This setup is meant for demonstration purposes only! Do not use this setup for production!
---

Steps to run the demo Keycloak:

1. Download Keycloak from https://github.com/keycloak/keycloak/releases/download/@keycloak-version@/keycloak-@keycloak-version@.zip
2. Save it in the folder 'demo-keycloak\downloads' with the name 'keycloak-@keycloak-version@.zip'
3. Execute the script start_demo-keycloak.bat

Keycloak URL: 'http://localhost:7554/'
The credentials are
- username: admin
- password: admin

When accessing your local model-hub instance under 'http://localhost:8080/' you should be redirected to
Keycloak where you can authenticate yourself as:
- username: john  password: john
- username: mary  password: mary
- username: admin password: admin

---

How to add users and roles:

The configuration for this demo setup can be found in actico-demo-realm.json which is used
to initialize the demo setup.
Uses and roles can be added via the Keycloak user interface or with the Keycloak CLI:

demo-keycloak/keycloak/bin/kcadm.bat config credentials --server http://localhost:7554 --realm master --user admin --password admin
demo-keycloak/keycloak/bin/kcadm.bat create users -s username=chris -s enabled=true -r actico-demo
demo-keycloak/keycloak/bin/kcadm.bat set-password -r actico-demo --new-password=chris --username=chris

To reuse the configuration, export it and replace the existing export:

demo-keycloak/keycloak/bin/kc.sh export --file demo-keycloak/actico-realm/actico-demo-realm.json  --realm actico-demo --users same_file



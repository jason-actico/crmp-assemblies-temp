Instructions for Keycloak docker:
=================================

Run the following command from within the demo-keycloak folder

docker run -p 7554:7554 -d --name actico-demo-keycloak -v %cd%\actico-realm:/opt/keycloak/data/import -v %cd%\actico-platform-theme:/opt/keycloak/themes/actico-platform-theme -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin @keycloak-image@ start-dev --http-port=7554 --import-realm

Note: If running in Powershell, use `$pwd` instead of `%cd%`.
# Custom Keycloak theme

The actico platform distribution contains a custom login theme for demo installations. The theme is available for the keycloak local demo installation and the keycloak docker demo installation. The theme is activated by default. 

# Functionality 

The directory *actico-platform-theme* has to be placed inside the keycloak/themes directory. This is done via the start script *1_start_demo-keycloak.bat* or the desired *docker-run* command. 

Within the *demo-setup.sh* the login_theme *actico-platform-theme* is set as default-theme for the clients *demo-client-model-hub* and *demo-client-workplace*. 

The theme contains a custom Actico Platform Login screen. The custom theme is inherited from the base keycloak theme. 

# Development Hints

The theme consists of: 
* HTML-Template (template.ftl)
* Images (actico_background.png, actico_slogan_300dpi.png, favicon.ico)
* Stylesheet (login.css)
* Theme properties file (theme.properties)
* Message bundle (messages_en.properties)

To keep customizing simple it makes sense to extend or modify the existing Keycloak theme. This is possible by overriding individual components.

Following changes happend to the base keycloak theme: 
* The HTML template was extended by a footer with a title and subtitle.
* The background was adapted to the existing Model Hub background.
* The Actico logo was added in the upper right corner (instead of the Keycloak logo in the middle).
* The WindowTitle and favicon were adjusted.
* The property displayNameHtml was set to the default value. This allows to display the Actico logo instead of a title.

Within the admin console the theme can be customized for each client or the whole keycloak.

# References


Documentation is available at [https://www.keycloak.org/docs/latest/server_development/#_themes](https://www.keycloak.org/docs/latest/server_development/#_themes).

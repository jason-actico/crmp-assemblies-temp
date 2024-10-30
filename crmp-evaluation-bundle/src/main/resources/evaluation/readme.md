# CRMP Evaluation Bundle
The 'evaluation' folder of the ACTICO CRMP Evaluation Bundle enables you to quickly setup and run the CRMP components on Microsoft Windows. 

The available scripts unpack the installation files, set configuration parameters and launch the individual components.

## License Configuration
Please assure you have a valid license for Model Hub, CLI and Workplace configured in your user's home directory or copy it to the folder `evaluation\config\license`.
Please see ACTICO Platform Distribution Quickstart Guide for more information.


## Start Model Hub
As Model Hub is necessary for deploying all CRMP modules to CRMP webapps, it needs to be started and configured first.

1. Execute `1_start_model-hub.bat` to start Model Hub. 
2. Open http://localhost:8080 and login as "admin" (optional)

CRMP modules and all necessary dependencies will be uploaded. The environment `crmp-demo` is created

Please see ACTICO Platform Distribution Quickstart Guide for more information.

### Deploy all CRMP Modules to `crmp-demo environment`
Please wait until all CRMP modules have been uploaded to Model Hub (check Model Hub console).

1. Execute `2_start_rule-module-deployment.bat` to deploy all necessary modules to `crmp-demo` environment on Model Hub.

##  Start CRMP Solution Webapp
1. Execute `3_start_crmp-solution-webapp.bat` to start the CRMP Solution Webapp, connected to the Model Hub `crmp-demo`
environment.
2. Open http://localhost:8050 and login as "admin"

Please note that it might take a while until all DB scripts are installed and all modules have been deployed.

##  Start CRMP Solution Webapp Integrationtest
For execution of automated UI Tests. Includes Web Application, Batch as well as the CRMP and Financial Spreading Add-ons
1. Execute `4_start_crmp-solution-webapp-integrationtest.bat` to start the CRMP Solution Integrationtest Webapp, connected to the Model Hub `crmp-demo`
environment.
2. Open http://localhost:8050 and login as "Integrationtest"

Please note that it might take a while until all DB scripts are installed and all modules have been deployed.


##  Start CRMP Solution Batch Application (optionally)
1. Execute `5_start_crmp-solution-batch-application.bat` to start the Batch Application.

It connects to the h2 database of the web application, therefore the web application needs to be running.

##  Start CRMP Solution Batch Application Integrationtest (optionally)
1. Execute `6_start_crmp-solution-batch-application-integrationtest.bat` to start the Batch Application in Integrationtest mode.

Please note that in this case the batch user is set to Integrationtest.

It connects to the h2 database of the web application, therefore the web application needs to be running.
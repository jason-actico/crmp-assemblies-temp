# Steps for doing a workplace upgrade

## General Information
* [ ] CRMP version should be in synch with the SPR/Workplace version
* [ ] On top of that: with every update (Workplace, Spreading or CRMP Database scripts) also the r-version number of CRMP should be increased

## Update versions of all artifacts
* [ ] Update version number of all artifacts to <new_version>-SNAPSHOT: e.g. `mvn versions:set -DnewVersion="NEW_SNAPSHOT_VERSION_TO_BE_RELEASED" -DgenerateBackupPoms=false` in the following folders:
** [ ] crmp-assemblies
** [ ] crmp-rule-module-build

* [ ] Upgrade Workplace dependencies to new version (set workplace.version in assembly parent pom.xml)
* [ ] Upgrade Financial Spreading dependencies to the new version (set financial-spreading* properties in assembly parent pom.xml)

## Adjust dependencies and the versions in the rulemodels
* [ ] Create new streams if required due to a major/minor upgrade (otherwise keeping the existing should be suitable)
* [ ] Upgrade Workplace dependencies to new  version 
* [ ] Upgrade Financial Spreading dependencies to new version
* [ ] workplace-rules-test-support should be the same version as in Financial Spreading - hence use financial-spreading-rules-test-support

## After product issues and documentation
* [ ] Check if any of the issues in https://jira.bfs-intra.net/projects/CRMP/versions/17240 can be addressed
* [ ] Check Workplace Upgrade Guide and Internal Migration Hints if anything else needs to be done
* [ ] Check SPR Upgrade Guide and Internal Migration Hints if anything else needs to be done

## Build Eval Bundle
* Checkin the model changes to the central Model Hub
* Commit the SVN changes
* Go to the Jenkins and:
** start the model build: 02.crmp-rule-module-build.trunk.continuous.nightly.release
** start the assemblies build: 03.crmp-assemblies.trunk.continuous.nightly.no.release-assembly
* Download the Eval bundle from the artifactory at ...

## If it is necessary to assign permissions to CRMP roles (should be noted in the migration hints)
* [ ] Open crmp-crmp-dbmodel --> CreateUsersRolesAndPermissionsDBScripts_CRMP.xlsm
* [ ] Type in the new permissions into the sheet Permission (important: do not insert or delete rows. Just use empty rows)
* [ ] Assign the new permissions to the roles, which should have the permissions (sheet: Role - Business Permission)
* [ ] Go to the sheet "control" and and click both buttons ("Generate SQL Roles & Permissions" and "Generate SQL Users") (for oracle / h2, mssql and mysql)
* [ ] Go to the sheet "ALL_IN_ONE" and copy the entries of the column B into the 01__initial-permissions.dml scripts (for oracle / h2, mssql and mysql)

## Docker 
* [ ] Once testing (e.g. using the evaluation bundle) is completed, everything has been checked in and all jenkins jobs were successfuly update the docker image. See "CRMP Docker image creation guide" in confluence for reference

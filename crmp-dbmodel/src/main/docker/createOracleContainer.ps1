Param(
#Used for docker naming of images and containers
   [String]$DOCKER_NAME_PREFIX = "crmp-oracle",

#DB model root directory
   [String]$DB_MODEL_ROOT_DIR = "../../../",
   
#Target directory for the docker files (within the maven target directory)
   [String]$TARGET_DIR = "$DB_MODEL_ROOT_DIR/target/dbscripts"
)
##############################################################################
## Target Path to Created Files ##############################################
##############################################################################
$DBContainerName="$DOCKER_NAME_PREFIX-db"
$DBScriptPaths = @()

##############################################################################
## WORKAROUND for PASSWORD POLICY  ###########################################
## Create a file which updates the password (to the same one) ################
## to avoid password warning message #########################################
##############################################################################
"ALTER USER hr IDENTIFIED BY hr;" | Out-File -FilePath $TARGET_DIR/00__update_user_oracle.ddl -Append
$DBScriptPaths += "$TARGET_DIR/00__update_user_oracle.ddl"

try  
{
 	echo "Clean up target (temp) directory"

	If (Test-Path "$TARGET_DIR/temp")
	{
		Remove-Item -Recurse -Force "$TARGET_DIR/temp"
    }
    	
    . util/commonFunctions.ps1 
    Push-Location $PSScriptRoot

    $tempdir = "$pwd/$TARGET_DIR/temp"
    CreateDirectoryOrRemoveContent $tempdir
    CopyAndPrefixForOracle $DBScriptPaths $tempdir
    
    $absolutePath = (Resolve-Path "$tempdir").Path

    StopAndRemoveContainer $DBContainerName
    docker run --name $DBContainerName -v ${absolutePath}:/docker-entrypoint-initdb.d -d -p 1521:1521 docker.bfs-intra.net/database/oracle-database-instance:12.1.0.2

    docker logs -f $DBContainerName
    #$ip=docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$DBContainerName"
}
finally
{
    Pop-Location
}
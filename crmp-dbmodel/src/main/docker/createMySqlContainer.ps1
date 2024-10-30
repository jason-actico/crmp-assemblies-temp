Param(
#Used for docker naming of images and containers
   [String]$DOCKER_NAME_PREFIX = "crmp-mysql",

#DB model root directory
   [String]$DB_MODEL_ROOT_DIR = "../../../",
   
#Target directory for the docker files (within the maven target directory)
   [String]$TARGET_DIR = "$DB_MODEL_ROOT_DIR/target/dbscripts"
)
##############################################################################
## Target Path to Created Files ##############################################
##############################################################################
$DBFilesTargetDir="$TARGET_DIR/workplace-files"
$DBContainerName="$DOCKER_NAME_PREFIX-db"
$DBScriptPaths = @()

##############################################################################
## Nothing to initialize for MySql at the moment #############################
##############################################################################

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
    CopyForMysql $DBScriptPaths $tempdir
    
	## initial scripts
    $InsertCmd = CreateInitialScriptString $DBScriptPaths "/dbscripts"
	echo "Initial CMD: " $InsertCmd
	
    $absolutePath = (Resolve-Path "$tempdir").Path
	
    StopAndRemoveContainer $DBContainerName
    docker run --cap-add=SYS_PTRACE --name $DBContainerName -p 3306:3306 -e 'MYSQL_ROOT_PASSWORD=workplace' -e 'MYSQL_USER=workplace' -e 'MYSQL_PASSWORD=workplace' -e 'MYSQL_DATABASE=workplace' -v ${absolutePath}:/docker-entrypoint-initdb.d  -d mysql:5.7 mysqld --sql-mode="IGNORE_SPACE" --lower_case_table_names=1 --character-set-server=utf8mb4 --max-allowed-packet=67108864
    Start-Sleep 10

    ## show version
    write-host( docker exec $DBContainerName mysql --version -h -1 -W -Q ) -foreground "YELLOW"

    docker logs -f $DBContainerName
}
finally
{
    Pop-Location
}

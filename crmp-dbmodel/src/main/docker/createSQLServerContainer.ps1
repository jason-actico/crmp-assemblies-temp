Param(
#Used for docker naming of images and containers
   [String]$DOCKER_NAME_PREFIX = "crmp-mssql",

#DB model root directory
   [String]$DB_MODEL_ROOT_DIR = "../../../",
   
#Target directory for the docker files (within the maven target directory)
   [String]$TARGET_DIR = "$DB_MODEL_ROOT_DIR/target/dbscripts"
)
##############################################################################
## Target Path to Created Files ##############################################
##############################################################################
$DBFilesTargetDir="$TARGET_DIR/workplace-files"
$FSFilesTargetDir="$TARGET_DIR/spr-files"
$DBContainerName="$DOCKER_NAME_PREFIX-db"
$DBScriptPaths = @()

##############################################################################
## Path to Workplace Initial DB Scripts ######################################
##############################################################################
$DBScriptPaths += "$DBFilesTargetDir/workplace-mssql-database-create.ddl"
$DBScriptPaths += "$FSFilesTargetDir/testsetup/mssql/workplace-mssql-database-collation.ddl"

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
	CopyForMssql $DBScriptPaths $tempdir
	
    ## initial scripts
    $InsertCmd = CreateInitialScriptString $DBScriptPaths "/dbscripts"
	echo "Initial CMD: " + $InsertCmd

    $absolutePath = (Resolve-Path "$tempdir").Path

    StopAndRemoveContainer $DBContainerName
    docker run --cap-add=SYS_PTRACE --name $DBContainerName -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=yourStrong(!)Password" -p 1433:1433 -v ${absolutePath}:/dbscripts  -d mcr.microsoft.com/mssql/server:2017-CU8-ubuntu

    Start-Sleep 10

    ## show version
    write-host( docker exec $DBContainerName /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "yourStrong(!)Password" -h -1 -W -Q "Select @@VERSION" ) -foreground "YELLOW"

    $arg2 = "exec $DBContainerName /opt/mssql-tools/bin/sqlcmd -b -m-1 -S localhost -U sa -P yourStrong(!)Password" -split " "
    [System.Collections.ArrayList]$arg = $arg2
    $arg += $InsertCmd -split " "

    $exe = "docker"
    echo "Executing Command:"
    echo "$exe $arg"

    $output = &$exe $arg
	if ($LastExitCode -ne 0)
	{
		write-host( "An error occured while executing the script: " ) -foreground "RED"
		StopAndRemoveContainer $DBContainerName
		echo $output
		return
	}

    write-host( "Isolation level of database 'workplace' is set to READ_COMMITED_SNAPHSHOT:" ) -foreground "YELLOW"
    write-host( docker exec $DBContainerName /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "yourStrong(!)Password" -h -1 -W -Q "SELECT CASE WHEN ((SELECT is_read_committed_snapshot_on FROM sys.databases  WHERE name= 'workplace')= 1) THEN 'true' ELSE 'false' end" ) -foreground "YELLOW"


    docker logs -f $DBContainerName
    
}
finally
{
    Pop-Location
}
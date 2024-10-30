function CreateInitialScriptString($array, $prefix)
{	
Write-Host "START CreateInitialScriptString"
   # for mssql
   $Result = ""
   for ($i=0; $i -lt $array.length; $i++)
   {	
      $fileName = $array[$i].split("/")[-1]
      # prefix by character for correct order
      $ascii = [int]$i + 10
      $fileName = $ascii.ToString() + "_" + $fileName
      # replace suffix with sql as required by our oracle docker image
      $fileName = $fileName.split(".")[0] + ".sql"
      $Result = "$Result -i ${prefix}/${fileName}"
   }
   
   return $Result
} 
function CopyForMssql($array, $tempdir)
{
     for ($i=0; $i -lt $array.length; $i++)
    {
        $fullQN =$array[$i]
        $fileName = $array[$i].split("/")[-1]
        # prefix by character for correct order
        $ascii = [int]$i + 10
        $fileName = $ascii.ToString() + "_" + $fileName
        # replace suffix with sql as required by our mssql docker image
        $fileName = $fileName.SubString(0, $fileName.LastIndexOf(".")) + ".sql"
        $Result = "$Result -i ${prefix}/${fileName}"
        Copy-Item "$fullQN" "${tempdir}/${fileName}"
   }
} 

function CopyForMysql($array, $tempdir)
{
   for ($i=0; $i -lt $array.length; $i++)
    {
        $fullQN =$array[$i]
        $fileName = $array[$i].split("/")[-1]
        # prefix by character for correct order
        $ascii = [int]$i + 65
        $fileName = [char]${ascii} + "_" + $fileName
        # replace suffix with sql as required by our mysql docker image
        $fileName = $fileName.split(".")[0] + ".sql"
        $Result = "$Result -i ${prefix}/${fileName}"
        Copy-Item "$fullQN" "${tempdir}/${fileName}"
   }
}

function CopyAndPrefixForOracle($array, $tempdir)
{
    # for oracle
    # https://stash.bfs-intra.net/projects/DEVOPDOCK/repos/database/browse/oracle/database/instance/12.1.0.2

    for ($i=0; $i -lt $array.length; $i++)
    {
        $fullQN =$array[$i]
        $fileName = $array[$i].split("/")[-1]
        # prefix by character for correct order
        $ascii = [int]$i + 10
        $fileName = $ascii.ToString() + "_" + $fileName
        # replace suffix with sql as required by our oracle docker image
        $fileName = $fileName.SubString(0, $fileName.LastIndexOf(".")) + ".sql"
        Copy-Item "$fullQN" "$tempdir/$fileName"
        $path = "$tempdir/$fileName"
        "CONNECT hr/hr;`r`n" + (Get-Content $path -Raw) | Set-Content $path
    }
    
}
function StopAndRemoveContainer($containerName)
{
    echo "Removing and stopping (if exists) container $containerName..."
    docker stop $containerName 2> $null
    docker rm -v $containerName 2> $null
    echo "done"
}

function CreateDirectoryOrRemoveContent($directory)
{
    If (Test-Path "$directory")
    {
       Remove-Item -Recurse -Force "$directory"
    }
    New-Item -ItemType Directory -Force -Path "$directory"
}
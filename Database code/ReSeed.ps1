# Define SQL connection variables
$SQLServer = 'ASG-DB-01'
$SQLInstance = 'MSSQLSERVER'
$SQLUser = 'sa'
$SQLPassword = 'MonkeyTonkeyLand?'
$BaseDirectory = 'G:\ShoppingAPI\ShoppingApp_ORM_Demo\Database code'


Set-Location $BaseDirectory
# Execute sqlcmd using Start-Process


# Function to execute SQL commands with error handling
function Invoke-SqlCommand {
    param(
        [string]$Server,
        [string]$ServerInstance,
        [string]$Database,
        [string]$Username,
        [string]$Password,
        [string]$InputFile,
        [string]$OutputFile
    )
    
    try {
# Prepare arguments for Start-Process
        $arguments = @(
            "-S", "$Server",
            "-d", $Database,
            "-U", $Username,
            "-P", $Password,
            "-i", "`"$InputFile`"",
            "-o", "`"$OutputFile`""
        )
        try{
            Start-Process "sqlcmd.exe" -ArgumentList $arguments -NoNewWindow -Wait -PassThru
        }
        catch{
            Write-Host "Error: $_"
        }
        
        if ($LASTEXITCODE -ne 0) {
            throw "SQL command execution failed with error level $LASTEXITCODE."
        }
    } catch {
        Write-Error "An error occurred: $_"
        Pause # Pause if there's an error
        exit
    }
}

# Function to run all SQL scripts in a folder (and its subfolders)
function Run-SqlScriptsInFolder {
    param(
        [string]$FolderPath,
        [string]$Database
    )

    $sqlFiles = Get-ChildItem -Path $FolderPath -Recurse -Filter *.sql
    foreach ($file in $sqlFiles) {
        $inputPath = $file.FullName
        $outputPath = $file.FullName.Replace(".sql", "Log.txt")
        Write-Host "Executing $inputPath..."
        Invoke-SqlCommand -Server $SQLServer -ServerInstance $SQLInstance -Database $Database -Username $SQLUser -Password $SQLPassword -InputFile $inputPath -OutputFile $outputPath
    }
}

# Directory paths to process
$directoriesToProcess = @(
#    "Remove", 
    "Build", 
    "Procedures\Create", 
    "Procedures\Read", 
    "Procedures\Update", 
    "Views", 
    "DataInsert")

foreach ($directory in $directoriesToProcess) {
    $fullPath = Join-Path -Path $BaseDirectory -ChildPath $directory
    if ($directory -eq "Remove" -or $directory -eq "Build" -or $directory -eq "Rebuild") {
        $db = "Master" # Assuming master database for these operations
    } else {
        $db = "Shoppinglist_app" # Change to your database name as needed
    }
    Run-SqlScriptsInFolder -FolderPath $fullPath -Database $db
}

Write-Host "All SQL scripts have been executed."
Function Scaffold-EntityModels {
    param(
        [string]$projectPath,       # = "C:/Path/To/Your/Project/"
        [string]$connectionString,  # = "Your connection string here"
        [string]$outputDir,         # = "Your choice for models, e.g., Models"
        [string]$provider,          # = "Entity Framework provider, e.g., Microsoft.EntityFrameworkCore.SqlServer"
        [string]$context,           # = "Your DbContext name here"
        [string]$contextDir         # = "Your choice for DbContext, e.g., Data"
    )

    # Step into the given project directory
    Set-Location $projectPath

    # Get the csproj file
    $csprojFile = Get-ChildItem -Path $projectPath -Filter *.csproj -Recurse | Select-Object -First 1
    Write-host "Scaffolding models and DbContext for the project located at: $projectPath"
    Write-host "Targetting the .csproj file located at: $($csprojFile.FullName)"
    # Scaffold the DbContext and the models
    dotnet ef dbcontext scaffold $connectionString $provider --output-dir $outputDir --context-dir "Data" --context $context -p $csprojFile.FullName -s $csprojFile.FullName
 
    Write-Host "Scaffolding complete. Models and DbContext moved to their respective directories." -ForegroundColor Green
}



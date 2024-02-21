Function Scaffold-API-MinimalCRUD {
    param(
        [string]$projectPath, # = "G:\ShoppingAPI\ShoppingApp_ORM_Demo\ShoppingAPI\ShoppingAPI_ORM_Demo"
        [string]$dbContextName # = "ShoppingListAppContext"
    )
    dotnet tool update -g dotnet-aspnet-codegenerator

    # Change to the project directory
    Push-Location -Path $projectPath

    # Get all model files from the Models directory
    $modelFiles = Get-ChildItem -Path "$projectPath\Models" -Filter *.cs

    foreach ($file in $modelFiles) {
        # Extract the model class name from the file name (assuming class name matches file name without the extension)
        $modelName = $file.BaseName

        # Mockup for an updated line as an example
        # $controllerName = $modelName + "Controller"

        # Ensuring to adhere to the information and assuming a minor miscommunication or oversight
        Write-Host "Executing command: dotnet aspnet-codegenerator controller -name ${modelName}Controller -async -api -m $modelName -dc $dbContextName -outDir Controllers"

        & dotnet aspnet-codegenerator controller -name "${modelName}Controller" -async -api -m $modelName -dc $dbContextName -outDir Controllers

        # The above command assumes that the controller name is a concatenation of model name and "Controller"
        # and that the necessary options/flags are used as expected by the tool.
    }
    dotnet build
    # Restore the previous directory
    Pop-Location
}

# Assuming necessary parameters are set correctly, this function can be invoked like this:
# Scaffold-API-MinimalCRUD -projectPath "Path_To_Your_Project" -dbContextName "YourDbContextName"

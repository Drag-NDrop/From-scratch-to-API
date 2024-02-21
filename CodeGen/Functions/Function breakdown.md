# Function breakdown

Short explanation of each function, what it does, and which parameters it takes

Please note, some files contains more than one function. But it is so, because they're make sense to keep bundled.
Essentially, the places where that happens, one can consider them sub-steps to a main responsibility.

## Bootstrap-Demo

The main entrypoint for the script to function.
Doesn't take any parameters.

# Create-NewProject.ps1

Contains the responsible functions to create a working boilerplate project:
* Install dotnet CLI tool
* Update dotnet CLI tool
* Create-NewProject
* Set CultureInvariant-flag to false, in the .csproj file

## Create-NewProject

### Main responsibility

* Create a project directory
* Create a new project from a .Net Core Web API template
* Create a solution(.sln) file for the project
* Disable Culture Invariance in the solutions .csproj file

### Parameters
    [string]$newProjectName,
    [string]$pathToYourProjectDirectory,
    [switch]$DisableCultureInvariance

### Example usage

```powershell
    Create-NewProject -newProjectName $newProjectName -pathToYourProjectDirectory $PathToYourNewProject -DisableCultureInvariance
```

## Set-CultureInvarianceInConfig

### Main responsibility
* Parse csproj
* Disable CultureInvarians
* Save the changes

### Parameters    
    [string]$projectDirectory
    [string]$projectName

### Example usage
```powershell
    Set-CultureInvarianceInConfig -projectDirectory $pathToYourProjectDirectory -projectName $newProjectName
```

# Update-ConnectionStringInAppSettings.ps1

## Update-ConnectionStringInAppSettings

### Main responsibility

* Load and parse appconfig.json
* Add a Connectionstring collection to the appconfig.json
* Add the defined connection string, with the defined key name
* Save the appconfig.json

### Parameters
        [string]$projectPath,      # Path to your project directory
        [string]$connectionString, # Your connection string
        [string]$connectionName    # The key/name for your connection string

### Example Usage

```powershell
    Update-ConnectionStringInAppSettings -projectPath $projectPath -connectionString $connectionString -connectionName $DbContextName 
```

# Boostrap-Dependencies.ps1

## Bootstrap-Dependencies

### Parameters
    [string]$csProjPath

### Main responsibility

* Adds the hardcoded dependencies in the script, to the project 
* List can be extended or shrunk easily, just add or remove the dependency definitions in the script

### Example usage

```powershell
    Bootstrap-Dependencies -csProjPath $pathToYourProjectFile
```

# Scaffold-EntityModels

## Main responsibility

* Create Entity models from the database(Using database-first reverse engineering)


### Parameters
        [string]$projectPath,       # = "C:/Path/To/Your/Project/"
        [string]$connectionString,  # = "Your connection string here"
        [string]$outputDir,         # = "Your choice for models, e.g., Models"
        [string]$provider,          # = "Entity Framework provider, e.g., Microsoft.EntityFrameworkCore.SqlServer"
        [string]$context,           # = "Your DbContext name here"
        [string]$contextDir         # = "Your choice for DbContext, e.g., Data"


## Example usage

Keep in mind that a space after the accent grave(" ` ") might mess up the parameters(which is why its commented as below)
```powershell
Scaffold-EntityModels -projectPath $projectPath `<#                           The path to your project #>
                      -connectionString $connectionString `<#                 The database connection string#>
                      -outputDir "Models" `<#                                 The folder, the Entity models should end up in #>
                      -provider "Microsoft.EntityFrameworkCore.SqlServer" `<# The intended database provider of Entity Framework, in the project #>
                      -context $DbContextName `<#                             The desired name of the generated database context file #>
                      -contextDir "Context"<#    
```

# Scaffold-MinimalCRUD

## Main responsibility
* Update the dotnet code generator
* Loop through the Entity models, 
* Generate a controller for each model


## Parameters
    [string]$projectPath, # = "G:\ShoppingAPI\ShoppingApp_ORM_Demo\ShoppingAPI\ShoppingAPI_ORM_Demo"
    [string]$dbContextName # = "ShoppingListAppContext" 


## Example usage

```powershell
    Scaffold-API-MinimalCRUD -projectPath $projectPath -dbContextName $DbContextName
```

# Update-ProgramFileForControllers

## Main responsibility
* Update program.cs with
  * A DbContext for the main method to use when connecting to the database
  * Add builder.Services.AddControllers();
  * Add app.MapControllers();

## Parameters
    [string]$projectPath,          # Path to the directory containing Program.cs
    [string]$dbContextName,        # The name of your DbContext class
    [string]$connectionStringName  # The key name of your connection string in appsettings.json



## Example usage

```powershell

```
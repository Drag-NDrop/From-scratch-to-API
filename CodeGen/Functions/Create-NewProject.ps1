Function Set-CultureInvarianceInConfig {
    param(
        [Parameter(Mandatory = $true)]
        [string]$projectDirectory,
        
        [Parameter(Mandatory = $true)]
        [string]$projectName
    )


    # Identify the .csproj file
    $csprojFile = Get-ChildItem -Recurse -Path $projectDirectory -Filter "*.csproj" | Select-Object -First 1

    if ($null -eq $csprojFile) {
        Write-Host "No .csproj file found in the specified project directory." -ForegroundColor Red
        exit
    }

    # Load the .csproj XML content
    [xml]$csprojContent = Get-Content -Path $csprojFile.FullName

    # Check if InvariantGlobalization is already defined
    $invariantGlobalizationNode = $csprojContent.Project.PropertyGroup | Where-Object { $_.InvariantGlobalization -ne $null }

    if ($null -ne $invariantGlobalizationNode) {
        # Update the existing InvariantGlobalization value
        $invariantGlobalizationNode.InvariantGlobalization = "false"
    } else {
        # Create a new PropertyGroup with InvariantGlobalization set to false
        $newPropertyGroup = $csprojContent.CreateElement("PropertyGroup")
        $invariantGlobalizationElement = $csprojContent.CreateElement("InvariantGlobalization")
        $invariantGlobalizationElement.InnerText = "false"
        $newPropertyGroup.AppendChild($invariantGlobalizationElement)
        $csprojContent.Project.AppendChild($newPropertyGroup)
    }

    # Save the modified .csproj content
    $csprojContent.Save($csprojFile.FullName)

    Write-Host "The .csproj file has been updated successfully." -ForegroundColor Green
    Write-host $PWD -ForegroundColor Green
    dotnet build
}

# Example of how to call this function:
# Set-CultureInvarianceInConfig -projectDirectory "G:\ORM_Demo" -projectName "ORM_Demo"


Function Create-NewProject {
    param(
        [Parameter(Mandatory = $true)]
        [string]$newProjectName,
        
        [Parameter(Mandatory = $true)]
        [string]$pathToYourProjectDirectory,
        
        [Parameter(Mandatory = $true)]
        [string]$frameWork,

        [switch]$DisableCultureInvariance
    )
    
    # Ensure EF Core CLI tools is installed
    dotnet tool install --global dotnet-ef
    dotnet tool update --global dotnet-ef
    
    # Create the project directory if it doesn't exist
    if (-not (Test-Path $pathToYourProjectDirectory)) {
        New-Item -ItemType Directory -Path $pathToYourProjectDirectory
    }

    # Set the location to the project directory
    Set-Location -Path $pathToYourProjectDirectory

    # Create a new .NET Core Web API project
    dotnet new webapi -n $newProjectName -o $newProjectName --framework $frameWork

    # Navigate into the project directory
    Set-Location -Path $newProjectName
    
    # Create a new solution file inside the project directory
    dotnet new sln -n $newProjectName

    # Get the path to the project file
    $pathToYourProjectFile = "$PWD\$newProjectName.csproj"

    # Add the project to the solution
    dotnet sln "$PWD\$newProjectName.sln" add $pathToYourProjectFile
    
    if ($DisableCultureInvariance -eq $true) {
        Set-CultureInvarianceInConfig -projectDirectory $pathToYourProjectDirectory -projectName $newProjectName
    }

    # Navigate back to the root project directory
    Set-Location -Path $pathToYourProjectDirectory
}

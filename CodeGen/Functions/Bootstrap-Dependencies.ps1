Function Bootstrap-Dependencies {
param(
# Define the path to the project file
    [Parameter(Mandatory = $true)]
    $csProjPath,
    # Define the list of dependencies to add to the project
    [Parameter(Mandatory = $true)]
    $dependencyArray
)
    write-host "Adding dependencies: $csProjPath"
    # Loop through each package and use dotnet CLI to add it to the project
    foreach ($package in $dependencyArray) {
        $packageName = $package.Name
        $packageVersion = $package.Version
        Write-Host "Installing $packageName version $packageVersion..."
        dotnet add $csProjPath package $packageName -v $packageVersion
    }

    Write-Host "All packages have been installed."
}
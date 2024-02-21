Function Bootstrap-Dependencies {
param(
# Define the path to the project file
    [Parameter(Mandatory = $true)]
    $csProjPath
)
    write-host "Adding dependencies: $csProjPath"
    # Define the list of packages to install with their respective versions
    $packages = @(
        @{ Name="Microsoft.EntityFrameworkCore"; Version="8.0.2" },
        @{ Name="Microsoft.EntityFrameworkCore.SqlServer"; Version="8.0.2" },
        @{ Name="Microsoft.EntityFrameworkCore.Tools"; Version="8.0.2" },
        @{ Name="Microsoft.VisualStudio.Web.CodeGeneration.Design"; Version="8.0.1" }
    )

    # Loop through each package and use dotnet CLI to add it to the project
    foreach ($package in $packages) {
        $packageName = $package.Name
        $packageVersion = $package.Version
        Write-Host "Installing $packageName version $packageVersion..."
        dotnet add $csProjPath package $packageName -v $packageVersion
    }

    Write-Host "All packages have been installed."
}
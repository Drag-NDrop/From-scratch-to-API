function ProcessJwtSettings {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]$JwtSettings,
        [Parameter(Mandatory = $true)]
        [string]$pathToProjectFile
    )

    # Process each item in the JwtSettings array
    foreach ($setting in $JwtSettings) {
        # Example processing based on TaskName
        switch ($setting.TaskName) {
            'SetupJWT-Install' {
                Write-Host "Installing $($setting.PackageInformation) version $($setting.Version)"
            }
            'SetupJWT-User' {
                Write-Host "Configuring user $($setting.JwtUsername) with password $($setting.JwtPassword)"
            }
            'SetupJWT-Choice' {
                Write-Host "Choice for $($setting.Name) is set to $($setting.Choice)"
            }
            'SetupJWT-Options' {
                Write-Host "JWT Key is $($setting.JwtKey) and Issuer is $($setting.Issuer)"
            }
            default {
                Write-Host "Unknown task: $($setting.TaskName)"
            }
        }
    }
}
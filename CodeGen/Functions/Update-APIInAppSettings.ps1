Function Update-APIInAppSettings {
    param(
        [Parameter(Mandatory = $true)]
        [string]$projectPath,      # Path to your project directory

        [Parameter(Mandatory = $true)]
        [string]$APIUser, # Your API User

        [Parameter(Mandatory = $true)]
        [string]$APIPassword    # Your API Password
    )
    
    # Define the file path for appsettings.json
    $appSettingsPath = Join-Path -Path $projectPath -ChildPath "appsettings.json"
    
    # Check if appsettings.json exists
    if (-Not (Test-Path $appSettingsPath)) {
        Write-Host "appsettings.json not found at path: $appSettingsPath" -ForegroundColor Red
        return
    }
    
    # Load the existing content of the file
    $appSettingsJson = Get-Content $appSettingsPath -Raw | ConvertFrom-Json

    # Update or create the "API" and the user and password entries
    if ($null -eq $appSettingsJson.API) {
        $appSettingsJson | Add-Member -MemberType NoteProperty -Name API -Value @{}
    }
    $appSettingsJson.API.User = $APIUser
    $appSettingsJson.API.Password = $APIPassword
    
    # Convert the modified JSON back to a string and save it to the file
    $appSettingsJson | ConvertTo-Json -Depth 10 | Set-Content $appSettingsPath
    
    Write-Host "API credentials updated successfully in appsettings.json" -ForegroundColor Green
}
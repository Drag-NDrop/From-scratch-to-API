Function Update-ConnectionStringInAppSettings {
    param(
        [Parameter(Mandatory = $true)]
        [string]$projectPath,      # Path to your project directory

        [Parameter(Mandatory = $true)]
        [string]$connectionString, # Your connection string

        [Parameter(Mandatory = $true)]
        [string]$connectionName    # The name/key for your connection string
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

    # Update or create the "ConnectionStrings" and the connection string entry
    if ($null -eq $appSettingsJson.ConnectionStrings) {
        $appSettingsJson | Add-Member -MemberType NoteProperty -Name ConnectionStrings -Value @{}
    }
    $appSettingsJson.ConnectionStrings.$connectionName = $connectionString
    
    # Convert the modified JSON back to a string and save it to the file
    $appSettingsJson | ConvertTo-Json -Depth 10 | Set-Content $appSettingsPath
    
    Write-Host "Connection string updated successfully in appsettings.json" -ForegroundColor Green
    
}
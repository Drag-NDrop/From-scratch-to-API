Function Update-JwtInAppSettings {
    param(
        [Parameter(Mandatory = $true)]
        [string]$projectPath,      # Path to your project directory

        [Parameter(Mandatory = $true)]
        [string]$Key, # Your JWT Key

        [Parameter(Mandatory = $true)]
        [string]$Issuer    # Your JWT Issuer
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

    # Update or create the "Jwt" and the key and issuer entries
    if ($null -eq $appSettingsJson.Jwt) {
        $appSettingsJson | Add-Member -MemberType NoteProperty -Name Jwt -Value @{}
    }
    $appSettingsJson.Jwt.Key = $Key
    $appSettingsJson.Jwt.Issuer = $Issuer
    
    # Convert the modified JSON back to a string and save it to the file
    $appSettingsJson | ConvertTo-Json -Depth 10 | Set-Content $appSettingsPath
    
    Write-Host "Jwt updated successfully in appsettings.json" -ForegroundColor Green
    
}
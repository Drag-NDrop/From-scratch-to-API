Function Protect-Endpoints{
Param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [Array]$TaskObjects,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$ProjectPath
)



<#
Skal se om jeg kan få EndpointArray switchen til at fungere igen.
Når den fungerer, skal denne tilføjes i toppen af controlleren, hver gang en controllers tilføjes
en annotation:
using Microsoft.AspNetCore.Authorization;

$TaskObjects = @(
    @{ TaskName='SetupJWT-Choice'; Name='Protect-Get'; Choice='yes' },
    @{ TaskName='SetupJWT-Choice'; Name='Protect-GetById'; Choice='yes' },
    @{ TaskName='SetupJWT-Choice'; Name='Protect-Post'; Choice='yes' },
    @{ TaskName='SetupJWT-Choice'; Name='Protect-PutById'; Choice='yes' },
    @{ TaskName='SetupJWT-Choice'; Name='Protect-DeleteById'; Choice='yes' }
)
#>

$EndpointArray = New-Object System.Collections.ArrayList
foreach($task in $TaskObjects){
    if($task.Choice -eq 'yes'){
        switch ($task.Name) {
            'Protect-Get'{  
                $EndpointArray.Add('[HttpGet]')
                break;
            }
            'Protect-GetById'{
                $EndpointArray.Add('[HttpGet("{id}")]')
                break;
              }
            'Protect-Post'{
                $EndpointArray.Add('[HttpPost]')
                break;
              }
            'Protect-PutById'{
                $EndpointArray.Add('[HttpPut("{id}")]')
                break;
              }
            'Protect-DeleteById'{
                $EndpointArray.Add('[HttpDelete("{id}")]')
                break;
              }
            condition {  }
            Default {}
        }
    }
}
Write-host "Protecting the following endpoints:"
Write-host $EndpointArray  

#$EndpointArray = @('[HttpGet]', '[HttpGet("{id}")]', '[HttpPut("{id}")]', '[HttpPost]', '[HttpDelete("{id}")]')
     
$controllerPath = "$ProjectPath/Controllers"
$Controllers = Get-ChildItem -LiteralPath $controllerPath | Where-Object { $_.Name -ne "JwtLoginController.cs" } # Filter out the login-endpoint. We don't want to protect that one.

# Loop through the content of each controller, and protect the defined endpoints.
foreach ($controller in $Controllers) {
    $programContent = Get-Content $controller.FullName
    $modifiedContent = @()
    $modifiedContent += 'using Microsoft.AspNetCore.Authorization;' # Add the "using" statement we need to use the Authorize annotation
    foreach ($line in $programContent) {
        $modifiedLine = $line
        foreach ($endpoint in $EndpointArray) {
            # Define the target line to search for
            $targetLine = $endpoint
            # Insert the [Authorize] attribute after the target line in the current controller
            if ($line -match [regex]::Escape($targetLine)) {
                $modifiedLine = "`t`t" +'[Authorize]' + "`r`n" + $line
                Write-Host "Authorize annotation added to $($controller.Name)." -ForegroundColor Green
            }
        }
        $modifiedContent += $modifiedLine
    }
    # Save the updated content back to the controller file
    $modifiedContent | Set-Content $controller.FullName
}
}

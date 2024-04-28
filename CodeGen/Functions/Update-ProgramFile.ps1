Function Update-ProgramFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$projectPath,  # Path to the directory containing Program.cs
        [Parameter(Mandatory=$true)]
        [string]$projectName,  # The name of your project
        [Parameter(Mandatory=$true)]
        [string]$dbContextName,  # The name of your DbContext class
        [Parameter(Mandatory=$true)]
        [string]$connectionStringName,  # The key name of your connection string in appsettings.json
        [Parameter(Mandatory=$true)]
        [string]$providerTarget,  # The provider target for the connection string (e.g. Microsoft.EntityFrameworkCore.SqlServer)
        [Parameter(Mandatory=$false)]
        [bool]$InstallJWT = $false  # A flag to indicate if JWT support should be installed
    )

    $programFilePath = Join-Path -Path $projectPath -ChildPath "Program.cs"

    # Check if Program.cs exists
    if (-Not (Test-Path $programFilePath)) {
        Write-Host "Program.cs not found at path: $programFilePath" -ForegroundColor Red
        return
    }

    # Read Program.cs content
    $programContent = Get-Content $programFilePath -Raw

    # Define the code snippets to insert
    $addControllersSnippet = "builder.Services.AddControllers();"
    $mapControllersSnippet = "app.MapControllers();"
    $jwtConfigSnippet = @'
    //Jwt configuration starts here
    var jwtIssuer = builder.Configuration.GetSection("Jwt:Issuer").Get<string>();
    var jwtKey = builder.Configuration.GetSection("Jwt:Key").Get<string>();
    
    builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
     .AddJwtBearer(options =>
     {
         options.TokenValidationParameters = new TokenValidationParameters
         {
             ValidateIssuer = true,
             ValidateAudience = true,
             ValidateLifetime = true,
             ValidateIssuerSigningKey = true,
             ValidIssuer = jwtIssuer,
             ValidAudience = jwtIssuer,
             IssuerSigningKey = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(jwtKey))
         };
     });
    //Jwt configuration ends here
'@
$swaggerAuthSupportSnippet = @'
// Swagger Authorization support configuration starts here
builder.Services.AddSwaggerGen(option =>
{
    option.SwaggerDoc("v1", new OpenApiInfo { Title = "Demo API", Version = "v1" });
    option.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Please enter a valid token",
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        BearerFormat = "JWT",
        Scheme = "Bearer"
    });
    option.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type=ReferenceType.SecurityScheme,
                    Id="Bearer"
                }
            },
            new string[]{}
        }
    });
});
// Swagger Authorization support configuration ends here
'@

# Define the target lines to search for
    $createBuilderLine = 'var builder = WebApplication.CreateBuilder(args);'
    $swaggerGenTargetLine = 'builder.Services.AddSwaggerGen();'
    $appRunTargetLine = 'app.Run();'
    $jwtConfigTargetLine = 'var builder = WebApplication.CreateBuilder(args);'
    $swaggerAuthSupportTargetLine = 'builder.Services.AddSwaggerGen();'    

    # Add usings on the top line
    $usings = @"
using Microsoft.EntityFrameworkCore;
using $providerTarget;
using $projectName.Data;
"@
    
if($InstallJWT -eq $true){
    $usings += @'

using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.OpenApi.Models;    

'@
}
    # Insert 'builder.Services.AddControllers();' after 'builder.Services.AddSwaggerGen();'
    if ($programContent -match [regex]::Escape($swaggerGenTargetLine)) {
        $programContent = $programContent -replace ([regex]::Escape($swaggerGenTargetLine)), ($swaggerGenTargetLine + "`r`n" + $addControllersSnippet)
    } else {
        Write-Host "Target line for adding controllers not found." -ForegroundColor Yellow
    }

    # Insert 'app.MapControllers();' before 'app.Run();'
    if ($programContent -match [regex]::Escape($appRunTargetLine)) {
        $programContent = $programContent -replace ([regex]::Escape($appRunTargetLine)), ($mapControllersSnippet + "`r`n" + $appRunTargetLine)
    } else {
        Write-Host "Target line for mapping controllers not found." -ForegroundColor Yellow
    }

    if($InstallJWT -eq $true){
        # Insert JwtConfigSnippet after 'var builder = WebApplication.CreateBuilder(args);'
        if ($programContent -match [regex]::Escape($jwtConfigTargetLine)) {
            $programContent = $programContent -replace ([regex]::Escape($jwtConfigTargetLine)), ($jwtConfigTargetLine + "`r`n" + $jwtConfigSnippet)
        } else {
            Write-Host "Target line for adding JWT Config not found." -ForegroundColor Yellow
        }
        # Insert SwaggerAuthSupportSnippet after 'builder.Services.AddSwaggerGen();'
        if ($programContent -match [regex]::Escape($swaggerAuthSupportTargetLine)) {
            $programContent = $programContent -replace ([regex]::Escape($swaggerAuthSupportTargetLine)), ($swaggerAuthSupportTargetLine + "`r`n" + $swaggerAuthSupportSnippet)
        } else {
            Write-Host "Target line for adding controllers not found." -ForegroundColor Yellow
        }
    }
    # Save the updated content back to Program.cs
    # Add usings to, on the top line
    $programContent = $usings + $programContent
    $programContent | Set-Content $programFilePath

    # Lazy extension of the function to add the DbContext registration
    # This is just a proof of concept, after all....

    $dbContextSnippet = "" #Ensure the variable exists outside of the switch scope
    # Prepare the DbContext registration snippet
    switch ($providerTarget) {
        "Microsoft.EntityFrameworkCore.SqlServer" { 
            $dbContextSnippet = @"
builder.Services.AddDbContext<$dbContextName>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("$connectionStringName"))
    .LogTo(Console.WriteLine, LogLevel.Information)
    .EnableSensitiveDataLogging()
    .EnableDetailedErrors()
    );
"@
         }
        "Pomelo.EntityFrameworkCore.MySql" {
            $dbContextSnippet = @"
var serverVersion = new MySqlServerVersion(new Version(8, 0, 36));
builder.Services.AddDbContext<$dbContextName>(options =>
    options.UseMySql(builder.Configuration.GetConnectionString("$connectionStringName"),serverVersion)
    .LogTo(Console.WriteLine, LogLevel.Information)
    .EnableSensitiveDataLogging()
    .EnableDetailedErrors()
);
"@
          }
        "MySql.Data.EntityFrameworkCore" {
            $dbContextSnippet = @"
            var serverVersion = new MySqlServerVersion(new Version(8, 0, 36));
builder.Services.AddDbContext<$dbContextName>(options =>
options.UseMySql(builder.Configuration.GetConnectionString("$connectionStringName"),serverVersion)
    .LogTo(Console.WriteLine, LogLevel.Information)
    .EnableSensitiveDataLogging()
    .EnableDetailedErrors()
    );
"@
          }

        Default {}
    }
<#    $dbContextSnippet = @"
builder.Services.AddDbContext<$dbContextName>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("$connectionStringName")));
"@
#>
 # Read Program.cs content
 $programContent = Get-Content $programFilePath -Raw

 # Define the target line to search for
 $targetLine = "builder.Services.AddControllers();"

 # Insert the DbContext registration snippet after the target line
 if ($programContent -match [regex]::Escape($targetLine)) {
     $programContent = $programContent -replace ([regex]::Escape($targetLine)), ($targetLine + "`r`n" + $dbContextSnippet)
     # Save the updated content back to Program.cs
     $programContent | Set-Content $programFilePath

     Write-Host "DbContext registration has been added to Program.cs successfully." -ForegroundColor Green
 } else {
     Write-Host "Target line for adding DbContext registration not found." -ForegroundColor Yellow
 }

    # Save the updated content back to Program.cs
    $programContent | Set-Content $programFilePath

    Write-Host "Program.cs has been updated successfully." -ForegroundColor Green
}

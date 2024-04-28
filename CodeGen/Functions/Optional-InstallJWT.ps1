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
# Done
$AddThisToAppSettingsFile = @" 
"Jwt": {
    "Key": "$($JwtSettings[0].JwtKey)",
    "Issuer": "$($JwtSettings[0].Issuer)"
}
"@ 


# Done

$AddThisToProgramFileForSwaggerAuthSupport = @"
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
"@

$AddThisToProgramFile = @"
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
         IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
     };
 });
//Jwt configuration ends here
"@


$JwtLoginController = @'
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Configuration;
using System.IdentityModel.Tokens.Jwt;
using System.Text;

namespace JwtInDotnetCore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private IConfiguration _config;
        public LoginController(IConfiguration config)
        {
            _config = config;
        }

        [HttpPost]
        public IActionResult Post([FromBody] LoginRequest loginRequest)
        {
            //Logic for login process. Create your own to match your project.
            //If login username and password are correct then proceed to generate token

            if (

                loginRequest.Email == _config.GetSection("API:User").Get<string>()
                &&
                loginRequest.Password == _config.GetSection("API:Password").Get<string>()
                )
            {
                var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]));
                var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

                var Sectoken = new JwtSecurityToken(_config["Jwt:Issuer"],
                  _config["Jwt:Issuer"],
                  null,
                  expires: DateTime.Now.AddMinutes(120),
                  signingCredentials: credentials);

                var token = new JwtSecurityTokenHandler().WriteToken(Sectoken);

                return Ok(token);
            }
            else
            {
                return BadRequest("Invalid e-mail or password");
            }
        }
    }
}
'@


# Add the dependencies if InstallJWT is set to true
# Process the JwtSettings array
# Add the credentials to the JwtSettings array in appsettings.json
# Add the JWT middleware to the pipeline
# Add the JWT authentication to the controllers

Function Create-JwtLoginController {
param(
    [Parameter(Mandatory = $true)]
    [string]$ControllerFolderPath  # Path to the directory containing the projects Controllers
)

# Define the path to the JwtLoginController.cs file
$JwtLoginControllerPath = Join-Path -Path $ControllerFolderPath -ChildPath "JwtLoginController.cs"

# Check if JwtLoginController.cs exists
if (Test-Path $JwtLoginControllerPath) {
    Write-Host "JwtLoginController.cs already exists at path: $JwtLoginControllerPath" -ForegroundColor Red
    return
}
else {
    Write-Host "Creating JwtLoginController.cs at path: $JwtLoginControllerPath" -ForegroundColor Green
    New-Item -ItemType File -Path $JwtLoginControllerPath
}

# Define the content of the JwtLoginController.cs file
$JwtLoginControllerContent = @'
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

# Write the content to the JwtLoginController.cs file
$JwtLoginControllerContent | Set-Content -Path $JwtLoginControllerPath


}
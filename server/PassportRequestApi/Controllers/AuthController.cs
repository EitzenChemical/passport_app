using Microsoft.AspNetCore.Mvc;

namespace PassportRequestApi.Controllers;

[Route("[controller]")]
[ApiController]
public class AuthController(DatabaseService databaseService) : ControllerBase
{
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest loginRequest)
    {
        var user = await databaseService.AuthenticateUserAsync(loginRequest.Email, loginRequest.Password);
        if (user != null)
        {
            return Ok(new { userId = user.Id, message = "Login successful" });
        }
        return Unauthorized("Invalid credentials");
    }
}

public class LoginRequest
{
    public string Email { get; set; } = null!;
    public string Password { get; set; } = null!;
}
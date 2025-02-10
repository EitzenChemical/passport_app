using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

[ApiExplorerSettings(IgnoreApi = true)]
[ApiController]
[Route("[controller]")]
public class PassportController : ControllerBase
{
    private readonly PassportServiceDbContext _context;

    public PassportController(PassportServiceDbContext context)
    {
        _context = context;
    }

    // Получить все заявки пользователя
    [HttpGet("user/{userId}")]
    public IActionResult GetUserApplications(int userId)
    {
        var applications = _context.Applications.Where(a => a.UserId == userId).ToList();
        return Ok(applications);
    }

    // Создать новую заявку
    [HttpPost]
    public IActionResult CreateApplication([FromBody] Application application)
    {
        application.DateSubmitted = DateTime.Now;
        application.Status = "На рассмотрении";
        _context.Applications.Add(application);
        _context.SaveChanges();
        return CreatedAtAction(nameof(GetUserApplications), new { userId = application.UserId }, application);
    }

    // Метод для логина пользователя
    [HttpPost("login")]
    public IActionResult Login([FromBody] User loginData)
    {
        var user = _context.Users.FirstOrDefault(u => u.FullName == loginData.FullName);
        if (user == null || user.PasswordHash != loginData.PasswordHash)
        {
            return Unauthorized("Неверное имя пользователя или пароль.");
        }
        return Ok(user.UserId);
    }

    private string HashPassword(string password)
    {
        using (var sha256 = SHA256.Create())
        {
            var bytes = Encoding.UTF8.GetBytes(password);
            var hash = sha256.ComputeHash(bytes);
            return Convert.ToBase64String(hash);
        }
    }
}

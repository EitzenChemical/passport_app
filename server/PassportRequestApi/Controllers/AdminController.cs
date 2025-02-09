using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Swashbuckle.AspNetCore.Annotations;
using System.Security.Cryptography;
using System.Text;

namespace PassportRequestApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AdminController : Controller
    {
        private readonly PassportServiceDbContext _context;

        public AdminController(PassportServiceDbContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Обновить статус заявки
        /// </summary>
        /// <param name="applicationId">Идентификатор заявки</param>
        [HttpPut("{applicationId}")]
        public IActionResult UpdateApplicationStatus(int applicationId, [FromBody] ApplicationStatusUpdate statusUpdate)
        {
            var application = _context.Applications.FirstOrDefault(a => a.ApplicationId == applicationId);
            if (application == null) return NotFound();

            application.Status = statusUpdate.Status;

            if (statusUpdate.Status == "Одобрена")
            {
                var user = _context.Users.FirstOrDefault(x => x.UserId == application.UserId);

                if (user != null)
                {
                    user.PassportNumber = statusUpdate.NewPassportNumber;
                    user.PassportSeries = statusUpdate.NewPassportSeries;
                }
            }

            _context.SaveChanges();
            return NoContent();
        }

        /// <summary>
        /// Метод для регистрации нового пользователя
        /// </summary>
        [HttpPost("register")]
        public IActionResult Register([FromBody] User user)
        {
            if (_context.Users.Any(u => u.FullName == user.FullName && u.DateOfBirth == user.DateOfBirth))
            {
                return BadRequest("Пользователь уже существует.");
            }

            user.PasswordHash = HashPassword(user.PasswordHash);
            _context.Users.Add(user);
            _context.SaveChanges();
            return Ok("Регистрация успешна.");
        }

        /// <summary>
        /// Импорт пользователей из строки CSV
        /// </summary>
        /// <remarks>
        /// Пример CSV данных:
        /// Иванов Иван Иванович,1990-05-14,pass1234,1234,567890
        /// </remarks>
        /// <param name="csvDataStrings"></param>
        /// <returns>Статус импорта пользователей</returns>
        [HttpPost("import-users")]
        [SwaggerResponse(200, "Пользователи успешно импортированы")]
        [SwaggerResponse(400, "Неверный формат данных CSV")]
        public IActionResult ImportUsersFromCsv([FromBody] List<string> csvDataStrings)
        {
            if (csvDataStrings.Count == 0 || csvDataStrings == null)
            {
                return BadRequest("CSV список не может быть пустым.");
            }

            foreach (var line in csvDataStrings)
            {
                var parts = line.Split(",");
                if (parts.Length < 5) continue;

                // Парсим и создаем нового пользователя
                var user = new User
                {
                    FullName = parts[0].Trim(),
                    DateOfBirth = DateTime.TryParse(parts[1].Trim(), out DateTime dob) ? dob : throw new ArgumentNullException("Неверный формат данных DateOfBirth"),
                    PasswordHash = HashPassword(parts[2].Trim()),
                    PassportSeries = int.TryParse(parts[3].Trim(), out int series) ? series : (int?)null,
                    PassportNumber = int.TryParse(parts[4].Trim(), out int number) ? number : (int?)null
                };

                // Проверка на дубликаты пользователей с таким же ФИО и датой рождения
                if (!_context.Users.Any(u => u.FullName == user.FullName && u.PassportSeries == user.PassportSeries && u.PassportNumber == user.PassportNumber))
                {
                    _context.Users.Add(user);
                }
            }

            _context.SaveChanges();
            return Ok("Пользователи успешно импортированы.");
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
}

public class ApplicationStatusUpdate
{
    /// <summary>
    /// Новый статус заявки - 'На рассмотрении', 'Одобрена', 'Отклонена'
    /// </summary>
    public string Status { get; set; }

    public int? NewPassportSeries { get; set; }

    public int? NewPassportNumber { get; set; }
}

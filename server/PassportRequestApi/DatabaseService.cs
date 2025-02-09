using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Text.Json.Serialization;

public class PassportServiceDbContext : DbContext
{
    public DbSet<User> Users { get; set; }
    public DbSet<Application> Applications { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        //optionsBuilder.UseSqlServer("Server=mssqldb,1433;Database=PassportRequestDB;User Id=sa;Password=Faridun1488!;TrustServerCertificate=True;");
        optionsBuilder.UseSqlServer("Server=62.60.234.81,1433;Database=PassportRequestDB;User Id=sa;Password=Faridun1488!;TrustServerCertificate=True;");
    }
}

public class User
{
    [JsonIgnore]
    public int? UserId { get; set; }
    public string? FullName { get; set; }
    public DateTime? DateOfBirth { get; set; }
    public int? PassportSeries { get; set; }
    public int? PassportNumber { get; set; }
    public string? PasswordHash { get; set; }
}

public class Application
{
    public int? ApplicationId { get; set; }
    public int? UserId { get; set; }
    public DateTime? DateSubmitted { get; set; }
    public string? Reason { get; set; }
    public string? Status { get; set; }
    public byte[]? DocumentPhoto { get; set; } = [];
}
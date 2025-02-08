namespace PassportRequestApi;

public class User
{
    public int Id { get; set; }
    public string Email { get; set; } = null!;
    public string Password { get; set; } = null!;
}

public class Request
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public string Type { get; set; } = null!;
    public string Status { get; set; } = null!;
    public string Documents { get; set; } = null!;
}

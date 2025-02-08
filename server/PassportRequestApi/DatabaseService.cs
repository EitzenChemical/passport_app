using Microsoft.Data.SqlClient;

namespace PassportRequestApi;

public class DatabaseService(string? connectionString)
{
    private SqlConnection GetConnection()
    {
        if (connectionString == null) throw new NullReferenceException("Connection string is null");
        
        return new SqlConnection(connectionString);
    }

    public async Task<User?> AuthenticateUserAsync(string email, string password)
    {
        await using var connection = GetConnection();
        await connection.OpenAsync();
        var command = new SqlCommand("SELECT Id, Email, Password FROM Users WHERE Email = @Email AND Password = @Password", connection);
        command.Parameters.AddWithValue("@Email", email);
        command.Parameters.AddWithValue("@Password", password);

        var reader = await command.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new User
            {
                Id = reader.GetInt32(0),
                Email = reader.GetString(1),
                Password = reader.GetString(2)
            };
        }
        return null;
    }

    public async Task<List<Request>> GetUserRequestsAsync(int userId)
    {
        await using var connection = GetConnection();
        await connection.OpenAsync();
        var command = new SqlCommand("SELECT Id, Type, Status, Documents FROM Requests WHERE UserId = @UserId", connection);
        command.Parameters.AddWithValue("@UserId", userId);

        var reader = await command.ExecuteReaderAsync();
        var requests = new List<Request>();

        while (await reader.ReadAsync())
        {
            requests.Add(new Request
            {
                Id = reader.GetInt32(0),
                Type = reader.GetString(1),
                Status = reader.GetString(2),
                Documents = reader.GetString(3)
            });
        }
        return requests;
    }

    public async Task<bool> SubmitRequestAsync(Request request)
    {
        await using var connection = GetConnection();
        await connection.OpenAsync();
        var command = new SqlCommand("INSERT INTO Requests (UserId, Type, Status, Documents) VALUES (@UserId, @Type, @Status, @Documents)", connection);
        command.Parameters.AddWithValue("@UserId", request.UserId);
        command.Parameters.AddWithValue("@Type", request.Type);
        command.Parameters.AddWithValue("@Status", request.Status);
        command.Parameters.AddWithValue("@Documents", request.Documents);

        var result = await command.ExecuteNonQueryAsync();
        return result > 0;
    }
}
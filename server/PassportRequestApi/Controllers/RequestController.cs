using Microsoft.AspNetCore.Mvc;

namespace PassportRequestApi.Controllers;

[Route("[controller]")]
[ApiController]
public class RequestController(DatabaseService databaseService) : ControllerBase
{
    [HttpGet("user/{userId:int}")]
    public async Task<ActionResult<List<Request>>> GetRequests(int userId)
    {
        var requests = await databaseService.GetUserRequestsAsync(userId);
        return Ok(requests);
    }

    [HttpPost("submit")]
    public async Task<IActionResult> SubmitRequest([FromBody] Request request)
    {
        var success = await databaseService.SubmitRequestAsync(request);
        if (success)
        {
            return Ok(new { message = "Request submitted successfully" });
        }
        return BadRequest("Failed to submit request");
    }
}
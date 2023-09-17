using Microsoft.AspNetCore.Mvc;

namespace GraphQLHeros.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class APIController : ControllerBase
    {
        [HttpGet]
        [Route("[Action]")]
        public ActionResult Index()
        {
            return Ok(new { Name = "Orkun", Sirname = "Demirci" });
        }
    }
}

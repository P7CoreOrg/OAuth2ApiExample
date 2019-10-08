using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace SecuredApiApp22.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SimpleController : ControllerBase
    {
        // GET: api/Simple
        [HttpGet]
        [Route("protected")]
        [Authorize]
        public IEnumerable<string> GetProtected()
        {
            return new string[] { "Protected", "Data" };
        }
        [HttpGet]
        [Route("unprotected")]
        public IEnumerable<string> GetUnprotected()
        {
            return new string[] { "Unprotected", "Data" };
        }


    }
}

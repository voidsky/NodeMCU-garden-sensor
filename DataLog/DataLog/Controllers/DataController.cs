using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DataLog.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace DataLog.Controllers
{
    [Produces("application/json")]
    [Route("api/Data")]
    public class DataController : Controller
    {
        private readonly DataContext _context;

        public DataController(DataContext context)
        {
            _context = context;

            if (_context.DataItems.Count() == 0)
            {
                _context.DataItems.Add(new DataItem { DataName="DummuData", DataValue="666"});
                _context.SaveChanges();
            }
        }

        // GET: api/Data
        [HttpGet]
        public IEnumerable<DataItem> GetAll()
        {
            return _context.DataItems.ToList();
        }

        // GET: api/Data/5
        [HttpGet("{id}", Name = "Get")]
        public IActionResult Get(int id)
        {
            return new ObjectResult(_context.DataItems.FirstOrDefault(t=>t.Id == id));
        }
        
        // POST: api/Data
        [HttpPost]
        public IActionResult Post([FromBody]DataItem item)
        {
            if (item == null)
            {
                return BadRequest();
            }

            _context.DataItems.Add(item);
            _context.SaveChanges();

            return CreatedAtRoute("Get", new { id = item.Id }, item);
        }

    }
}

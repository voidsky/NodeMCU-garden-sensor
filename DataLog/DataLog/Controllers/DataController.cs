using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ApplicationCore.Entities;
using ApplicationCore.Interfaces;
using DataLog.ApiModels;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace DataLog.Controllers
{
    [Produces("application/json")]
    [Route("api/Data")]
    public class DataController : Controller
    {
        private readonly IRepository<DataItem> _dataRepository;

        public DataController(IRepository<DataItem> dataRep)
        {
            _dataRepository = dataRep;
        }

        // GET: api/Data
        [HttpGet]
        public IEnumerable<DataItem> GetAll()
        {
            return _dataRepository.ListAll();
        }

        // GET: api/Data/5
        [HttpGet("{id}", Name = "Get")]
        public IActionResult Get(int id)
        {
            return new ObjectResult(_dataRepository.GetById(id));
        }
        
        // POST: api/Data
        [HttpPost]
        public IActionResult Post([FromBody]DeviceData[] items)
        {
            if (items == null)
            {
                return BadRequest();
            }

            foreach (DeviceData item in items)
            {
                DataItem dataItem = new DataItem { DataName = item.DataName, DataValue = item.DataValue, ReceivedDate = DateTime.Now };
                _dataRepository.Add(dataItem);
            }

            return Ok();
        }

    }
}

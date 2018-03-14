using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ApplicationCore.Entities
{
    public class DataItem : BaseEntity
    {
        public string DataName { get; set; }
        public string DataValue { get; set; }
        public DateTime ReceivedDate { get; set; }
    }
}

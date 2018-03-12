using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DataLog.Models
{
    public class DataItem
    {
        public long Id { get; set; }
        public string DataName { get; set; }
        public string DataValue { get; set; }
        public DateTime ReceivedDate { get; set; }
    }
}

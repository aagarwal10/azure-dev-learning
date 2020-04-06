using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using Microsoft.WindowsAzure.Storage.Table;
using System;
using System.Threading.Tasks;

namespace ServerlessFuncs
{
    public static class ScheduledFunction
    {
        [FunctionName("ScheduledFunction")]
        public static async Task RunAsync([TimerTrigger("0 */5 * * * *")]TimerInfo myTimer,
                               [Table("todos", Connection = "AzureWebJobsStorage")] CloudTable todoTable, 
                               ILogger log)
        {
            log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");

            var query = new TableQuery<TodoTableEntity>();
            var segment = await todoTable.ExecuteQuerySegmentedAsync(query, null);
            var deleted = 0;
            foreach (var todo in segment)
            {
                if (todo.IsCompleted)
                {
                    await todoTable.ExecuteAsync(TableOperation.Delete(todo));
                    deleted++;
                }
            }

            log.LogInformation($"Deleted {deleted} items at {DateTime.Now}");
        }
    }
}

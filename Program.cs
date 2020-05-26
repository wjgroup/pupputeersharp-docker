using PuppeteerSharp;
using System;
using System.Threading.Tasks;

namespace PupputeerSharpDocker
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var options = new LaunchOptions { Headless = true, Args = new string[] { "--no-sandbox" }, ExecutablePath = @"" };
            using var browser = await Puppeteer.LaunchAsync(options);
            using var page = await browser.NewPageAsync();
            var response = await page.GoToAsync("https://www.google.com");
            var bytes = await response.BufferAsync();
            var content = System.Text.Encoding.UTF8.GetString(bytes);

            Console.WriteLine(content);
        }
    }
}

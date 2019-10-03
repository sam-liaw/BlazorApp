using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace BlazorApp
{
    public class Program
    {
        public static IConfigurationRoot _hosting;// Ū�� hosting.json �̫��w�� Port ���]�w����

        public static void Main(string[] args)
        {
            string hostingJson_ = $"hosting.json";

            string basePath_ = AppDomain.CurrentDomain.BaseDirectory;
            Console.WriteLine($"\nBasePath: {basePath_} \n", ConsoleColor.Green);

            // Ū�� hosting.json �̪� Port �]�w
            var builder_ = new ConfigurationBuilder()
            .SetBasePath(basePath_)
            .AddJsonFile(hostingJson_, optional: true);

            _hosting = builder_.Build();

            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseConfiguration(_hosting);// Ū�� hosting.json �̭��]�w�� Port
                    webBuilder.UseStartup<Startup>();
                });
    }
}

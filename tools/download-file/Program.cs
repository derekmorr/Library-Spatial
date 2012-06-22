// Copyright 2012 Green Code LLC
// All rights reserved.
//
// The copyright holders license this file under the New (3-clause) BSD
// License (the "License").  You may not use this file except in
// compliance with the License.  A copy of the License is available at
//
//   http://www.opensource.org/licenses/BSD-3-Clause
//
// and is included in the NOTICE.txt file distributed with this work.
//
// Contributors:
//   James Domingo, Green Code LLC

using System;
using System.ComponentModel;
using System.Net;
using System.Reflection;
using System.Threading;

namespace Landis.Tools.DownloadFile
{
    public static class Program
    {
        private const string helpOption = "-h";

        // Has the download completed (done, cancelled, or error occurred)?
        private static bool downloadComplete = false;

        // The percentage of the download so far completed that's displayed
        // on the system console.
        private static int displayedPercentage = 0;

        // The percentage change in the download that is represented by a
        // single character in the progress bar (e.g., 2 = a character in
        // the progress bar represents 2%).
        private static int displayIncrement = 2;

        //---------------------------------------------------------------------

        public static int Main(string[] args)
        {
            if (args.Length == 1 && args[0] == helpOption)
            {
                DisplayHelp();
                return 0;
            }
            else if (args.Length < 2)
                return UsageError("missing arguments");
            else if (args.Length > 2)
                return UsageError("too many arguments");
            string uri = args[0];
            string fileName = args[1];

            try {
                DownloadFileAsync(uri, fileName);
                return 0;
            }
            catch (Exception exc) {
                Console.WriteLine("Error: {0}", exc);
                return 1;
            }
        }

        //---------------------------------------------------------------------

        private static void DisplayHelp()
        {
            Assembly entryAssembly = Assembly.GetEntryAssembly();
            AssemblyProductAttribute productAttr = GetAttribute<AssemblyProductAttribute>(entryAssembly);
            string productName = productAttr.Product;
            Version version = entryAssembly.GetName().Version;
            Console.WriteLine("{0}, version {1}", productName, version);

            AssemblyCopyrightAttribute copyrightAttr = GetAttribute<AssemblyCopyrightAttribute>(entryAssembly);
            Console.WriteLine(copyrightAttr.Copyright);
            Console.WriteLine("License: http://www.opensource.org/licenses/BSD-3-Clause");
            Console.WriteLine();
            string program = Environment.GetCommandLineArgs()[0];
            Console.WriteLine("Usage: {0} URI FILE_NAME", program);
        }

        //---------------------------------------------------------------------

        private static TAssemblyAttribute GetAttribute<TAssemblyAttribute>(Assembly assembly)
            where TAssemblyAttribute : Attribute
        {
            System.Type attrType = typeof(TAssemblyAttribute);
            Attribute attr = Attribute.GetCustomAttribute(assembly, attrType);
            return (TAssemblyAttribute)attr;
        }

        //---------------------------------------------------------------------

        private static int UsageError(string message)
        {
            Console.WriteLine("Error: {0}", message);
            string program = Environment.GetCommandLineArgs()[0];
            Console.WriteLine("For help, enter: {0} {1}", program, helpOption);
            return 1;
        }

        //---------------------------------------------------------------------

        public static void DownloadFileAsync(string uriString,
                                              string fileName)
        {
            WebClient client = new WebClient();
            Uri uri = new Uri(uriString);
 
            client.DownloadProgressChanged +=
                new DownloadProgressChangedEventHandler(DownloadProgress);
            client.DownloadFileCompleted +=
                new AsyncCompletedEventHandler (DownloadComplete);

            downloadComplete = false;
            displayedPercentage = 0;
            Console.Write("0%");
            client.DownloadFileAsync(uri, fileName);
            while (! downloadComplete)
                Thread.Sleep(1000);  // Wait a second
        }

        //---------------------------------------------------------------------

        public static void DownloadComplete(object sender,
                                            AsyncCompletedEventArgs e)
        {
            downloadComplete = true;
            if (e.Cancelled)
                Console.WriteLine(" cancelled");
            else if (e.Error != null) {
                Console.WriteLine(" error");
                Console.WriteLine("  Error: {0}", e.Error);
            }
            else
                Console.WriteLine(" done");
        }

        //---------------------------------------------------------------------

        public static void DownloadProgress(object sender,
                                            DownloadProgressChangedEventArgs e)
        {
            int currentPercentage = e.ProgressPercentage;
            while (displayedPercentage + displayIncrement <= currentPercentage) {
                displayedPercentage += displayIncrement;
                if (displayedPercentage % 10 == 0)
                    Console.Write("{0}%", displayedPercentage);
                else
                    Console.Write(".");
            }
        }
    }
}

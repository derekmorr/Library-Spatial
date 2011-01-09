using LandisII.Examples.SimpleExtension;
using System;

namespace LandisII.Examples
{
    class MainClass
    {
        public static void Main (string[] args)
        {
            Console.WriteLine("Initializing LANDIS-II core...");
            Core modelCore = new Core();

            // Instantiate the main class of the example extension, passing
            //   the core to it.
            ExtensionMain extensionMain = new ExtensionMain(modelCore);

            // Run the extension.
            extensionMain.Run();
        }
    }
}

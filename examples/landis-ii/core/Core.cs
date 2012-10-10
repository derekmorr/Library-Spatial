using Landis.SpatialModeling;
using LandisII.Examples.SimpleExtension;
using System;

namespace LandisII.Examples
{
    public class Core : LandisII.Examples.SimpleCore.ICore
    {
        private IConfigurableRasterFactory rasterFactory;
        private ILandscapeFactory landscapeFactory;
        private ILandscape landscape;
        private ISiteVar<int> ecoregions;

        /// <summary>
        /// Construct a new instance of the model core.
        /// </summary>
        /// <param name="rasterFactory">
        /// A <see cref="IConfigurableRasterFactory"/> that the core uses to
        /// open and create rasters.  A mock factory can be passed for testing
        /// purposes.
        /// </param>
        /// <param name="landscapeFactory">
        /// A <see cref="ILandscapeFactory"/> that the core uses to create its
        /// landscape data structures.  A mock factory can be passed for
        /// testing purposes.
        /// </param>
        public Core(IConfigurableRasterFactory rasterFactory,
                    ILandscapeFactory landscapeFactory)
        {
            this.rasterFactory = rasterFactory;
            this.landscapeFactory = landscapeFactory;

            BindExtensionToFormat(".bin", "ENVI" );
            BindExtensionToFormat(".bmp", "BMP"  );
            BindExtensionToFormat(".gis", "LAN"  );
            BindExtensionToFormat(".img", "HFA"  );
            BindExtensionToFormat(".tif", "GTiff");
        }

        // Bind a file extension to a raster format if the format is supported
        // by the raster factory.
        private void BindExtensionToFormat(string fileExtension,
                                           string formatCode)
        {
            RasterFormat rasterFormat = rasterFactory.GetFormat(formatCode);
            if (rasterFormat != null)
                rasterFactory.BindExtensionToFormat(fileExtension, rasterFormat);
        }

        public void RunScenario(string path)
        {
            // path to scenario file ignored

            landscape = landscapeFactory.CreateLandscape(Ecoregions.CreateGrid());
 
            ecoregions = landscape.NewSiteVar<int>();
            foreach (ActiveSite site in landscape) {
                ecoregions[site] = Ecoregions.Codes[site.Location.Row-1, site.Location.Column-1];
            }
            ecoregions.InactiveSiteValues = -1;

            // Instantiate the main class of the example extension, passing
            //   the core to it.
            ExtensionMain extensionMain = new ExtensionMain(this);

            // Run the extension.
            extensionMain.Run();
       }

#region ICore members
        public int CurrentTime
        {
            get {
                return 0;
            }
        }

        public ILandscape Landscape
        {
            get {
                return landscape;
            }
        }

        public ISiteVar<int> EcoregionCodes
        {
            get {
                return ecoregions;
            }
        }

        public IInputRaster<TPixel> OpenRaster<TPixel>(string path)
            where TPixel : Pixel, new()
        {
            return rasterFactory.OpenRaster<TPixel>(path);
        }

        public IOutputRaster<TPixel> CreateRaster<TPixel>(string     path,
                                                          Dimensions dimensions)
            where TPixel : Pixel, new()
        {
            return rasterFactory.CreateRaster<TPixel>(path, dimensions);
        }
#endregion
    }
}

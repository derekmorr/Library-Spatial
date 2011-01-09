using Landis.SpatialModeling;
using Landis.SpatialModeling.CoreServices;
using System;

namespace LandisII.Examples
{
    public class Core : LandisII.Examples.SimpleCore.ICore
    {
        private RasterFactory rasterFactory;
        private ILandscape landscape;
        private ISiteVar<int> ecoregions;

        public Core()
        {
            rasterFactory = new RasterFactory();
            landscape = LandscapeFactory.CreateLandscape(Ecoregions.CreateGrid());
 
            ecoregions = landscape.NewSiteVar<int>();
            foreach (ActiveSite site in landscape) {
                ecoregions[site] = Ecoregions.Codes[site.Location.Row-1, site.Location.Column-1];
            }
            ecoregions.InactiveSiteValues = -1;
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

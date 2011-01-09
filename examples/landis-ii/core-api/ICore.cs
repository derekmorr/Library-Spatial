using Landis.SpatialModeling;

namespace LandisII.Examples.SimpleCore
{
    /// <summary>
    /// Example of core interface passed to LANDIS-II extensions.
    /// </summary>
    public interface ICore : IRasterFactory
    {
        /// <summary>
        /// Current timestep (year).
        /// </summary>
        int CurrentTime
        {
            get;
        }

        /// <summary>
        /// The landscape.
        /// </summary>
        ILandscape Landscape
        {
            get;
        }

        /// <summary>
        /// Ecoregion codes for each site.
        /// </summary>
        ISiteVar<int> EcoregionCodes
        {
            get;
        }
    }
}

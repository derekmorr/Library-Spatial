using Landis.SpatialModeling;

namespace LandisII.Examples.SimpleExtension
{
    public class SlopeAspectPixel : Pixel
    {
        public Band<float> Slope  = "slope : tangent of inclination angle (rise / run)";
        public Band<short> Aspect = "aspect : degrees clockwise from north (0 to 359)";

        public SlopeAspectPixel() 
        {
            SetBands(Slope, Aspect);
        }
    }
}

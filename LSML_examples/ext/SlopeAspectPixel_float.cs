using Landis.SpatialModeling;

namespace LandisII.Examples.SimpleExtension
{
    public class SlopeAspectPixel_float : Pixel
    {
        public Band<float> Slope  = "slope : tangent of inclination angle (rise / run)";
        public Band<float> Aspect = "aspect : degrees clockwise from north (0 to 359)";

        public SlopeAspectPixel_float()
        {
            SetBands(Slope, Aspect);
        }
    }
}

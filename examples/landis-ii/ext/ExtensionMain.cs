using LandisII.Examples.SimpleCore;
using Landis.SpatialModeling;
using System;

namespace LandisII.Examples.SimpleExtension
{
    /// <summary>
    /// Main entry class for extension.
    /// </summary>
    public class ExtensionMain
    {
        private ICore core;

        public ExtensionMain(ICore modelCore)
        {
            core = modelCore;
        }

        public void Run()
        {
            Console.WriteLine("Running the example LANDIS-II extension...");

            Console.WriteLine("Ecoregion codes:");
            foreach (Site site in core.Landscape.AllSites) {
                Console.Write("  {0}", core.EcoregionCodes[site]);
                if (site.Location.Column == core.Landscape.Columns)
                    Console.WriteLine();
            }
            Console.WriteLine();

            short[,] data = new short[90,140];
            int rows    = data.GetLength(0);
            int columns = data.GetLength(1);
            Dimensions dimensions = new Dimensions(rows, columns);

            for (int r = 0; r < rows; ++r) {
                for (int c = 0; c < columns; ++c)
                    data[r, c] = (short) ((c * 100) + r);
            }

            string rasterPath = "slope-aspect.img";

            using (IOutputRaster<SlopeAspectPixel> outputRaster = core.CreateRaster<SlopeAspectPixel>(rasterPath, dimensions))
            {
                SlopeAspectPixel pixel = outputRaster.BufferPixel;
                for (int row = 0; row < rows; ++row) {
                    for (int column = 0; column < columns; ++column) {
                        pixel.Slope.Value  = (float)(data[row, column] / 100.0);
                        pixel.Aspect.Value = data[row, column];
                        outputRaster.WriteBufferPixel();
                    }
                }
            }

            Console.WriteLine("Opening input raster \"{0}\":", rasterPath);
            // Have to use pixel with two float bands because GDAL allows only
            // one shared data type across all the raster bands when creating
            // a raster.
            //
            // TO DO: Consider changing spatial library's API so that all the
            //        bands in an input or output raster have the same type.
            using (IInputRaster<SlopeAspectPixel_float> inputRaster = core.OpenRaster<SlopeAspectPixel_float>(rasterPath))
            {
                Console.WriteLine("  Dimensions: {0}", inputRaster.Dimensions);

                SlopeAspectPixel_float pixel = inputRaster.BufferPixel;
                int slopeErrors = 0;
                int aspectErrors = 0;
                for (int row = 1; row <= inputRaster.Dimensions.Rows; ++row) {
                    for (int column = 1; column <= inputRaster.Dimensions.Columns; ++column) {
                        inputRaster.ReadBufferPixel();

                        // Check the actual slope and aspect values to expected values
                        float expectedSlope = (float)(data[row-1, column-1] / 100.0);
                        if (pixel.Slope.Value != expectedSlope) {
                            Console.WriteLine("({0}, {1}) : expected Slope ({2}) not = actual Slope ({3})", row, column, expectedSlope, pixel.Slope.Value);
                            slopeErrors++;
                        }
                        float expectedAspect = data[row-1, column-1];
                        if (pixel.Aspect.Value != expectedAspect) {
                            Console.WriteLine("({0}, {1}) : expected Aspect ({2}) not = actual Aspect ({3})", row, column, expectedAspect, pixel.Aspect.Value);
                            aspectErrors++;
                        }
                    }
                }
                Console.WriteLine("# of mismatched slope values: {0}", slopeErrors);
                Console.WriteLine("# of mismatched aspect values: {0}", aspectErrors);
            }
        }
    }
}

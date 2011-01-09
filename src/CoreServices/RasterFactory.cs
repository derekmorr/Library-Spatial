// Copyright 2010 Green Code LLC
// All rights reserved.
//
// The copyright holders license this file under the New (3-clause) BSD
// License (the "License").  You may not use this file except in
// compliance with the License.  A copy of the License is available at
//
//   http://www.opensource.org/licenses/bsd-license.php
//
// and is included in the NOTICE.txt file distributed with this work.
//
// Contributors:
//   James Domingo, Green Code LLC

using Landis.SpatialModeling.CoreServices.RasterIO;

namespace Landis.SpatialModeling.CoreServices
{
    public class RasterFactory : IRasterFactory
    {
        public RasterFactory ()
        {
        }

        public IInputRaster<TPixel> OpenRaster<TPixel>(string path)
            where TPixel : Pixel, new()
        {
            return new GdalInputRaster<TPixel>(path);
        }

        public IOutputRaster<TPixel> CreateRaster<TPixel>(string     path,
                                                          Dimensions dimensions)
            where TPixel : Pixel, new()
        {
            return new GdalOutputRaster<TPixel>(path, dimensions);
        }
    }
}

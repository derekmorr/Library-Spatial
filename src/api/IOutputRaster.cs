// Copyright 2004-2006 University of Wisconsin
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
//   James Domingo, UW-Madison, Forest Landscape Ecology Lab
//   James Domingo, Green Code LLC

namespace Landis.SpatialModeling
{
    /// <summary>
    /// An output raster file to which pixel data are written.  Pixels are
    /// written in row-major order, from the upper-left corner to the
    /// lower-right corner.
    /// </summary>
    public interface IOutputRaster<TPixel>
        : IRaster
        where TPixel : Pixel
    {
        /// <summary>
        /// The single-pixel buffer for writing pixels to the raster. 
        /// </summary>
        TPixel BufferPixel
        {
            get;
        }

        //---------------------------------------------------------------------

        /// <summary>
        /// The number of pixels written to the raster.
        /// </summary>
        int PixelsWritten
        {
            get;
        }

        //---------------------------------------------------------------------

        /// <summary>
        /// Writes the buffer pixel to the raster.
        /// </summary>
        /// <exception cref="System.InvalidOperationException">
        /// This method was called too many times (more than the number of
        /// pixels in the raster).
        /// </exception>
        /// <exception cref="System.IO.IOException">
        /// An error occurred writing the pixel data to the raster.
        /// </exception>
        void WriteBufferPixel();
    }
}

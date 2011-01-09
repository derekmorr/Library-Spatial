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
    /// An input raster file from which pixel data are read.  Pixels are read
    /// in row-major order, from the upper-left corner to the lower-right
    /// corner.
    /// </summary>
    public interface IInputRaster<TPixel>
        : IRaster
        where TPixel : Pixel, new()
    {
        /// <summary>
        /// The single-pixel buffer for reading pixels to the raster. 
        /// </summary>
        TPixel BufferPixel
        {
            get;
        }

        //---------------------------------------------------------------------

        /// <summary>
        /// Reads the next pixel from the raster into the buffer pixel.
        /// </summary>
        /// <exception cref="System.IO.EndOfStreamException">
        /// There are no more pixels left to read.
        /// </exception>
        /// <exception cref="System.IO.IOException">
        /// An error occurred reading the pixel data from the raster.
        /// </exception>
        /// <exception cref="System.InvalidOperationException">
        /// This method was called too many times (more than the number of
        /// pixels in the raster).
        /// </exception>
        void ReadBufferPixel();
    }
}

// Copyright 2004-2006 University of Wisconsin
// All rights reserved. 
//
// The copyright holders license this file under the New (3-clause) BSD
// License (the "License").  You may not use this file except in
// compliance with the License.  A copy of the License is available at
//
//   http://www.opensource.org/licenses/BSD-3-Clause
//
// and is included in the NOTICE.txt file distributed with this work.
//
// Contributors:
//   James Domingo, UW-Madison, Forest Landscape Ecology Lab

namespace Landis.SpatialModeling
{
    /// <summary>
    /// A grid whose cells can be accessed by their locations.
    /// </summary>
    public interface IIndexableGrid<TCell>
        : IGrid
    {
        /// <summary>
        /// Gets or sets the cell specified by its row and column.
        /// </summary>
        /// <param name="row">The cell's row.</param>
        /// <param name="column">The cell's column</param>
        TCell this [int row,
                    int column]
        {
            get;
            set;
        }

        //---------------------------------------------------------------------

        /// <summary>
        /// Gets or sets the cell specified by its location.
        /// </summary>
        /// <param name="location">The cell's location.</param>
        TCell this [Location location]
        {
            get;
            set;
        }
    }
}

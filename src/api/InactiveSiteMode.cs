// Copyright 2005-2006 University of Wisconsin
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
    /// Indicates how values at inactive sites are handled for a site variable.
    /// </summary>
    public enum InactiveSiteMode
    {
        /// <summary>
        /// All the inactive sites share one value (memory efficient).
        /// </summary>
        Share1Value,

        /// <summary>
        /// Each inactive site has its own distinct (separate) value.
        /// </summary>
        DistinctValues
    }
}

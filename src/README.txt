The Premake build configuration tool is needed to generate the C# solution
that includes all 4 of the required project files.  Premake is available from:

  http://industriousone.com/premake

Premake 4.3 has been used successfully to generate VS2008 solution files.
In order to generate VS2010 project files use premake 4.4
is needed because Premake 4.3 doesn't support VS2010 C# projects.

Premake 5 has been used successfully to generate VS2017 solution files. command: 'Premake5 VS2017'

This solution contains four projects that represent the library's API and
its implementation:

          folder/project                  description
  ------------------------------------    -----------
            api/Landis_SpatialModeling -- API
     Landscapes/Landis_Landscapes      -- Implementation of the Landscape module
       RasterIO/Landis_RasterIO        -- Data types shared by Raster I/O
                                          implementations
  RasterIO.Gdal/Landis_RasterIO_Gdal   -- Implementation of the Raster I/O
                                          module using GDAL

The Raster I/O implementation based on GDAL uses its C# bindings.  These 

   {ProjectRoot}/GDAL/managed

The Premake build configuration tool is needed to generate the C# solution
and project files.  Premake is available from:

  http://industriousone.com/premake

Premake 4.3 has been used successfully to generate VS2008 project files.
In order to generate VS2010 project files, Premake 4.4 (currently, beta 4)
is needed because Premake 4.3 doesn't support VS2010 C# projects.

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

The Raster I/O implementation based on GDAL uses its C# bindings.  Therefore,
these bindings must be present in order to build that project.  The directory
where the bindings must be located is:

   {ProjectRoot}/external/gdal/libs/managed/

When Premake generates the C# solution and project files (i.e., its action
starts with "vs"), it will also try to download pre-compiled files for GDAL
and C# bindings from the landis-spatial project web site.  If they are not
available for the current platform, then Premake will notify the developer
to either obtain pre-compiled files from another location, or manually build
GDAL and its C# bindings from source.

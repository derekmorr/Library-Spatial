build_dir="../build"

solution "landis-spatial"

  language "C#"    -- by default, premake uses "Any CPU" for platform
  framework "3.5"

  configurations { "Debug", "Release" }
 
  configuration "Debug"
    defines { "DEBUG" }
    flags { "Symbols" }
    targetdir ( build_dir .. "/Debug" )
 
  configuration "Release"
    flags { "OptimizeSize" }
    targetdir ( build_dir .. "/Release" )
 
  -- The library's API
  project "Landis_SpatialModeling"
    location "api"
    kind "SharedLib"
    targetname "Landis.SpatialModeling"
    files {
      "api/*.cs",
      "SharedAssemblyInfo.cs"
    }
    links { "System" }

  -- Implementation of the Landscape module
  project "Landis_Landscapes"
    location "Landscapes"
    kind "SharedLib"
    targetname "Landis.Landscapes"
    files {
      "Landscapes/**.cs",
      "SharedAssemblyInfo.cs"
    }
    links {
      "System",
      "Landis_SpatialModeling"
    }

  -- Data types shared by Raster I/O implementations
  project "Landis_RasterIO"
    location "RasterIO"
    kind "SharedLib"
    targetname "Landis.RasterIO"
    files {
      "RasterIO/**.cs",
      "SharedAssemblyInfo.cs"
    }
    links {
      "System",
      "Landis_SpatialModeling",
    }

  -- Implementation of the Raster I/O module using GDAL
  project "Landis_RasterIO_Gdal"
    location "RasterIO.Gdal"
    kind "SharedLib"
    targetname "Landis.RasterIO.Gdal"
    files {
      "RasterIO.Gdal/**.cs",
      "SharedAssemblyInfo.cs"
    }
    links {
      "System",
      "Landis_SpatialModeling",
      "Landis_RasterIO",
      "../external/gdal/libs/managed/gdal_csharp.dll"
    }

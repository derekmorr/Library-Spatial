build_dir="../build"

GDALdir="../external/gdal"
GDALcsharpLib=GDALdir .. "/libs/managed/gdal_csharp.dll"

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
      GDALcsharpLib
    }

-- ==========================================================================

-- Hook in a custom function that is called *after* the selected action
-- is executed.

require "premake4_util"

afterAction_call(
  function()
    --  If generating Visual Studio files, add HintPath elements for references
    --  with paths.
    if string.startswith(_ACTION, "vs") then
      modifyCSprojFiles()

      -- Fetch GDAL C# bindings for this platform if they're not present
      if not os.isfile(GDALcsharpLib) then
        GDALadmin("get")
      end
    end
  end
)

-- ==========================================================================

-- The function below modifies the all the projects' *.csproj files, by
-- changing each Reference that has a path in its Include attribute to use
-- a HintPath element instead.

require "CSProjFile"

function modifyCSprojFiles()
  for i, prj in ipairs(solution().projects) do
    local csprojFile = CSprojFile(prj)
    print("Modifying " .. csprojFile.relPath .. " ...")
    csprojFile:readLines()

    adjustReferencePaths(csprojFile)
    print("  <HintPath> elements added to the project's references")
    if _PREMAKE_VERSION == "4.3" then
      -- In 4.3, the "framework" function doesn't work
      addFramework(csprojFile)
      print("  <TargetFrameworkVersion> element added to the project's properties")
    end

    -- Generate XML documentation for API assembly (for Intellisense in IDEs)
    if prj.name == "Landis_SpatialModeling" then
      enableXMLdocumentation(csprojFile)
      print("  Enabled the generation of XML documentation file")
    end

    ok, err = csprojFile:writeLines()
    if not ok then
      error(err, 0)
    end
  end -- for each project
end

-- ==========================================================================

-- Run the GDAL-admin script with a specific action

function GDALadmin(action)
  local onWindows = runningOnWindows()
  local scriptExt = iif(onWindows, "cmd", "sh")
  local adminScript = GDALdir .. "/GDAL-admin." .. scriptExt
  if onWindows then
    adminScript = path.translate(adminScript, "\\")
  end
  print("Running " .. adminScript .. " '" .. action .. "'...")
  os.execute(adminScript .. " " .. action)
end

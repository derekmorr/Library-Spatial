build_dir="build"

solution "landis-download-tool"

  language "C#"
  -- by default, premake uses "Any CPU" for platform

  configurations { "Debug", "Release" }
 
  configuration "Debug"
    defines { "DEBUG" }
    flags { "Symbols" }
    targetdir ( build_dir .. "/Debug" )
 
  configuration "Release"
    flags { "OptimizeSize" }
    targetdir ( build_dir .. "/Release" )
 
  project "Landis.Tools.DownloadFile"
    kind "ConsoleApp"
    files {
      "AssemblyInfo.cs",
      "Program.cs"
    }
    links { "System" }

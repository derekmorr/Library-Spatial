build_dir="build"

solution "MSBuild.Community.Tasks.Hash"

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
 
  project "MSBuild.Community.Tasks.Hash"
    kind "SharedLib"
    files {
      "AssemblyInfo.cs",
      "Hash.cs"
    }
    links {
      "Microsoft.Build.Framework",
      "Microsoft.Build.Utilities",
      "../../external/MSBuild/MSBuild.Community.Tasks.dll",
      "System",
    }

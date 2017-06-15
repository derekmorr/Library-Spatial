Title:			README_Library-Spatial 
Project:		LANDIS-II Landscape Change Model
Project Component:	Landis Spatial Modeling Libraries (LSML)
Component Deposition:	https://github.com/LANDIS-II-Foundation/Landis-Spatial
Author:			LANDIS-II Foundation
Origin Date:		26 May 2017
Final Date:		15 June 2017




The Premake build configuration tool (Premake 5) is needed to generate the C# solution file, 
"landis-spatial.sln". This .sln file builds all four of the .dll assemblies which constitute the 
library's API and its implementation:

          folder/project                  description
  ------------------------------------    -----------
	api/Landis_SpatialModeling 		-- API
	Landscapes/Landis_Landscapes    	-- Implementation of the Landscape module	
	RasterIO/Landis_RasterIO        	-- Data types shared by Raster I/O implementations
	RasterIO.Gdal/Landis_RasterIO_Gdal  	-- Implementation of the Raster I/O module using GDAL





The procedure below describes building "landis-spatial.sln" in Windows 10.




####################################################################
Stage One Rebuild -- Generate .sln and .csproj files with Premake
####################################################################

Useful Premake websites:
https://github.com/premake/premake-core/wiki
http://premake.github.io/


The Premake build configuration tool is needed to generate the C# solution file 
(.sln) and the project files (.csproj) for rebuilding Core Model. Premake will generate 
the requisite Visual Studio files (the .sln file the .csproj files) for a rebuild.
Premake itself is built on Lua, a fast, light-weight scripting language. Premake 
scripts are actually Lua programs (.lua files). Using Visual Studio 2015 or greater is
highly recommended. 


NB. Currently, the rebuild process is set for the use of Premake5.0 with an output of VS 2015 .sln
and .csproj files. Premake will look for a file named, "premake5.lua" by default.


	a. run the premake5.lua script
	b1. at the (ADM) command line prompt:
C:\Users\..\..\Landis-Spatial-Modeling-Library\src>premake5 vs2015


	c. the following files will be created:

 	src/landis-spatial.sln
        src/Landscapes/Landis_Landscapes.csproj
	src/RasterIO/Landis_RasterIO.csproj
        src/RasterIO.Gdal/Landis_RasterIO_Gdal.csproj
	src/api/Landis_SpatialModeling.csproj
        

	

################################################################
Stage Two Rebuild -- Perform a Visual Studio (Release) build
#################################################################

NB. The "landis-spatial.sln" file can be opened in a variety of IDE environments including,
Visual Studio (VS) and MonoDevelop. VS2015 is recommended.


	a. Open the  "landis-spatial.sln" file in VS 2015


	b. Use the pull down menu and select, "Release"


	c. Build the  "landis-spatial.sln" in Release Mode


	d. Expected VS output:

1>------ Build started: Project: Landis_SpatialModeling, Configuration: Release Any CPU ------
1>C:\Users\bmarr\Desktop\working_SpatialLibrary\Landis-Spatial-Modeling-Library\src\api\Band.cs(49,29,49,37): warning CS1734: XML comment on 'Band<T>.ComputeSize()' has a paramref tag for 'typeCode', but there is no parameter by that name
1>  Landis_SpatialModeling -> C:\Users\bmarr\Desktop\working_SpatialLibrary\Landis-Spatial-Modeling-Library\build\Release\Landis.SpatialModeling.dll
2>------ Build started: Project: Landis_RasterIO, Configuration: Release Any CPU ------
3>------ Build started: Project: Landis_Landscapes, Configuration: Release Any CPU ------
2>  Landis_RasterIO -> C:\Users\bmarr\Desktop\working_SpatialLibrary\Landis-Spatial-Modeling-Library\build\Release\Landis.RasterIO.dll
4>------ Build started: Project: Landis_RasterIO_Gdal, Configuration: Release Any CPU ------
4>  Landis_RasterIO_Gdal -> C:\Users\bmarr\Desktop\working_SpatialLibrary\Landis-Spatial-Modeling-Library\build\Release\Landis.RasterIO.Gdal.dll
3>  Landis_Landscapes -> C:\Users\bmarr\Desktop\working_SpatialLibrary\Landis-Spatial-Modeling-Library\build\Release\Landis.Landscapes.dll
========== Build: 4 succeeded, 0 failed, 0 up-to-date, 0 skipped ==========


	e. expected contents of C:\Users\...\...\build\Release 


Landis.Landscapes.dll
Landis.Landscapes.pdb
Landis.RasterIO.dll
Landis.RasterIO.pdb
Landis.RasterIO.Gdal.dll
Landis.RasterIO.Gdal.pdb
Landis.SpatialModeling.dll
Landis.SpatialModeling.pdb
Landis.SpatialModeling.xml
gdal_csharp.dll
ogr_csharp.dll
osr_csharp.dll




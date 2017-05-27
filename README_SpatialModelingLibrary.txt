Title:			README_Landis-Spatial-Modeling-Libray
Project:		LANDIS-II Landscape Change Model
Project Component:	Spatial Modeling Library
Component Deposition:	https://github.com/LANDIS-II-Foundation/Landis-Spatial-Modeling-Library
Author:			LANDIS-II Foundation
Origin Date:		26 May 2017
Final Date:		26 Mar 2017



The procedure below describes building  in Windows 10.
See the README_LINUX.txt file for instructions on how to build and run
LANDIS-II on Linux, along with a list of troubleshooting tips.




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


	b. Use the pull down menu that currently shows, "Debug" and select, "Release"


	c. Build the  "landis-spatial.sln" in Release Mode


	d. Expected VS output:


	e. expected contents of C:\Users\...\...\build\Release 






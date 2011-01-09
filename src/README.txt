This solution contains two projects that represent the library's API and
its core services.  The core-services project uses the C# bindings to
GDAL.  Therefore, these bindings must be installed on the computer in
order to build the core-services assembly.

In the actual C# project file (CoreServices/landis-spatial_core.csproj), the
<HintPath> element of the <Reference> element for the gdal_csharp
assembly indicates where those C# bindings are located.  If necessary,
change that path to match the actual path of the gdal_csharp assembly
on your computer..

The solution has only built on OS X (10.4, Tiger) using GDAL 1.6.2.
In order to use the core-services assembly on OS X, one additional
library file must be copied manually from the C# bindings to bin/Debug
or bin/Release.  The library file is located at:

  {HINTPATH_DIR}/.libs/libgdalcsharp.dylib

where {HINTPATH_DIR} is the directory portion of the <HintPath> element
for the gdal_cshap assembly.  For example, if <HintPath> is:

  ..\..\..\..\..\gdal\gdal-1.6.2\swig\csharp\gdal_csharp.dll

then the additional library file is:

  ..\..\..\..\..\gdal\gdal-1.6.2\swig\csharp\.libs\libgdalcsharp.dylib

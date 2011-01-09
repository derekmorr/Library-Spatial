using System.Reflection;
using System.Runtime.CompilerServices;

[assembly: AssemblyProduct("LANDIS Spatial Modeling Library")]
[assembly: AssemblyDescription("Library API")]
[assembly: AssemblyCopyright("Copyright 2010 Green Code LLC")]

[assembly: AssemblyVersion("1.0.*")]

#if DEBUG
[assembly: AssemblyConfiguration("Debug")]
#else
[assembly: AssemblyConfiguration("Release")]
#endif

[assembly: InternalsVisibleTo("Landis.SpatialModeling.CoreServices")]

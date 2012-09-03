using System.Reflection;

[assembly: AssemblyProduct("LANDIS Spatial Modeling Library")]
[assembly: AssemblyVersion("0.86.*")]

#if DEBUG
[assembly: AssemblyConfiguration("Debug")]
#else
[assembly: AssemblyConfiguration("Release")]
#endif

using System.Reflection;

[assembly: AssemblyProduct("LANDIS Download-File Tool")]
[assembly: AssemblyVersion("1.0.*")]
[assembly: AssemblyCopyright("Copyright 2012 Green Code LLC")]

#if DEBUG
[assembly: AssemblyConfiguration("Debug")]
#else
[assembly: AssemblyConfiguration("Release")]
#endif

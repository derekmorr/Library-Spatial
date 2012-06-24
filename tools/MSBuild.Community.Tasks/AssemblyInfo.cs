using System.Reflection;

[assembly: AssemblyProduct("MSBuild.Community.Tasks.Hash")]
[assembly: AssemblyVersion("1.0.*")]
[assembly: AssemblyCopyright("Copyright 2012 Green Code LLC")]

#if DEBUG
[assembly: AssemblyConfiguration("Debug")]
#else
[assembly: AssemblyConfiguration("Release")]
#endif

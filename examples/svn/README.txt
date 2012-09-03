This folder illustrates one way that LSML can be incorporated into a model
application's Subversion project.  In this example, the "third-party"
folder contains the third-party (external) components that the application
depends upon.  These components include LSML.  The version of LSML used by
the application is specified in a text file.  Scripts named "LSML-admin.*"
read the version from the text file, and download the specified version
of LSML when passed the "get" action:

  LSML-admin.cmd get  -- on Windows
  LSML-admin.sh get   -- on *nix, including OS X

In addition to the desired LSML version, the text file contains the SHA1
hash of that version.  The LSML-admin scripts use that hash value to verify
the downloaded file.

The appropriate LSML-admin script can be called during the configuration
phase of the application's build process (for example, by a premake4.lua
script).

The Windows version of the script (LSML-admin.cmd) uses the getPackage.cmd
script in the WinPkgTools toolkit.  The LSML folder has an svn:externals
property which is used to checkout the client part of that toolkit:

  Local Path   URL
  -----------  ---
  WinPkgTools  https://landis-spatial.googlecode.com/svn/tags/tools/WinPkg/1.6/clients

This minimizes the size and bandwidth of a checkout on non-Windows
systems.  When "LSML-admin.cmd get" is run on a Windows system, the
getPackage script calls the toolkit's initialization script to download
all the remaining tools before LSML is fetched.

The LSML-admin scripts also accept these other action arguments:

  clean     -- Remove all the files extracted from downloaded zip files
  distclean -- Same as "clean", plus remove all downloaded files
  help      -- Display list of available action arguments

The "clean" action can be used to implement a "clean" target or action
for the application's project.

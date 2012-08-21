This folder illustrates one way that LSML can be incorporated into a model
application's Subversion project.  In this example, the "third-party"
folder contains the third-party (external) components that the application
depends upon.  These components include LSML.  The version of LSML used by
the application is specified in a text file.  Scripts naamed "get-LSML.*"
read the version from the text file, and download the specified version
of LSML:

  get-LSML.cmd -- Windows command script
  get-LSML.sh  -- Bourne shell script (for *nix, including OS X)

In addition to the desired LSML version, the text file contains the SHA1
hash of that version.  The get-LSML scripts use that hash value to verify
the downloaded file.

The appropriate get-LSML script can be called during the configuration
phase of the application's build process (for example, by a premake4.lua
script).

The Windows version of the script (get-LSML.cmd) uses the getPackage.cmd
script in the WinPkgTools toolkit.  The LSML folder has an svn:externals
property which is used to checkout the client part of that toolkit:

  Local Path   URL
  -----------  ---
  WinPkgTools  https://landis-spatial.googlecode.com/svn/tags/tools/WinPkg/1.3/clients

This minimizes the size and bandwidth of a checkout on non-Windows
systems.  When get-LSML.cmd is run on a Windows system, the getPackage
script calls the toolkit's initialization script to download all the
remaining tools before LSML is fetched.

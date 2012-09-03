A collection of tools for downloading and unpacking software packages
(i.e., zip files) on Windows systems.

Version 1.6 contains:

  Landis.Tools.DownloadFile.exe -- LANDIS Download-File Tool 1.1.4589.32177
  checksum.exe                  -- Checksum Calculator (Jan 20, 2008)
  unzip.exe                     -- Info-ZIP's UnZip 6.00

  getPackage.cmd                -- Windows command script that uses the
                                   three tools above
  clean.cmd                     -- Windows command script that removes all
                                   tools and licenses downloaded during the
                                   the toolkit's initialization

The toolkit is released in the organization shown in the "dist" folder.
For each release, the "dist" folder is copied into the project's "tags"
SVN folder under "tools/WinPkg/#.#" where #.# is the release's version
number.

A client project uses a svn:externals property to fetch the "clients"
folder of a particular version.  For example,

  Path:  WinPkgTools
  URL:   http://landis-spatial.googlecode.com/svn/tags/tools/WinPkg/2.3/clients

Then, if the client project has been checked out on a Windows system,
the project's configuration script can use the getPackage.cmd script
to download, checksum and unpack zip files.  The getPackage.cmd script
calls another script to initialize the toolkit; this initialization
script will download the remaining tools into that external folder.

The getPackage.cmd script takes 4 arguments:

  getPackage.cmd PackageURL PackagePath ExpectedSHA1 UnpackedItem

where:

  PackageURL   -- URL of the zip package to download
  PackagePath  -- Local path where zip file should be downloaded to
  ExpectedSHA1 -- SHA1 checksum for zip file
  UnpackedItem -- A file or folder in the zip file, which the script
                  checks to if it exists on the local filesystem; if
                  not, then the script unpacks the zip file

Continuing the example above, the configuration script can download,
checksum, and unpack version 1.0 of the Foo library as follows:

  set FooURL=http://downloads.example.com/files/FooLibrary-1.0.zip
  set FooPkg=download\FooLib-1.0.zip
  set FooSHA1=da39a3ee5e6b4b0d3255bfef95601890afd80709
  set FooDLL=Foo.dll
  call WinPkgTools\getPackage %FooUrl% %FooPkg% %FooSHA1% %FooDLL%


Revision History

  v1.6 (Sep 3, 2012)

    *  Added the optional "vars" argument to the initialize.cmd script.
       It tells the script to only initialize the environment variables
       related to the toolkit; no missing tools are downloaded.

    *  The getPackage script now uses the -u option to unzip a package,
       so the developer isn't asked about replacing files that have
       already been unpacked.

  v1.5 (Aug 22, 2012)

    *  Added a clean.cmd script, which removes all the files that are
       downloaded when the toolkit is initialized.  It can be used by
       a client project to implement a "clean" or "distclean" target
       or action.

  v1.4 (Aug 21, 2012)

    *  Enhanced getPackage script so it provides control over where
       the zip package is unpacked.  It now unpacks the zip file in
       the folder specified by the directory part of UnpackedItem's
       path.

  v1.3 (Aug 20, 2012)
  
    *  Fixed a bug in the toolkit's internal "initialize.cmd"
       script.

  v1.2 (Jul 26, 2012)

    *  Updated the download-file tool to version 1.1.4589.32177
       which fixes a bug in the tool's progress bar.

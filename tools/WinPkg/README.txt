A collection of tools for downloading and unpacking software packages
(i.e., zip files) on Windows systems.

Version 1.3 contains:

  Landis.Tools.DownloadFile.exe -- LANDIS Download-File Tool 1.1.4589.32177
  checksum.exe                  -- Checksum Calculator (Jan 20, 2008)
  unzip.exe                     -- Info-ZIP's UnZip 6.00

  getPackage.cmd                -- Windows command script that uses the
                                   three tools above

Version 1.3 fixes a bug in the toolkit's internal "initialize.cmd"
script.

The toolkit is released in the organization shown in the "dist" folder.
For each release, the "dist" folder is copied into the project's "tags"
SVN folder under "tools/WinPkg/#.#" where #.# is the release's version
number.

A client project uses a svn:externals property to fetch the "clients"
folder of a particular version.  For example,

  http://landis-spatial.googlecode.com/svn/tags/tools/WinPkg/2.3/clients WinPkgTools

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

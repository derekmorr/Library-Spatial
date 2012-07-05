A collection of tools for downloading and unpacking software packages
(i.e., zip files) on Windows systems.

Version 1.1 contains:

  Landis.Tools.DownloadFile.exe -- LANDIS Download-File Tool 1.0.4555.39970
  checksum.exe                  -- Checksum Calculator (Jan 20, 2008)
  unzip.exe                     -- Info-ZIP's UnZip 6.00

The toolkit is released in the organization shown in the "dist" folder.
For each release, the "dist" folder is copied into the project's "tags"
SVN folder under "tools/WinPkg/#.#" where #.# is the release's version
number.

A client project can fetch this toolkit in two stages.  In the first
stage, the client project uses a svn:externals property to fetch a
particular version's "clients" folder.  For example,

  http://landis-spatial.googlecode.com/svn/tags/tools/WinPkg/2.3/clients win-tools

Then, if the client project has been checked out on a Windows system,
the developer (or the client project's configure script) calls the
Windows script in the external folder.  Continuing the example above,

  win-tools\get-tools.cmd

That script will download the remaining tools into the folder with
the script.

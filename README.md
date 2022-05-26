# RECOVER FILE(S) FROM DRIVE'S PREVIOUS VERSIONS

* * *

## About

This is a PowerShell script I made in order to quickly recover files, without having to do this manually. \
This uses the dll made available by [HiraokaHyperTools](https://github.com/HiraokaHyperTools) at this [repo](https://github.com/HiraokaHyperTools/LibEnumRemotePreviousVersion) \
Written by Benoît Flache, 2022.  

## Features

- Fetches the previous versions to find backups of one or more files
- Can print the most recent backup, or all of them
- Allows to directly copy the files to a specified location. The files are stored in a folder with the timestamp as its name.

## How to use

### Parameters

`-path` is the folder where you want to search the file.

`-name` is the files full name, or a file extension (*.txt), etc. The possibilities are listed under the `-include` section at [this doc](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem?view=powershell-7.2)

`-getfirst` if you only want the most recent backup of the given file.

`-copyto` is the folder where you want to copy the backups to.

`-recurse` if you want to search through the subdirectories. This will take longer time.

## Examples

```powershell
#get the last saved version of some file and copy it to the directory C:\target_dir
.\get-previousversions.ps1 -path "M:\path\to\source\dir" -name "some_excel.xlsx" -copyto "C:\target_dir" -printfirst

#print to the console all the backups where the file is found
.\get-previousversions.ps1 -path "M:\path\to\source\dir" -name "some_excel.xlsx"

#copy all the backups for the file "some_excel.xlsx" and recurse through the subdirectories as the location of the file has changed
.\get-previousversions.ps1 -path "M:\path\to\source\dir" -name "some_excel.xlsx" -copyto "C:\target_dir" -recurse
```

## Links

[origin repository](https://github.com/ouiouiallez/get-previousversions)\
[dll source repo](https://github.com/HiraokaHyperTools/LibEnumRemotePreviousVersion)

## Remarks

This is just some script I made because I couldn't find the vssadmin binary anymore, and I needed to quickly recover some employees lost files. This doesn't have advanced features at all, but I just figured I'd share it.

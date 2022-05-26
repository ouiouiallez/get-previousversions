<#
powershell script to scan the previous versions of a specific folder to find a specific file.
if you don't specify the copyto parameter, this will only print the locations where the file has been found.
if you do, this will copy the first (if you specified  getfirst) or all the matches to the location you give.
#>
param(
    [String]$path, # folder to search previous versions from
    [String]$name, # filename to search. for possibilities, check the -include parameter possible inputs in https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem?view=powershell-7.2
    [Switch]$getfirst, # only return the first occurence of the file from the backups
    [String]$copyto,
    [Switch]$recurse
)

#load DLL for pre execution
Add-Type -Path("C:\Workspace\powershell\previous\LibEnumRemotePreviousVersion.dll")
$snapshots = [LibEnumRemotePreviousVersion.PreviousVersionOnRemote]::Enum($path)

#parameter check
if(!$path){
    Write-Host "please specify a path."
    Exit
}
if(!$name){
    Write-Host "please specify a file name or a folder name"
    Exit
}
if(!(Test-Path $path)){
    Write-Host "path is not valid."
    Exit
}
if($copyto){
    if(!(test-path $copyto)){
        Write-Host "copyto destination not valid."
        Exit
    }
    if($copyto[-1] -ne "\"){$copyto += "\"}
}

############## MAIN ##############
#$snapshots = (.\TestApp.exe $path)
if(!$snapshots){
    Write-Host "sorry, no shapshots found.exiting"
    Exit
}
$result = @()
foreach($snap in $snapshots){
    $lookuppath = $path.Insert(3,$snap + "\")
    if($recurse){
        $childs = (get-childitem $lookuppath -include $name -Recurse -ErrorAction SilentlyContinue)
    }else{
        $childs = (get-childitem ($lookuppath + "\*") -include $name -ErrorAction SilentlyContinue)
    }    
    if(!$childs){continue}

    if($getfirst -and ($result.Length -ge 1)){break}
    foreach($child in $childs){
        $result += $lookuppath
    }
}
if(!$result){
    Write-Host "no matches found.exiting..."
    Exit
}
if(!$copyto){
    return $result
}else{
    foreach($lien in $result){
        #get the future folder name and the link to copy the file.
        $datearray = ((($lien -split "-")[1]) -split ".",3,"simplematch")
        [array]::Reverse($datearray)
        $datearray += ((($lien -split "-")[2]) -split "\",3,"simplematch")[0]
        $date = [string]$datearray
        $date = $date.Replace(" ","_")
        $file = $lien + "\" + $name

        #create the folder and copy the file.
        $pathtocopy = $copyto + $date
        if(!(Test-Path $pathtocopy)){mkdir $pathtocopy}        
        copy-item $file -Destination $pathtocopy
    }
}


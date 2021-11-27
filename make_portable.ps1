$env:https_proxy = "http://localhost:10809"


function DownloadFile {
    param ( [object]$Uri , [object]$OutFile , [object]$Hash )
    if ( -Not (Test-Path -Path $OutFile)) {
        Write-Output "Downloading $OutFile"
        Invoke-WebRequest -Uri $Uri -OutFile $OutFile
    }
    if ( -Not ([string]::IsNullOrEmpty($Hash))) {
        $FileHash = Get-FileHash -Path $OutFile -Algorithm SHA512
        if ( -Not ($FileHash.Hash -eq $Hash)) {
            Write-Output "$OutFile is corrupt. Delete it and try again"
            exit
        }
    }
}


function Expand7Zip {
    param ( [object]$Path , [object]$Destination )
    Write-Output "Extracting $Path"
    .\7za\7za.exe x "$Path" -o"$Destination" -y > $null
}


$Packages = Get-Content .\packages.json | ConvertFrom-Json

if ( -Not (Test-Path -Path downloads)) {
    New-Item -Path downloads -ItemType Directory -Force | Out-Null
}
Push-Location -Path .\downloads


DownloadFile -Uri $Packages.'7za'.url -OutFile $Packages.'7za'.name -Hash $Packages.'7za'.hash
DownloadFile -Uri $Packages.python.url -OutFile $Packages.python.name -Hash $Packages.python.hash
DownloadFile -Uri $Packages.vapoursynth.url -OutFile $Packages.vapoursynth.name -Hash $Packages.vapoursynth.hash
DownloadFile -Uri $Packages.vseditor.url -OutFile $Packages.vseditor.name -Hash $Packages.vseditor.hash
DownloadFile -Uri $Packages.vsrepogui.url -OutFile $Packages.vsrepogui.name -Hash $Packages.vsrepogui.hash
DownloadFile -Uri $Packages.vspreview.url -OutFile $Packages.vspreview.name
DownloadFile -Uri $Packages.lexpr.url -OutFile $Packages.lexpr.name -Hash $Packages.lexpr.hash
DownloadFile -Uri $Packages.getpip.url -OutFile $Packages.getpip.name


Expand-Archive -Path $Packages.'7za'.name -DestinationPath "7za" -Force
Expand-Archive -Path $Packages.vspreview.name -DestinationPath vspreview -Force
Expand-Archive -Path $Packages.vsrepogui.name -DestinationPath VSRepoGUI -Force
Expand7Zip -Path $Packages.vapoursynth.name -Destination ..\VapourSynth
Expand7Zip -Path $Packages.vseditor.name -Destination ..\VapourSynth\VapourSynthEditor
Expand7Zip -Path $Packages.lexpr.name -Destination ..\VapourSynth\vapoursynth64\plugins


if ( Test-Path -Path ..\VapourSynth\python*._pth ) {
    Remove-Item -Path ..\VapourSynth\python*._pth -Force
}
Expand-Archive -Path $Packages.python.name -DestinationPath ..\VapourSynth -Force
$PythonPth = (Get-Item ..\VapourSynth\python*._pth).Name
$PythonZip = (Get-Item ..\VapourSynth\python*._pth).BaseName + ".zip"
Set-Content -Path ..\VapourSynth\$PythonPth -Value "$PythonZip"
Add-Content -Path ..\VapourSynth\$PythonPth -Value "."
Add-Content -Path ..\VapourSynth\$PythonPth -Value "Lib\site-packages"
Add-Content -Path ..\VapourSynth\$PythonPth -Value "VapourSynthScripts"
Add-Content -Path ..\VapourSynth\$PythonPth -Value ""
Add-Content -Path ..\VapourSynth\$PythonPth -Value "import site"
Copy-Item -Path ..\sitecustomize.py -Destination ..\VapourSynth\ -Force

..\VapourSynth\python.exe .\get-pip.py --no-warn-script-location

$Requirements = Get-Item .\vspreview\vapoursynth-preview-$($Packages.vspreview.branch)\requirements.txt
Set-Content -Path $Requirements (Get-Content -Path $Requirements | Select-String -Pattern 'vapoursynth' -NotMatch )
..\VapourSynth\python.exe -m pip install -r $Requirements --no-warn-script-location


Copy-Item -Path .\vspreview\vapoursynth-preview-$($Packages.vspreview.branch)\vspreview -Destination ..\VapourSynth\Lib\site-packages\ -Recurse -Force
Copy-Item -Path .\VSRepoGUI\VSRepoGUI.exe -Destination ..\VapourSynth\ -Force
Copy-Item -Path ..\vsrepogui.json -Destination ..\VapourSynth\ -Force
Copy-Item -Path ..\vsedit.config -Destination ..\VapourSynth\VapourSynthEditor\ -Force
New-Item -Path ..\VapourSynth\VapourSynthScripts -ItemType Directory -Force | Out-Null

Remove-Item -Path .\7za -Recurse -Force
Remove-Item -Path .\vspreview -Recurse -Force
Remove-Item -Path .\VSRepoGUI -Recurse -Force

Pop-Location


Write-Output "Done."
Pause

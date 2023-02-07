# $env:https_proxy = "http://localhost:10809"


function DownloadFile {
    param ( [object]$Uri , [object]$OutFile , [object]$Hash )
    if ( -Not (Test-Path -Path $OutFile)) {
        Write-Output "Downloading $OutFile"
        Invoke-WebRequest -Uri $Uri -OutFile $OutFile
    }
    if ( -Not ([string]::IsNullOrEmpty($Hash))) {
        $FileHash = Get-FileHash -Path $OutFile -Algorithm SHA512
        if ( -Not ($FileHash.Hash -eq $Hash)) {
            Write-Output "$OutFile is broken. Delete it and try again"
            Pop-Location
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

if ( -Not (Test-Path -Path downloads) ) {
    New-Item -Path downloads -ItemType Directory -Force | Out-Null
}

Push-Location -Path .\downloads
DownloadFile -Uri $Packages.'7za'.url -OutFile $Packages.'7za'.name -Hash $Packages.'7za'.hash
# DownloadFile -Uri $Packages.python.url -OutFile $Packages.python.name -Hash $Packages.python.hash
DownloadFile -Uri $Packages.pythoncore.url -OutFile $Packages.pythoncore.name -Hash $Packages.pythoncore.hash
DownloadFile -Uri $Packages.pythonexe.url -OutFile $Packages.pythonexe.name -Hash $Packages.pythonexe.hash
DownloadFile -Uri $Packages.pythonlib.url -OutFile $Packages.pythonlib.name -Hash $Packages.pythonlib.hash
DownloadFile -Uri $Packages.vapoursynth.url -OutFile $Packages.vapoursynth.name -Hash $Packages.vapoursynth.hash
DownloadFile -Uri $Packages.vseditor.url -OutFile $Packages.vseditor.name -Hash $Packages.vseditor.hash
# DownloadFile -Uri $Packages.vsrepogui.url -OutFile $Packages.vsrepogui.name -Hash $Packages.vsrepogui.hash
DownloadFile -Uri $Packages.vspreview.url -OutFile $Packages.vspreview.name -Hash $Packages.vspreview.hash
DownloadFile -Uri $Packages.lexpr.url -OutFile $Packages.lexpr.name -Hash $Packages.lexpr.hash
# DownloadFile -Uri $Packages.getpip.url -OutFile $Packages.getpip.name
DownloadFile -Uri $Packages.ocr.url -OutFile $Packages.ocr.name -Hash $Packages.ocr.hash
DownloadFile -Uri $Packages.imwri.url -OutFile $Packages.imwri.name -Hash $Packages.imwri.hash
DownloadFile -Uri $Packages.subtext.url -OutFile $Packages.subtext.name -Hash $Packages.subtext.hash
DownloadFile -Uri $Packages.vsstubs.url -OutFile $Packages.vsstubs.name
Pop-Location


if ( -Not (Test-Path -Path VapourSynth) ) {
    New-Item -Path VapourSynth -ItemType Directory -Force | Out-Null
}
# Expand-Archive -Path .\downloads\$($Packages.python.name) -DestinationPath .\VapourSynth -Force
$VapourSynthPath = (Get-Item .\VapourSynth).FullName
Start-Process -Wait -FilePath msiexec -ArgumentList /a, (Get-Item .\downloads\$($Packages.pythoncore.name)).FullName, /qn, TARGETDIR=$VapourSynthPath
Start-Process -Wait -FilePath msiexec -ArgumentList /a, (Get-Item .\downloads\$($Packages.pythonexe.name)).FullName, /qn, TARGETDIR=$VapourSynthPath
Start-Process -Wait -FilePath msiexec -ArgumentList /a, (Get-Item .\downloads\$($Packages.pythonlib.name)).FullName, /qn, TARGETDIR=$VapourSynthPath
# $PythonVersion = (Get-Item .\VapourSynth\python*._pth).BaseName
# $PythonEmbeddedPth = $PythonVersion + "._pth"
# $PythonPth = $PythonVersion + ".pth"
# Move-Item -Path .\VapourSynth\$PythonEmbeddedPth -Destination .\VapourSynth\$PythonPth -Force
# Set-Content -Path .\VapourSynth\$PythonPth -Value (Get-Content -Path .\pythonXX.pth -Raw).Replace("pythonXX", $PythonVersion)
# Move-Item -Path .\VapourSynth\python.cat -Destination .\VapourSynth\DLLs\ -Force
# Move-Item -Path .\VapourSynth\*.pyd -Destination .\VapourSynth\DLLs\ -Force
# Move-Item -Path .\VapourSynth\*.dll -Destination .\VapourSynth\DLLs\ -Force
# Move-Item -Path .\VapourSynth\DLLs\python*.dll -Destination .\VapourSynth\ -Force
# Move-Item -Path .\VapourSynth\DLLs\vcruntime*.dll -Destination .\VapourSynth\ -Force
Copy-Item -Path .\sitecustomize.py -Destination .\VapourSynth\Lib\site-packages\ -Force
Copy-Item -Path .\vsscripts.pth -Destination .\VapourSynth\ -Force


Push-Location -Path downloads
Expand-Archive -Path $Packages.'7za'.name -DestinationPath "7za" -Force
Expand-Archive -Path $Packages.vspreview.name -DestinationPath vspreview -Force
# Expand-Archive -Path $Packages.vsrepogui.name -DestinationPath VSRepoGUI -Force
Expand-Archive -Path $Packages.vsstubs.name -DestinationPath vsstubs -Force
Expand-Archive -Path $Packages.vapoursynth.name -Destination ..\VapourSynth -Force
Expand7Zip -Path $Packages.vseditor.name -Destination ..\VapourSynth\
Expand7Zip -Path $Packages.lexpr.name -Destination ..\VapourSynth\vapoursynth64\plugins\
Expand7Zip -Path $Packages.ocr.name -Destination ..\VapourSynth\vapoursynth64\coreplugins\
Expand7Zip -Path $Packages.imwri.name -Destination ..\VapourSynth\vapoursynth64\coreplugins\
Expand-Archive -Path $Packages.subtext.name -DestinationPath subtext -Force
Copy-Item -Path .\subtext\x64\subtext.dll -Destination ..\VapourSynth\vapoursynth64\coreplugins\ -Force
Pop-Location


# .\VapourSynth\python.exe .\downloads\get-pip.py --no-warn-script-location
.\VapourSynth\python.exe -m ensurepip
$Requirements = Get-Item .\downloads\vspreview\vapoursynth-preview-$($Packages.vspreview.branch)\requirements.txt
Set-Content -Path $Requirements (Get-Content -Path $Requirements | Select-String -Pattern 'vapoursynth' -NotMatch )
.\VapourSynth\python.exe -m pip install -r $Requirements --no-warn-script-location
.\VapourSynth\python.exe -m pip install -r .\requirements.txt --no-warn-script-location
.\VapourSynth\python.exe -m pip install .\downloads\vsstubs\VapourSynth-Plugins-Stub-Generator-$($Packages.vsstubs.branch)\vsstubs\ --no-warn-script-location
.\VapourSynth\python.exe -m vsstubs install


Move-Item -Path .\VapourSynth\vapoursynth.cp311-win_amd64.pyd -Destination .\VapourSynth\Lib\site-packages\ -Force
Copy-Item -Path .\downloads\vspreview\vapoursynth-preview-$($Packages.vspreview.branch)\vspreview -Destination .\VapourSynth\Lib\site-packages\ -Recurse -Force
# Copy-Item -Path .\downloads\VSRepoGUI\VSRepoGUI.exe -Destination .\VapourSynth\ -Force
Copy-Item -Path .\vsrepogui.json -Destination .\VapourSynth\ -Force
Copy-Item -Path .\vsedit.config -Destination .\VapourSynth\ -Force
New-Item -Path .\VapourSynth\VapourSynthScripts -ItemType Directory -Force | Out-Null

.\VapourSynth\python.exe fix-python-path.py VapourSynth\Scripts

Push-Location -Path downloads
Remove-Item -Path 7za -Recurse -Force
Remove-Item -Path vspreview -Recurse -Force
# Remove-Item -Path VSRepoGUI -Recurse -Force
Remove-Item -Path vsstubs -Recurse -Force
Remove-Item -Path subtext -Recurse -Force
Pop-Location

# Remove some extra files we don't need.
Remove-Item -Path .\VapourSynth\*.msi  # msiexec will copy all .msi files here
Remove-Item -Path .\VapourSynth\LICENSE.txt, .\VapourSynth\NEWS.txt
Remove-Item -Path .\VapourSynth\setup.py, .\VapourSynth\MANIFEST.in
Remove-Item -Path .\VapourSynth\VapourSynth_portable.egg-info -Recurse
Remove-Item -Path .\VapourSynth\vapoursynth.*.pyd
Remove-Item -Path .\VapourSynth\README, .\VapourSynth\CHANGELOG, .\VapourSynth\LICENSE
Remove-Item -Path .\VapourSynth\vsedit.ico, .\VapourSynth\vsedit.svg
Remove-Item -Path .\VapourSynth\share -Recurse  # share\man\man1\ttx.1

# Prepare VapourSynth-9999.dist-info
$DistinfoDir = ".\VapourSynth\Lib\site-packages\VapourSynth-9999.dist-info"
New-Item -Path $DistinfoDir -ItemType Directory -Force | Out-Null
Copy-Item -Path .\METADATA -Destination $DistinfoDir -Force

Write-Output "Done."
Pause

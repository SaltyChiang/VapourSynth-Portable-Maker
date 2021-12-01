Run `make_portable.ps1` in Powershell to build a PORTABLE VapourSynth with vseditor-mod and vspreview embedded.

*If you need to use your proxy, uncomment the first line and set it to porper value.*

You need to put your VapourSynth script module file (\*.py) to `VapourSynth\VapourSynthScripts`, and your filter binary file (\*.dll) to `VapourSynth\vapoursynth64\plugins`.

**vseditor** locates at
```powershell
VapourSynth\VapourSynthEditor\vsedit.exe
```


Run such a command to preview *.vpy with **vspreview**：
```powershell
VapourSynth\python.exe -m vspreview sample.vpy
```
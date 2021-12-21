Run `make_portable.ps1` in Powershell to build a **PORTABLE** [**VapourSynth-Classic**](https://github.com/AmusementClub/vapoursynth-classic) with [`vseditor-mod`](https://github.com/YomikoR/VapourSynth-Editor) and [`vspreview`](https://github.com/AkarinVS/vapoursynth-preview) embedded.

*If you need to use your proxy, uncomment the first line and set it to porper value.*

You need to put your VapourSynth script module file (\*.py) in `VapourSynth\VapourSynthScripts`, and your filter binary file (\*.dll) in `VapourSynth\vapoursynth64\plugins`.

If you want to check if VapourSynth and `vspreview` are installed properly, you can open root directory in VSCode and press `F5` to launch **`vspreview`**, or just run the command  below:
```powershell
VapourSynth\python.exe -m vspreview test.vpy
```

**`vseditor`** locates at
```powershell
VapourSynth\VapourSynthEditor\vsedit.exe
```
Run `make_portable.ps1` in Powershell to build a **PORTABLE** [**VapourSynth**](https://github.com/vapoursynth/vapoursynth) with [`vseditor-mod`](https://github.com/YomikoR/VapourSynth-Editor) and [`vspreview-mod`](https://github.com/AkarinVS/vapoursynth-preview) embedded.

*If you need to use your proxy, uncomment the first line and set it to proper value.*

You need to put your VapourSynth script module file (\*.py) in `VapourSynth\vapoursynth64\scripts`, and your filter binary file (\*.dll) in `VapourSynth\vapoursynth64\plugins`.

To check if VapourSynth and `vspreview` are installed properly, you can open the root directory in VSCode and press `F5` to launch **`vspreview`**, or just run the command  below:
```powershell
VapourSynth\python.exe -m vspreview test.vpy
```
a gray gradiants map should be shown.

**`vseditor`** locates at `VapourSynth\VapourSynthEditor\vsedit.exe`, double clik to execute it and content of `test.vpy` will be shown if everything is correctly installed.

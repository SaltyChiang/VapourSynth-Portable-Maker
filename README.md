`7za.exe`来自[官网](https://www.7-zip.org/a/7z1900-extra.7z)，由于是7z打包因此只能直接附上二进制文件。

使用powershell运行`make_portable.ps1`即可构建带有vspreview和vseditor的VapourSynth包。

*需要使用代理的同学将脚本第一句去掉注释，并更改为自己的代理地址。*

运行完成后需要自行将脚本文件(.py)置于`VapourSynth\VapourSynthScripts`，滤镜文件(*.dll)置于`VapourSynth\vapoursynth64\plugins`。

**vseditor**位于：
```
VapourSynth\VapourSynthEditor\vsedit.exe
```


运行以下命令来使用**vspreview**：
```
VapourSynth\python.exe -m vsp sample.vpy
```

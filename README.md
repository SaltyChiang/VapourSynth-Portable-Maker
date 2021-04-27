使用powershell运行`make_portable.ps1`即可构建带有vspreview和vseditor的VapourSynth包。

*需要使用代理可将脚本第一句去掉注释，并更改为自己的代理地址。*

运行完成后需要自行将VS脚本文件(\*.py)置于`VapourSynth\VapourSynthScripts`，滤镜文件(\*.dll)置于`VapourSynth\vapoursynth64\plugins`。

**vseditor**位于：
```python
VapourSynth\VapourSynthEditor\vsedit.exe
```


运行以下命令来使用**vspreview**：
```python
VapourSynth\python.exe -m vspreview sample.vpy
```

import vapoursynth as vs
from vapoursynth import core

clip = core.std.BlankClip(format=vs.GRAY8, width=1024)
clip.set_output()

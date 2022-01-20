import vapoursynth as vs
from vapoursynth import core

clip = core.std.BlankClip(format=vs.GRAY8, width=1024).akarin.Expr("X 4 /", vs.GRAY8)
clip.set_output()

# This script fixes hardcoded path to python.exe in pip-generated script launchers
import re, sys, glob

shebang_prefix = b'#!<launcher_dir>\\..\\'
regexp = rb'#![^\r\n]*(pythonw?\.exe)'

for exe in glob.glob(sys.argv[1] + "/*.exe"):
    print('patching %s' % exe)
    data = open(exe, 'rb').read()

    data = re.sub(regexp, lambda x:shebang_prefix + x.group(1) + b'\n'*(len(x.group()) - len(x.group(1)) - len(shebang_prefix)), data)

    with open(exe, 'wb') as f:
        f.write(data)

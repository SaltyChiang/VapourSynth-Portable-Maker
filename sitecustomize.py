import site
import sys

site.ENABLE_USER_SITE = False
local_path = [""]
for path in sys.path:
    if site.USER_SITE not in path:
        local_path.append(path)
sys.path = local_path

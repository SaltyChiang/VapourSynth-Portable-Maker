import site
import sys

site.ENABLE_USER_SITE = None
if site.USER_SITE in sys.path:
    sys.path.remove(site.USER_SITE)
sys.path.insert(0, "")

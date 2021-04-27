import site
import sys

site.ENABLE_USER_SITE = None
sys.path.remove(site.USER_SITE)
sys.path.insert(0, "")

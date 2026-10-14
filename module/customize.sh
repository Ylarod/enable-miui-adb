# shellcheck shell=ash
# Sourced by the KernelSU installer. Do not call `exit` here.

SKIPUNZIP=0

ui_print "- Enable MIUI ADB"

if [ ! -d /data/data/com.miui.securitycenter ]; then
  ui_print "! com.miui.securitycenter not found, this module only works on MIUI / HyperOS"
fi

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/action.sh" 0 0 0755

ui_print "- Installed. Tap the Action button in the manager to apply."

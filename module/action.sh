#!/system/bin/sh
# Entry point of this one-shot script.
# - KernelSU manager with script support: run directly from the module store, nothing is installed.
# - Older managers / Magisk: installed as a module, run by tapping the Action button.
# - Standalone as root: su -c sh action.sh
#
# Parameters (see params.json), passed as environment variables:
#   KSU_PARAM_ENABLE_FASTBOOT  true/false, default true
#
# Exit codes: 0 = done, 2 = not applicable to this device, other = failure.

echo "------enable_miui_adb------"

XML_FILE=/data/data/com.miui.securitycenter/shared_prefs/remote_provider_preferences.xml
if [ ! -f "$XML_FILE" ]; then
    echo "! $XML_FILE not found, is this a MIUI / HyperOS device?"
    exit 2
fi

echo "1. Enable USB debugging (Security settings)"
if [ "$(getprop persist.security.adbinput)" != "1" ]; then
    setprop persist.security.adbinput 1
fi

if [ "${KSU_PARAM_ENABLE_FASTBOOT:-true}" = "true" ]; then
    echo "2. Enable Fastboot"
    if [ "$(getprop persist.fastboot.enable)" != "1" ]; then
        setprop persist.fastboot.enable 1
    fi
else
    echo "2. Enable Fastboot (skipped)"
fi

echo "Now modify $XML_FILE"

TMP_FILE="$XML_FILE.ksu.tmp"

# Rewrite the file in place (keeps its inode, so owner, mode and SELinux context stay intact;
# `sed -i` would replace it with a new root-owned file).
apply_sed() {
    sed "$1" "$XML_FILE" > "$TMP_FILE" && cat "$TMP_FILE" > "$XML_FILE"
    rm -f "$TMP_FILE"
}

# set_bool <name> <value>: update the boolean in place, or insert it before </map>
set_bool() {
    if grep -q "name=\"$1\"" "$XML_FILE"; then
        echo "Find $1, setting to $2"
        apply_sed "/name=\"$1\"/s/value=\"[a-z]*\"/value=\"$2\"/"
    else
        echo "Cannot find $1, inserting..."
        apply_sed "s#</map>#    <boolean name=\"$1\" value=\"$2\" />\n</map>#"
    fi
    grep "name=\"$1\"" "$XML_FILE"
}

echo "3. Enable Installation via USB"
set_bool security_adb_install_enable true

echo "4. Disable install intercept"
set_bool permcenter_install_intercept_enabled false

PID=$(pidof com.miui.securitycenter.remote)
[ -n "$PID" ] && kill -9 $PID

echo "All done!"

#!/system/bin/sh
# Executed when the user taps the Action button in the KernelSU / Magisk manager.
# Can also be run standalone as root: su -c sh action.sh

echo "------enable_miui_adb------"

echo "1. Enable USB debugging (Security settings)"
if [ "$(getprop persist.security.adbinput)" != "1" ]; then
    setprop persist.security.adbinput 1
fi

echo "2. Enable Fastboot"
if [ "$(getprop persist.fastboot.enable)" != "1" ]; then
    setprop persist.fastboot.enable 1
fi

XML_FILE=/data/data/com.miui.securitycenter/shared_prefs/remote_provider_preferences.xml
if [ ! -f "$XML_FILE" ]; then
    echo "! $XML_FILE not found, is this a MIUI / HyperOS device?"
    exit 1
fi
echo "Now modify $XML_FILE"

# set_bool <name> <value>: update the boolean in place, or insert it before </map>
set_bool() {
    if grep -q "name=\"$1\"" "$XML_FILE"; then
        echo "Find $1, setting to $2"
        sed -i "/name=\"$1\"/s/value=\"[a-z]*\"/value=\"$2\"/" "$XML_FILE"
    else
        echo "Cannot find $1, inserting..."
        sed -i "s#</map>#    <boolean name=\"$1\" value=\"$2\" />\n</map>#" "$XML_FILE"
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

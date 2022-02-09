echo "------enable_miui_adb------"

echo "1. Enable USB debugging (Security settings)"
setprop presist.security.adbinput 1
getprop presist.security.adbinput

echo "2. Enable Fastboot"
setprop presist.fastboot.enable 1
getprop presist.fastboot.enable

XML_FILE=/data/data/com.miui.securitycenter/shared_prefs/remote_provider_preferences.xml
echo "Now modify $XML_FILE"

echo "3. Enable Installation via USB"
LINE_NO=`grep -n "security_adb_install_enable" $XML_FILE | awk -F: '{print $1}'`
if [ $LINE_NO > 0 ]
then
    echo "Find security_adb_install_enable at line $LINE_NO"
    sed -i '/security_adb_install_enable/s/false/true/' $XML_FILE
    grep "security_adb_install_enable" $XML_FILE
else
    echo "Cannot find security_adb_install_enable, inserting..."
    sed -i '3a \ \ \ \ <boolean name="security_adb_install_enable" value="true" />' $XML_FILE
    grep "security_adb_install_enable" $XML_FILE
fi

echo "4. Disable install intercept"
LINE_NO=`grep -n "permcenter_install_intercept_enabled" $XML_FILE | awk -F: '{print $1}'`
if [ $LINE_NO > 0 ]
then
    echo "Find permcenter_install_intercept_enabled at line $LINE_NO"
    sed -i '/permcenter_install_intercept_enabled/s/false/true/' $XML_FILE
    grep "permcenter_install_intercept_enabled" $XML_FILE
else
    echo "Cannot find permcenter_install_intercept_enabled, inserting..."
    sed -i '3a \ \ \ \ <boolean name="permcenter_install_intercept_enabled" value="false" />' $XML_FILE
    grep "permcenter_install_intercept_enabled" $XML_FILE
fi

kill -9 $(pidof com.miui.securitycenter.remote)

echo "All done!"

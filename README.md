# enable-miui-adb
Enable "adb install" for miui without login and sim

## Usage

```shell
git clone https://github.com/Ylarod/enable-miui-adb.git
adb push enable-miui-adb/enable_miui_adb.sh /data/local/tmp
adb shell chmod +x /data/local/tmp/enable_miui_adb.sh
adb shell su -c /data/local/tmp/enable_miui_adb.sh

# for clean
rm -rf enable-miui-adb/
adb shell rm /data/local/tmp/enable_miui_adb.sh
```

## Thanks

https://www.leadroyal.cn/p/1189/

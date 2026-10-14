<p align="center"><img src="assets/icon.png" width="96" alt="icon"></p>

# enable-miui-adb

Enable "adb install" for MIUI / HyperOS without Xiaomi account login and SIM card.

Requires ROOT permission.

What it does:

1. Enable USB debugging (Security settings) — `persist.security.adbinput=1`
2. Enable Fastboot — `persist.fastboot.enable=1`
3. Enable "Install via USB" — `security_adb_install_enable=true` in Security Center preferences
4. Disable the install intercept — `permcenter_install_intercept_enabled=false`

## Usage

### KernelSU / Magisk module

1. Install the module from [KernelSU Modules](https://modules.kernelsu.org/module/enable_miui_adb)
   or download the ZIP from [Releases](https://github.com/Ylarod/enable-miui-adb/releases).
2. Tap the **Action** button of the module in the manager. No reboot is needed.

### Shell

```shell
curl https://raw.githubusercontent.com/Ylarod/enable-miui-adb/main/module/action.sh > /data/local/tmp/enable_miui_adb.sh
su -c sh /data/local/tmp/enable_miui_adb.sh
rm /data/local/tmp/enable_miui_adb.sh
```

## Releasing a new version

1. Bump `version` and `versionCode` in `module/module.prop` (versionCode must increase).
2. Commit, then tag and push: `git tag v1.0.1 && git push origin v1.0.1`

The release workflow zips `module/` and publishes an immutable release, which KernelSU Modules
picks up automatically.

## Thanks

https://www.leadroyal.cn/p/1189/

## License

[MIT](LICENSE)

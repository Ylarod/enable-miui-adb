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

### KernelSU manager (one-shot script)

This is a one-shot script entry in [KernelSU Modules](https://modules.kernelsu.org/module/enable_miui_adb).
Open it in the manager's module store and tap **Run**: the script runs once, nothing is installed and no reboot
is needed.

Options:

- **Also enable fastboot** (`ENABLE_FASTBOOT`, default on): also set `persist.fastboot.enable=1`.

### Older KernelSU managers / Magisk

1. Install the ZIP from the module store or from [Releases](https://github.com/Ylarod/enable-miui-adb/releases).
2. Tap the **Action** button of the module in the manager. No reboot is needed.
   The module can be uninstalled afterwards.

### Shell

```shell
curl https://raw.githubusercontent.com/Ylarod/enable-miui-adb/main/module/action.sh > /data/local/tmp/enable_miui_adb.sh
su -c sh /data/local/tmp/enable_miui_adb.sh
# Skip fastboot: su -c 'KSU_PARAM_ENABLE_FASTBOOT=false sh /data/local/tmp/enable_miui_adb.sh'
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

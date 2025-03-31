OpenSync OpenWrt Template
=========================

Reference/template vendor layer implementation for OpenWrt-based targets.

This vendor layer provides example target implementations for the following
reference boards:

* FILOGIC830-AX6000 - gateway and extender mode (MTK WiFi 6 reference board)
* FILOGIC830-AX8400 - gateway and extender mode (MTK WiFi 6E reference board)
* FILOGIC880-BE19000 - gateway and extender mode (MTK WiFi 7 reference board)

#### Reference software versions

* Components and versions:

    | Component                          | Version     |
    |------------------------------------|-------------|
    | OpenSync core                      | 6.4.x       |
    | OpenSync vendor/openwrt-template   | 6.4.x       |
    | OpenSync platform/cfg80211         | 6.4.x       |
    | OpenWrt SDK                        | 21.02       |


#### Reference device information

* Brand/Model: FILOGIC830-AX6000
* Chipset: MT7986 (Platform SoC)
* WLAN Hardware: MediaTek MT7986 (AP SoC for 2.4G/5G)

* Interfaces:

    | Interface     | Description                                       |
    |---------------|---------------------------------------------------|
    | eth0          | LAN ethernet interface                            |
    | eth1          | WAN ethernet interface                            |
    | br-home       | LAN bridge                                        |
    | phy0          | 2.4G wireless phy interface                       |
    | phy1          | 5G wireless phy interface                         |
    | bhaul-ap-XX   | 2.4G/5G backhaul VAPs                             |
    | home-ap-XX    | 2.4G/5G home VAPs                                 |
    | onboard-ap-XX | 2.4G/5G onboard VAPs                              |
    | bhaul-sta-XX  | 2.4G/5G station interfaces (extender only)        |

* Brand/Model: FILOGIC830-AX8400
* Chipset: MT7986 (Platform SoC)
* WLAN Hardware: MediaTek MT7986 (AP SoC for 2.4G/6G) + MT7915 (PCIE for 5G)

* Interfaces:

    | Interface     | Description                                       |
    |---------------|---------------------------------------------------|
    | eth0          | LAN ethernet interface                            |
    | eth1          | WAN ethernet interface                            |
    | br-home       | LAN bridge                                        |
    | phy0          | 5G wireless phy interface                         |
    | phy1          | 2.4G wireless phy interface                       |
    | phy2          | 6G wireless phy interface                         |
    | bhaul-ap-XX   | 2.4G/5G/6G backhaul VAPs                          |
    | home-ap-XX    | 2.4G/5G/6G home VAPs                              |
    | onboard-ap-XX | 2.4G/5G/6G onboard VAPs                           |
    | bhaul-sta-XX  | 2.4G/5G/6G station interfaces (extender only)     |

* Brand/Model: FILOGIC880-BE19000
* Chipset: MT7988 (Platform SoC)
* WLAN Hardware: MediaTek MT7996 Eagle (AP SoC for 2.4G/5G/6G)

* Interfaces:

    | Interface     | Description                                       |
    |---------------|---------------------------------------------------|
    | eth0          | LAN ethernet interface                            |
    | eth1          | WAN ethernet interface                            |
    | lan0          | LAN ethernet interface                            |
    | lan1          | LAN ethernet interface                            |
    | lan2          | LAN ethernet interface                            |
    | lan3          | LAN ethernet interface                            |
    | br-home       | LAN bridge                                        |
    | phy0          | 2.4G wireless phy interface                       |
    | phy1          | 5G wireless phy interface                         |
    | phy2          | 6G wireless phy interface                         |
    | ra1/rai1/rax1 | 2.4G/5G/6G backhaul VAPs                          |
    | ra3/rai3/rax3 | 2.4G/5G/6G home VAPs                              |
    | ra2/rai2/rax2 | 2.4G/5G/6G onboard VAPs                           |
    | apcli0/apclii0/apclix0  | 2.4G/5G/6G station interfaces (extender only)     |


OpenSync root dir
-----------------

OpenSync build system requires a certain directory structure in order to ensure
modularity. Key components are:

* OpenSync core:                  `${OPENSYNC_ROOT}/core`
* OpenSync cfg80211 platform:     `${OPENSYNC_ROOT}/platform/cfg80211`
* OpenSync vendor layer template: `${OPENSYNC_ROOT}/vendor/openwrt-template`
* service provider layer:         `${OPENSYNC_ROOT}/service-provider/local`

Follow these steps to populate the `${OPENSYNC_ROOT}` directory:

```
$ git clone --branch osync_6.4.0 https://github.com/plume-design/opensync.git ${OPENSYNC_ROOT}/core
$ git clone --branch osync_6.4.0 https://github.com/plume-design/opensync-platform-cfg80211.git ${OPENSYNC_ROOT}/platform/cfg80211
$ git clone --branch osync_6.4.0 https://github.com/plume-design/opensync-vendor-openwrt-template.git ${OPENSYNC_ROOT}/vendor/openwrt-template
$ git clone --branch osync_6.4.0 https://github.com/plume-design/opensync-service-provider-local.git ${OPENSYNC_ROOT}/service-provider/local
$ mkdir ${OPENSYNC_ROOT}/3rdparty
```

The resulting layout should be as follows:

```
${OPENSYNC_ROOT}
├── 3rdparty
│   └── ...
├── core
│   ├── 3rdparty -> ../3rdparty
│   ├── build
│   ├── doc
│   ├── futs
│   ├── interfaces
│   ├── kconfig
│   ├── Makefile
│   ├── ovsdb
│   ├── platform -> ../platform
│   ├── README.md
│   ├── rootfs
│   ├── service-provider -> ../service-provider
│   ├── src
│   └── vendor -> ../vendor
├── platform
│   └── cfg80211
├── service-provider
│   └── local
└── vendor
    └── openwrt-template
```


Setting up OpenWrt
------------------

To integrate the OpenSync package into OpenWrt, follow the steps below:

1. Get OpenWrt 21.02 source code from Git server
```
git clone --branch openwrt-21.02 https://git.openwrt.org/openwrt/openwrt.git
cd openwrt; git checkout b119562a0753c282f3cdab0912810bdbe71a0f68; cd -;
```

2. Get OpenWrt master source code from Git server
```
git clone --branch master https://git.openwrt.org/openwrt/openwrt.git mac80211_package
cd mac80211_package; git checkout 5c7e4a9d2e25d5ecc33c3c2650e4f954936c9c69; cd -;
```

3. Get mtk-openwrt-feeds source code
```
git clone --branch master https://git01.mediatek.com/openwrt/feeds/mtk-openwrt-feeds
cd mtk-openwrt-feeds; git checkout aa392b3498c8579b07afeed4477a6a1b2f042a44; cd -;
```

4. Change to the `openwrt` folder
```
cp -rf mtk-openwrt-feeds/autobuild_mac80211_release openwrt
cd openwrt; mv autobuild_mac80211_release autobuild
```

5. Add MTK feed
```
echo "src-git mtk_openwrt_feed https://git01.mediatek.com/openwrt/feeds/mtk-openwrt-feeds" >> feeds.conf.default
```

6. Edit `autobuild/feeds.conf.default-21.02`
```
src-git packages https://git.openwrt.org/feed/packages.git^f01f54e
src-git luci https://git.openwrt.org/project/luci.git^d30ab74
src-git routing https://git.openwrt.org/feed/routing.git^2c21c16
src-git mtk_openwrt_feed https://git01.mediatek.com/openwrt/feeds/mtk-openwrt-feeds^aa392b3
```

7. Copy OpenSync related overlays (package, dependencies, patches) to the `openwrt` directory

8. Append OpenWrt `.config` for OpenSync
```
echo "CONFIG_PACKAGE_opensync=y" >> openwrt.config
echo "CONFIG_OPENSYNC_TARGET=FILOGIC830-AX6000/FILOGIC830-AX8400" >> openwrt.config
```


Build
-----

1. Run AX6000/AX8400 auto build script (APSoC: MT7986A/B, PCIE: MT7915A/D, MT7916)
```
./autobuild/mt7986_mac80211/lede-branch-build-sanity.sh
```

2. Further builds (after the first full build)
```
./scripts/feeds update –a
make V=s
```


Image install
-------------

Get your image in the `openwrt/bin/targets/mediatek/mt7986` directory for FILOGIC-AX6000 and FILOGIC-AX8400:

* FILOGIC-AX6000 with 2.5G WAN:

`openwrt-mediatek-mt7986-mt7986b-ax6000-2500wan-spim-nand-rfb-squashfs-sysupgrade`

* FILOGIC-AX6000 without 2.5G WAN:

`openwrt-mediatek-mt7986-mt7986b-ax6000-spim-nand-rfb-squashfs-sysupgrade`

* FILOGIC-AX8400 with 2.5G WAN:

`openwrt-mediatek-mt7986-mt7986a-ax6000-2500wan-spim-nand-rfb-squashfs-sysupgrade.bin`

* FILOGIC-AX8400 without 2.5G WAN:

`openwrt-mediatek-mt7986-mt7986a-ax6000-spim-nand-rfb-squashfs-sysupgrade.bin`

Get your image in the `bin/targets/mediatek/mt7988` directory for FILOGIC880-BE19000:

* FILOGIC880-BE19000:

`openwrt-mediatek-mt7988-mediatek_mt7988a-dsa-10g-spim-nand-squashfs-sysupgrade.bin`

#### Full image reflash

Copy the `xxx.bin` file to the TFTP server boot directory.
Power on the device and follow the steps below to flash image in U-Boot:

1. Select `2. Upgrade firmware`
```
  *** U-Boot Boot Menu ***
      1. Startup system (Default)
      2. Upgrade firmware
      3. Upgrade ATF BL2
      4. Upgrade ATF FIP
      5. Upgrade single image
      6. Load image
      7. Start Web failsafe
      0. U-Boot console
```

2. Select `Y`
```
Run image after upgrading? (Y/n):
```

3. Select `0 - TFTP client (Default)`
```
Available load methods:
    0 - TFTP client (Default)
    1 - Xmodem
    2 - Ymodem
    3 - Kermit
    4 - S-Record
```

4. Set the IP address and server IP using the TFTP process:
```
Input U-Boot's IP address: 192.168.1.1
Input TFTP server's IP address: 192.168.1.10
Input IP netmask: 255.255.255.0
Input file name: xxx.bin
```

#### Firmware upgrade

Image install utilizes the standard OpenWrt `sysupgrade`, for example:

```
$ sysupgrade -v <image-file>
```


Run
---

OpenSync will be automatically started at startup -- see `/etc/rc.d/S961opensync`.

To manually start, stop, or restart OpenSync, use the following commands:

```
$ /etc/init.d/opensync start|stop|restart
```


Device access
-------------

The preferred way to access the reference device is through the serial console.

SSH access is also available on all interfaces:
* Username: `osync`
* Password: `osync123`


OpenSync resources
------------------

For further information please visit: https://www.opensync.io/

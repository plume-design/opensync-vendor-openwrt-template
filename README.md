OpenSync OpenWrt Template
=========================

Reference/template vendor layer implementation for OpenWrt-based targets.

This vendor layer template provides an example target implementation for the
Linksys MR8300 hardware.


#### Reference software versions

* Components and versions:

    | Component                          | Version     |
    |------------------------------------|-------------|
    | OpenSync core                      | 2.0.5       |
    | OpenSync vendor/openwrt-template   | 2.0.5       |
    | OpenSync platform/cfg80211         | 2.0.5       |
    | OpenWrt SDK                        | 19.07.6     |


#### Reference device information

* Brand/Model: Linksys MR8300
* Chipset: IPQ4019
* WLAN Hardware: Qualcomm Atheros IPQ4019, QCA9886

* Interfaces:

    | Interface     | Description                                       |
    |---------------|---------------------------------------------------|
    | eth0          | LAN ethernet interface                            |
    | eth1          | WAN ethernet interface                            |
    | br-lan        | LAN bridge                                        |
    | phy0          | 5G upper wireless phy interace                    |
    | phy1          | 2.4G wireless phy interace                        |
    | phy2          | 5G lower wireless phy interace                    |
    | bhaul-ap-XX   | 2.4G and 5G backhaul VAPs                         |
    | home-ap-XX    | 2.4G and 5G home VAPs                             |
    | onboard-ap-XX | 2.4G and 5G onboard VAPs                          |
    | bhaul-sta-XX  | 2.4G and 5G station interfaces (extender only)    |

For more information check [Linksys MR8300](https://openwrt.org/toh/linksys/mr8300)
in [OpenWrt Table of Hardware](https://openwrt.org/toh/start).
A very similar [Linksys EA8300](https://openwrt.org/toh/linksys/ea8300) can also be used.


Prerequisites
-------------

#### Build system requirements

* A Linux system with Docker

For building the firmware, it is recommended to use docker.
For additional information, refer to [opensync-sdk-openwrt/README.md](https://github.com/plume-design/opensync-sdk-openwrt/tree/osync_2.0.5#readme).

#### Environment variables

Downloaded source files will reside in two locations, separately for:
* OpenSync source code
* OpenWrt source code and packages

To simplify build commands, it is recommended to create the following
environment variables (assuming location of sources is `~/projects`):

```
export OPENSYNC_ROOT=~/projects/opensync
export OPENWRT_SDK_ROOT=~/projects/sdk/openwrt
```

Typically, the above two lines are added to `~/.bashrc` or an equivalent file.

The rest of the document assumes that these two variables are defined, therefore
these two locations are referred to as `${OPENSYNC_ROOT}` and `${OPENWRT_SDK_ROOT}`.


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
$ git clone --branch osync_2.0.5 https://github.com/plume-design/opensync.git ${OPENSYNC_ROOT}/core
$ git clone --branch osync_2.0.5 https://github.com/plume-design/opensync-platform-cfg80211.git ${OPENSYNC_ROOT}/platform/cfg80211
$ git clone --branch osync_2.0.5 https://github.com/plume-design/opensync-vendor-openwrt-template.git ${OPENSYNC_ROOT}/vendor/openwrt-template
$ git clone --branch osync_2.0.5 https://github.com/plume-design/opensync-service-provider-local.git ${OPENSYNC_ROOT}/service-provider/local
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


OpenWrt SDK
-----------

To obtain the OpenWrt SDK and the corresponding OpenSync overlay,
follow the steps below:

```
$ git clone --branch osync_2.0.5 https://github.com/plume-design/opensync-sdk-openwrt.git ${OPENWRT_SDK_ROOT}
$ cd ${OPENWRT_SDK_ROOT}
$ ./docker/dock-run make CONFIG=mr8300 prepare V=s
```

The layout after the first step (cloning), should be as follows:

```
${OPENWRT_SDK_ROOT}
├── config
│   ├── mr8300.mk
│   └── undefined.mk
├── contrib
│   ├── config
│   │   └── public-opensync
│   │       └── ...
│   ├── files
│   │   └── public-opensync
│   │       └── ...
│   └── patches
│       └── public-opensync
│           └── ...
├── docker
│   ├── Dockerfile
│   └── dock-run
├── Makefile
├── Makefile.mr8300.mk
├── ...
```

`contrib` directory contains the OpenSync-specific overlay.  
`config` contains the make parameters for the supported configuration(s).

The second step (running `make CONFIG=mr8300 prepare`), should add
`.cache.mr8300` and `build-mr8300` directories:

```
${OPENWRT_SDK_ROOT}
├── .cache.mr8300
│   └── openwrt
│          └── ...
├── build-mr8300
│   └── openwrt
│          └── ...
├── config
│   └── ...
├── contrib
│   └── ...
├── ...
```  

`.cache.mr8300` consists of cloned OpenWrt repositories with feeds installed.  
`build-mr8300/openwrt` is the working directory with both `contrib` overlay and `mr8300.config` applied.

At this point the `build-mr8300/openwrt` directory status corresponds to a standard OpenWrt build
with feeds installed and menuconfig done.

Note that `${OPENSYNC_ROOT}` has not been specified anywhere, so up to this point
OpenSync sources were not included.


Build
-----

The following command builds the firmware:

```
$ ./docker/dock-run make CONFIG=mr8300 OPENSYNC_SRC=${OPENSYNC_ROOT} compile V=s
```

To get your image in `${OPENWRT_SDK_ROOT}/build-mr8300/images` directory, run:

```
$ ./docker/dock-run make CONFIG=mr8300 OPENSYNC_SRC=${OPENSYNC_ROOT} image V=s
```


Image install
-------------

Image install utilizes the standard OpenWrt `sysupgrade`, for example:

```
$ cd /tmp
$ curl -O <image-url>  # image name ending with *-sysupgrade.bin
$ sysupgrade -n <image-file>
```

If the starting point is a brand new freshly unpacked device, a `*-factory.bin` image is necessary.
It needs to be uploaded via http://192.168.1.1:52000/fwupdate.html.


Run
---

OpenSync will be automatically started at startup -- see `/etc/rc.d/S90opensync`.

To manually stop OpenSync, use the following command:

```
$ /etc/init.d/opensync stop
```

When restarting, certain other services have to be restarted as well.
Use the following script to restart OpenSync:
```
$ /usr/opensync/bin/restart.sh
```


Device access
-------------

The preferred way to access the device is through the serial console.

SSH access is also available on all interfaces:
* Username: `osync`
* Password: `osync123`


OpenSync resources
------------------

For further information please visit: https://www.opensync.io/

#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
sed -i 's/192.168.1.1/192.168.31.1/g' package/base-files/files/bin/config_generate

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Add software sources -------------------------------
# Add software sources
echo "src-git kenzo https://github.com/kenzok8/openwrt-packages" >> feeds.conf.default
echo "src-git small https://github.com/kenzok8/small" >> feeds.conf.default
echo "src-git haibo https://github.com/haiibo/openwrt-packages" >> feeds.conf.default
echo "src-git liuran001 https://github.com/liuran001/openwrt-packages" >> feeds.conf.default
# ------------------------------- Add software sources ends -------------------------------

# ------------------------------- Update and install feeds -------------------------------
# Update and install feeds
./scripts/feeds update -a
./scripts/feeds install -a
# ------------------------------- Update and install feeds ends -------------------------------

# ------------------------------- Install luci applications -------------------------------
# Install luci applications
#./scripts/feeds install luci-app-accesscontrol
#./scripts/feeds install luci-app-bird1-ipv4
#./scripts/feeds install luci-app-bird1-ipv6
#./scripts/feeds install luci-app-arpbind
#./scripts/feeds install luci-app-autoreboot
#./scripts/feeds install luci-app-ddns
#./scripts/feeds install luci-app-ddns-go
#./scripts/feeds install luci-app-filetransfer
#./scripts/feeds install luci-app-firewall
#./scripts/feeds install luci-app-mwan3
#./scripts/feeds install luci-app-nlbwmon
#./scripts/feeds install luci-app-samba
#./scripts/feeds install luci-app-samba4
#./scripts/feeds install luci-app-ssr-plus
#./scripts/feeds install luci-app-syncdial
#./scripts/feeds install luci-app-turboacc
#./scripts/feeds install luci-app-upnp
#./scripts/feeds install luci-app-usb-printer
#./scripts/feeds install luci-app-vlmcsd
#./scripts/feeds install luci-app-vsftpd
#./scripts/feeds install luci-app-wol
#./scripts/feeds install luci-app-clash
#./scripts/feeds install luci-app-ramfree
#./scripts/feeds install luci-app-easymesh
#./scripts/feeds install luci-app-argon-config
#./scripts/feeds install luci-app-attendedsysupgrade
#./scripts/feeds install luci-app-docker
#./scripts/feeds install luci-app-fileassistant
#./scripts/feeds install luci-app-aria2
#./scripts/feeds install luci-app-passwall
#./scripts/feeds install luci-app-unblockmusic
#./scripts/feeds install luci-app-webadmin
#./scripts/feeds install luci-app-uhttpd
#./scripts/feeds install luci-app-update
#./scripts/feeds install luci-app-minidlna
# ------------------------------- Install luci applications ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Fix runc version error
# rm -rf ./feeds/packages/utils/runc/Makefile
# svn export https://github.com/openwrt/packages/trunk/utils/runc/Makefile ./feeds/packages/utils/runc/Makefile

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

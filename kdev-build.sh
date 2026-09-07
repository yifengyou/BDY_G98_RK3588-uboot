#!/bin/bash

set -ex

# clean
rm -rf output
mkdir -p output

# only spi
rm -f uboot.img arch/arm/dts/rk3588-evb.dtb
sed -i "s#BYD G98 Compiled By yifengyou.*#BYD G98 Compiled By yifengyou v$(date +%Y.%m.%d-%H:%M:%S)\";#" only-spi/rk3588-evb.dts
cp -a only-spi/rk3588-evb.dts arch/arm/dts/rk3588-evb.dts
cp -a only-spi/rk3588_defconfig configs/rk3588_defconfig
cp -a only-spi/spl.c common/spl/spl.c

./make.sh rk3588

dtc -I dtb -O dts arch/arm/dts/rk3588-evb.dtb -o only-spi/g98-uboot.dts
fdtdump u-boot.dtb >only-spi/u-boot.dts
ls -alh only-spi/g98-uboot.dts only-spi/u-boot.dts

./make.sh loader
ls -alh rk3588_spl*.bin
mv rk3588_spl_loader_v1.21.114.bin output/rk3588_spl_loader_v1.21.114_only-spi.bin

dd if=uboot.img of=output/uboot-g98_only-spi.img bs=2M count=1
dumpimage -l output/uboot-g98_only-spi.img
ls -alh output/uboot-g98_only-spi.img

# only emmc
rm -f uboot.img arch/arm/dts/rk3588-evb.dtb
sed -i "s#BYD G98 Compiled By yifengyou.*#BYD G98 Compiled By yifengyou v$(date +%Y.%m.%d-%H:%M:%S)\";#" only-emmc/rk3588-evb.dts
cp -a only-emmc/rk3588-evb.dts arch/arm/dts/rk3588-evb.dts
cp -a only-emmc/rk3588_defconfig configs/rk3588_defconfig
cp -a only-emmc/spl.c common/spl/spl.c
./make.sh rk3588

dtc -I dtb -O dts arch/arm/dts/rk3588-evb.dtb -o only-emmc/g98-uboot.dts
fdtdump u-boot.dtb >only-emmc/u-boot.dts
ls -alh only-emmc/g98-uboot.dts only-emmc/u-boot.dts

./make.sh loader
ls -alh rk3588_spl*.bin
mv rk3588_spl_loader_v1.21.114.bin output/rk3588_spl_loader_v1.21.114_only-emmc.bin

dd if=uboot.img of=output/uboot-g98_only-emmc.img bs=2M count=1
dumpimage -l output/uboot-g98_only-emmc.img
ls -alh output/uboot-g98_only-emmc.img

# show output
ls -alh output/*
sha256sum output/*
echo "All ok! All done!"

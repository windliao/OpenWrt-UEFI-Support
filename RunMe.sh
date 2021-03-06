#!/bin/sh
restore_patch() {
  patch -p0 -R < OpenWrt-UEFI-Support/Config-images.patch
  patch -p0 -R < OpenWrt-UEFI-Support/common.patch
  patch -p0 -R < OpenWrt-UEFI-Support/Image.patch
  patch -p0 -R < OpenWrt-UEFI-Support/tools.patch
}
if [ "$1" = "apply" ]; then
  restore_patch
  git pull OpenWrt-UEFI-Support
  patch -p0 < OpenWrt-UEFI-Support/Config-images.patch
  patch -p0 < OpenWrt-UEFI-Support/common.patch
  patch -p0 < OpenWrt-UEFI-Support/Image.patch
  patch -p0 < OpenWrt-UEFI-Support/tools.patch
  mv package/boot/grub2/Makefile package/boot/grub2/Makefile.bak
  cp -a OpenWrt-UEFI-Support/src/package/boot/grub2/* package/boot/grub2/
  cp -r OpenWrt-UEFI-Support/src/target/linux/x86/image/gen_image_efi.sh target/linux/x86/image/
  cp -r OpenWrt-UEFI-Support/src/tools/gptfdisk tools/
  cp -r OpenWrt-UEFI-Support/src/tools/popt tools/
elif [ "$1" = "restore" ]; then
  restore_patch
  rm -rf package/boot/grub2/grub2-efi package/boot/grub2/common.mk
  rm -rf tools/gptfdisk tools/popt
  rm -rf target/linux/x86/image/gen_image_efi.sh
  mv package/boot/grub2/Makefile.bak package/boot/grub2/Makefile
else
  echo "Please add parameter. Apply or Restore\n e.g: ./OpenWrt-UEFI-Support/RunMe.sh apply"
fi

#
# Copyright (C) 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := krait

ENABLE_CPUSETS := true

TARGET_NO_BOOTLOADER := true

# Inline kernel building
TARGET_KERNEL_CONFIG := B14CKB1RD_defconfig
TARGET_KERNEL_SOURCE := kernel/moto/shamu
BOARD_KERNEL_IMAGE_NAME := zImage-dtb

BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE :=  2048
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000

BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 Isecurity/selinux -Isecurity/selinux/include androidboot.selinux=permissive androidboot.hardware=shamu msm_rtb.filter=0x37 ehci-hcd.park=3 utags.blkdev=/dev/block/platform/msm_sdcc.1/by-name/utags utags.backup=/dev/block/platform/msm_sdcc.1/by-name/utagsBackup coherent_pool=8M

BOARD_MKBOOTIMG_ARGS := --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)

# Shader cache config options
# Maximum size of the  GLES Shaders that can be cached for reuse.
# Increase the size if shaders of size greater than 12KB are used.
MAX_EGL_CACHE_KEY_SIZE := 12*1024

# Maximum GLES shader cache size for each app to store the compiled shader
# binaries. Decrease the size if RAM or Flash Storage size is a limitation
# of the device.
MAX_EGL_CACHE_SIZE := 2048*1024

# Maximum dimension (width or height) of a virtual display that will be
# handled by the hardware composer
MAX_VIRTUAL_DISPLAY_DIMENSION := 2048

BOARD_EGL_CFG := device/moto/shamu/egl.cfg

BOARD_USES_ALSA_AUDIO := true

BOARD_SUPPORTS_SOUND_TRIGGER := true

# Wifi related defines
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_WLAN_DEVICE           := bcmdhd
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_AP      := "/vendor/firmware/fw_bcmdhd_apsta.bin"
WIFI_DRIVER_FW_PATH_STA     := "/vendor/firmware/fw_bcmdhd.bin"
WIFI_BUS := PCIE
#BOARD_USES_SECURE_SERVICES := true

TARGET_NO_RADIOIMAGE := true
TARGET_BOARD_PLATFORM := msm8084
TARGET_BOOTLOADER_BOARD_NAME := shamu
TARGET_NO_RPC := true

TARGET_BOARD_INFO_FILE := device/moto/shamu/board-info.txt

USE_OPENGL_RENDERER := true
VSYNC_EVENT_PHASE_OFFSET_NS := 2500000
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 0000000
TARGET_USES_ION := true
TARGET_HW_DISK_ENCRYPTION := false
TARGET_CRYPTFS_HW_PATH := device/moto/shamu/cryptfs_hw

# Enable dex-preoptimization to speed up first boot sequence
WITH_DEXPREOPT := false

TARGET_TOUCHBOOST_FREQUENCY := 1500
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16793600
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648
BOARD_OEMIMAGE_PARTITION_SIZE := 67108864
BOARD_USERDATAIMAGE_PARTITION_SIZE := 25253773312
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072

BOARD_CHARGER_ENABLE_SUSPEND := true

TARGET_RECOVERY_FSTAB = device/moto/shamu/fstab.shamu
# Ensure f2fstools are built
TARGET_USERIMAGES_USE_F2FS := true

TARGET_RELEASETOOLS_EXTENSIONS := device/moto/shamu

# Support Native Layer RF cutback
BOARD_USES_CUTBACK_IN_RILD := true

BOARD_SEPOLICY_DIRS += device/moto/shamu/sepolicy

HAVE_ADRENO_SOURCE:= false

OVERRIDE_RS_DRIVER:= libRSDriver_adreno.so
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true

BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := $(TARGET_BOARD_PLATFORM)
BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := true

BOARD_HAS_AUDIO_DSP := true

USE_DEVICE_SPECIFIC_CAMERA:= true

BOARD_HAL_STATIC_LIBRARIES := libdumpstate.shamu

# Qualcomm Time Services
BOARD_USES_QC_TIME_SERVICES := true

# Include an expanded selection of fonts
EXTENDED_FONT_FOOTPRINT := true

# Removed to build MultiROM...
#USE_CLANG_PLATFORM_BUILD := true

#-include vendor/motorola/shamu/BoardConfigVendor.mk

# Bliss
TARGET_TC_ROM := 4.9
TARGET_TC_KERNEL := 4.9-linaro
TARGET_GCC_VERSION_EXP := $(TARGET_TC_ROM)
TARGET_KERNEL_CUSTOM_TOOLCHAIN := $(TARGET_TC_KERNEL)

# TWRP
RECOVERY_VARIANT := twrp
DEVICE_RESOLUTION := 1440x2560
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_L_CRYPTO := true
BOARD_HAS_NO_REAL_SDCARD := true
RECOVERY_GRAPHICS_USE_LINELENGTH := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGB_565"
TW_SCREEN_BLANK_ON_BOOT := true
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_EXTRA_LANGUAGES := true

# MultiROM config. MultiROM also uses parts of TWRP config
MR_INPUT_TYPE := type_b
MR_INIT_DEVICES := device/moto/shamu/multirom/mr_init_devices.c
MR_DPI := xxhdpi
MR_DPI_FONT := 435
MR_USE_MROM_FSTAB := true
MR_FSTAB := device/moto/shamu/twrp.fstab
MR_KEXEC_MEM_MIN := 0x20000000
MR_KEXEC_DTB := true
#MR_INFOS := device/moto/shamu/multirom/infos
MR_DEVICE_HOOKS := device/moto/shamu/multirom/mr_hooks.c
MR_DEVICE_HOOKS_VER := 5
MR_PIXEL_FORMAT := "RGBX_8888"
MR_ENCRYPTION := true
MR_ENCRYPTION_SETUP_SCRIPT := device/moto/shamu/multirom/mr_cp_crypto.sh
MR_USE_QCOM_OVERLAY := true
MR_QCOM_OVERLAY_HEADER := device/moto/shamu/multirom/mr_qcom_overlay.h
MR_QCOM_OVERLAY_CUSTOM_PIXEL_FORMAT := MDP_RGBX_8888
TARGET_RECOVERY_IS_MULTIROM := true



DEVICE_PATH := device/motorola/x40

BUILD_BROKEN_DUP_RULES := true

RELAX_USES_LIBRARY_CHECK := true

TARGET_BOARD_PLATFORM := kalama

# Enable virtual A/B compression
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/android_t_baseline.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := gz

# Enable debugfs restrictions
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

#Enable vm support
TARGET_ENABLE_VM_SUPPORT := true

# true: earlycon and console enabled
# false: console explicitly disabled
# <empty>: default from kernel
TARGET_CONSOLE_ENABLED ?=

$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Set GRF/Vendor freeze properties
BOARD_SHIPPING_API_LEVEL := 33
BOARD_API_LEVEL := 33

# Set SoC manufacturer property
PRODUCT_PROPERTY_OVERRIDES += \
    ro.soc.manufacturer=QTI

# For QSSI builds, we should skip building the system image. Instead we build the
# "non-system" images (that we support).

PRODUCT_BUILD_SYSTEM_IMAGE := false
PRODUCT_BUILD_SYSTEM_OTHER_IMAGE := false
PRODUCT_BUILD_VENDOR_IMAGE := true
PRODUCT_BUILD_VENDOR_DLKM_IMAGE := true
PRODUCT_BUILD_PRODUCT_IMAGE := false
PRODUCT_BUILD_SYSTEM_EXT_IMAGE := false
PRODUCT_BUILD_ODM_IMAGE := false
PRODUCT_BUILD_CACHE_IMAGE := false
PRODUCT_BUILD_RAMDISK_IMAGE := true
PRODUCT_BUILD_RECOVERY_IMAGE := true
PRODUCT_BUILD_USERDATA_IMAGE := true

# Also, since we're going to skip building the system image, we also skip
# building the OTA package. We'll build this at a later step.
TARGET_SKIP_OTA_PACKAGE := true

# Enable AVB 2.0
BOARD_AVB_ENABLE := true

# Disable verified boot checks in abl if AVB is not enabled
ifeq ($(BOARD_AVB_ENABLE), true)
BOARD_ABL_SIMPLE := false
else
BOARD_ABL_SIMPLE := true
endif

NEED_AIDL_NDK_PLATFORM_BACKEND := true

# Set SYSTEMEXT_SEPARATE_PARTITION_ENABLE if was not already set (set earlier via build.sh).
SYSTEMEXT_SEPARATE_PARTITION_ENABLE := true

#Suppot to compile recovery without msm headers
TARGET_HAS_GENERIC_KERNEL_HEADERS := true

# Enable USB detection in QMAA mode
ifeq ($(TARGET_USES_QMAA),true)
ifeq ($(TARGET_USES_QMAA_RECOMMENDED_BOOT_CONFIG),true)
PRODUCT_PACKAGES += init.qti.usb.qmaa.rc
endif
endif

#qspa service
PRODUCT_PACKAGES += vendor.qti.qspa-service qspa-testclient

CLEAN_UP_JAVA_IN_VENDOR ?= enforcing

JAVA_IN_VENDOR_SOONG_WHITE_LIST :=\
CuttlefishService\
pasrservice\
VendorPrivAppPermissionTest\

JAVA_IN_VENDOR_MAKE_WHITE_LIST :=\
AEye\
AON\
SnapdragonCamera\

SHIPPING_API_LEVEL := 33
PRODUCT_SHIPPING_API_LEVEL := 33

# Set kernel version and ion flags
TARGET_KERNEL_VERSION := 5.15
TARGET_USES_NEW_ION := true

# Disable DLKM generation until build support is available
TARGET_KERNEL_DLKM_DISABLE := false

# Tech specific flags
TARGET_KERNEL_DLKM_AUDIO_OVERRIDE := true
TARGET_KERNEL_DLKM_BT_OVERRIDE := true
TARGET_KERNEL_DLKM_CAMERA_OVERRIDE := true
TARGET_KERNEL_DLKM_NFC_OVERRIDE := true
TARGET_KERNEL_DLKM_DATA_OVERRIDE := true
TARGET_KERNEL_DLKM_DISPLAY_OVERRIDE := true
TARGET_KERNEL_DLKM_MM_DRV_OVERRIDE := true
TARGET_KERNEL_DLKM_SECURE_MSM_OVERRIDE := true
TARGET_KERNEL_DLKM_THERMAL_OVERRIDE := true
TARGET_KERNEL_DLKM_TOUCH_OVERRIDE := true
TARGET_KERNEL_DLKM_VIDEO_OVERRIDE := true
TARGET_KERNEL_DLKM_WLAN_OVERRIDE := true
TARGET_KERNEL_DLKM_MMRM_OVERRIDE := true

#####Dynamic partition Handling
###
#### Turning this flag to TRUE will enable dynamic partition/super image creation.
PRODUCT_BUILD_ODM_IMAGE := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_PACKAGES += fastbootd
# Add default implementation of fastboot HAL.
PRODUCT_PACKAGES += android.hardware.fastboot@1.1-impl-mock

ifeq ($(SYSTEMEXT_SEPARATE_PARTITION_ENABLE), true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom
else
PRODUCT_COPY_FILES += $(LOCAL_PATH)/fstab_noSysext.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom
endif
BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

ifneq ("$(wildcard device/qcom/$(TARGET_BOARD_PLATFORM)-kernel/vendor_dlkm/system_dlkm.modules.blocklist)", "")
PRODUCT_COPY_FILES += device/qcom/$(TARGET_BOARD_PLATFORM)-kernel/vendor_dlkm/system_dlkm.modules.blocklist:$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules/system_dlkm.modules.blocklist
endif

BOARD_HAVE_BLUETOOTH := false
BOARD_HAVE_QCOM_FM := false

# privapp-permissions whitelisting (To Fix CTS :privappPermissionsMustBeEnforced)
PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=enforce

TARGET_DEFINES_DALVIK_HEAP := true

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/qcom/vendor-common/common64.mk)
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# beluga settings
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.beluga.p=0x3 \
    ro.vendor.beluga.c=0x4800 \
    ro.vendor.beluga.s=0x900 \
    ro.vendor.beluga.t=0x240

# Below perf props should be part of vendor/build.prop
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so \
    ro.vendor.perf-hal.ver=2.3 \
    ro.vendor.perf.scroll_opt=1 \
    vendor.perf.framepacing.enable=1

TARGET_USES_QCOM_BSP := false

# RRO configuration
TARGET_USES_RRO := true

TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

###########
# Target configurations

QCOM_BOARD_PLATFORMS += kalama

TARGET_USES_QSSI := true

#Default vendor image configuration
ENABLE_VENDOR_IMAGE := true

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

BOARD_FRP_PARTITION_NAME := frp

# Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

PRODUCT_PACKAGES += fs_config_files
PRODUCT_PACKAGES += gpio-keys.kl

# A/B related packagesf
PRODUCT_PACKAGES += update_engine \
    update_engine_client \
    update_verifier \
    android.hardware.boot@1.2-impl-qti \
    android.hardware.boot@1.2-impl-qti.recovery \
    android.hardware.boot@1.2-service

PRODUCT_HOST_PACKAGES += \
    brillo_update_payload

# Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl

PRODUCT_PACKAGES += \
  update_engine_sideload

# Enable incremental fs
PRODUCT_PROPERTY_OVERRIDES += \
    ro.incremental.enable=yes

PRODUCT_HOST_PACKAGES += \
    configstore_xmlparser

ifneq (,$(wildcard $(QCPATH)/vsdk-tools))
PRODUCT_HOST_PACKAGES += \
    install_vsdk_py2
PRODUCT_HOST_PACKAGES += \
    install_vsdk_py3
PRODUCT_HOST_PACKAGES += \
    vsdk-metadata
endif

# QRTR related packages
PRODUCT_PACKAGES += qrtr-ns
PRODUCT_PACKAGES += qrtr-lookup
PRODUCT_PACKAGES += libqrtr

# diag-router
TARGET_HAS_DIAG_ROUTER := true

# f2fs utilities
PRODUCT_PACKAGES += \
    sg_write_buffer \
    f2fs_io \
    check_f2fs

# Userdata checkpoint
PRODUCT_PACKAGES += \
    checkpoint_gc

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

# Macro allows Camera module to use new service
QTI_CAMERA_PROVIDER_SERVICE := 2.7
QTI_CAMERA_AON_SERVICE := 1.2

# Enable compilation of image_generation_tool
TARGET_USES_IMAGE_GEN_TOOL := true

# QCV allows multiple chipsets to be supported on a single vendor.
# Add vintf device manifests for chipsets in kalama QCV family below.
ifeq ($(TARGET_USES_QMAA), true)
TARGET_USES_QCV := false
else
TARGET_USES_QCV := true
endif

DEVICE_MANIFEST_SKUS := kalama
DEVICE_MANIFEST_KALAMA_FILES := $(DEVICE_PATH)/manifest_kalama.xml

DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml

# Enable Camera techpack with VSDK
ifneq (,$(wildcard $(QCPATH)/chi-cdk))
include $(QCPATH)/chi-cdk/configs/camera_techpack.mk
else ifneq (,$(wildcard $(QCPATH)/camx/chi-cdk))
include $(QCPATH)/camx/chi-cdk/configs/camera_techpack.mk
endif

#Audio DLKM
#AUDIO_DLKM := audio_apr.ko
#AUDIO_DLKM += audio_q6_pdr.ko
#AUDIO_DLKM += audio_q6_notifier.ko
#AUDIO_DLKM += audio_adsp_loader.ko
#AUDIO_DLKM += audio_q6.ko
#AUDIO_DLKM += audio_usf.ko
#AUDIO_DLKM += audio_pinctrl_wcd.ko
#AUDIO_DLKM += audio_swr.ko
#AUDIO_DLKM += audio_wcd_core.ko
#AUDIO_DLKM += audio_swr_ctrl.ko
#AUDIO_DLKM += audio_wsa881x.ko
#AUDIO_DLKM += audio_platform.ko
#AUDIO_DLKM += audio_hdmi.ko
#AUDIO_DLKM += audio_stub.ko
#AUDIO_DLKM += audio_wcd9xxx.ko
#AUDIO_DLKM += audio_mbhc.ko
#AUDIO_DLKM += audio_native.ko
#AUDIO_DLKM += audio_wcd938x.ko
#AUDIO_DLKM += audio_wcd938x_slave.ko
#AUDIO_DLKM += audio_bolero_cdc.ko
#AUDIO_DLKM += audio_wsa_macro.ko
#AUDIO_DLKM += audio_va_macro.ko
#AUDIO_DLKM += audio_rx_macro.ko
#AUDIO_DLKM += audio_tx_macro.ko
#AUDIO_DLKM += audio_machine_lahaina.ko
#AUDIO_DLKM += audio_snd_event.ko

PRODUCT_PACKAGES += $(AUDIO_DLKM)

# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_NAME)/$(KERNEL_MODULES_INSTALL)/lib/modules



USE_LIB_PROCESS_GROUP := true

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml


#Enable full treble flag
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true
BOARD_SYSTEMSDK_VERSIONS := 33

ifeq (true,$(BUILDING_WITH_VSDK))
    ALLOW_MISSING_DEPENDENCIES := true
    TARGET_SKIP_CURRENT_VNDK := true
    -include vendor/qcom/vsdk_snapshots_config/config.mk
else
    BOARD_VNDK_VERSION := current
    RECOVERY_SNAPSHOT_VERSION := current
    RAMDISK_SNAPSHOT_VERSION := current
endif

$(warning "BOARD_VNDK_VERSION = $(BOARD_VNDK_VERSION), RECOVERY_SNAPSHOT_VERSION=$(RECOVERY_SNAPSHOT_VERSION), RAMDISK_SNAPSHOT_VERSION=$(RAMDISK_SNAPSHOT_VERSION)")

TARGET_MOUNT_POINTS_SYMLINKS := false

# Fingerprint feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \

# system prop for enabling QFS (QTI Fingerprint Solution)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.qfp=true
#target specific runtime prop for qspm
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.qspm.enable=true
#ANT+ stack
PRODUCT_PACKAGES += \
    libvolumelistener

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

#Charger
PRODUCT_COPY_FILES += $(LOCAL_PATH)/charger_fw_fstab.qti:$(TARGET_COPY_OUT_VENDOR)/etc/charger_fw_fstab.qti

PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += telephony-ext
PRODUCT_PACKAGES += telephony-ext

PRODUCT_ENABLE_QESDK := true

# Vendor property to enable advanced network scanning
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.radio.enableadvancedscan=true

# Enable Fuse Passthrough
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fuse.passthrough.enable=true

# ODM ueventd.rc
# - only for use with VM support right now
ifeq ($(TARGET_ENABLE_VM_SUPPORT),true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/ueventd-odm.rc:$(TARGET_COPY_OUT_ODM)/etc/ueventd.rc
PRODUCT_PACKAGES += vmmgr vmmgr.rc vmmgr.conf
endif


##Armv9-Tests##
PRODUCT_PACKAGES_DEBUG += bti_test_prebuilt \
                          pac_test \
                          mte_tests \
                          dynamic_memcpy_prebuilt
##Armv9-Tests##

# Mediaserver 64 Bit enable
PRODUCT_PROPERTY_OVERRIDES += \
     ro.mediaserver.64b.enable=true

###################################################################################
# This is the End of target.mk file.
# Now, Pickup other split product.mk files:
###################################################################################
# TODO: Relocate the system product.mk files pickup into qssi lunch, once it is up.
$(foreach sdefs, $(sort $(wildcard vendor/qcom/defs/product-defs/system/*.mk)), \
    $(call inherit-product, $(sdefs)))
$(foreach vdefs, $(sort $(wildcard vendor/qcom/defs/product-defs/vendor/*.mk)), \
    $(call inherit-product, $(vdefs)))
###################################################################################
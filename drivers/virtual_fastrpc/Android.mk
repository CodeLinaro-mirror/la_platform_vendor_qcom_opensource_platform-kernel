VIRTIO_FASTRPC_SELECT := CONFIG_VIRTIO_FASTRPC=m
HYBRID_FASTRPC_SELECT := CONFIG_HYBRID_FASTRPC=m
HYBRID_FASTRPC_RSM_SELECT := CONFIG_HYBRID_FASTRPC_RSM=y

DLKM_DIR := $(TOP)/device/qcom/common/dlkm
LOCAL_PATH := $(call my-dir)

VRPC_BLD_DIR := $(abspath .)/vendor/qcom/opensource/platform-kernel/drivers/virtual_fastrpc

KBUILD_OPTIONS += VRPC_ROOT=$(VRPC_BLD_DIR)

ifeq ($(TARGET_HAS_VIRTIO_FASTRPC), true)
KBUILD_OPTIONS += $(VIRTIO_FASTRPC_SELECT)
KBUILD_OPTIONS += BOARD_PLATFORM=$(TARGET_BOARD_PLATFORM)
# Virtual fastrpc
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES   := $(wildcard $(LOCAL_PATH)/**/*) $(wildcard $(LOCAL_PATH)/*)
LOCAL_MODULE      := vfastrpc.ko
LOCAL_MODULE_KBUILD_NAME := vfastrpc.ko
LOCAL_MODULE_PATH := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
endif

ifeq ($(TARGET_HAS_HYBRID_FASTRPC), true)
KBUILD_OPTIONS += $(HYBRID_FASTRPC_SELECT)
KBUILD_OPTIONS += BOARD_PLATFORM=$(TARGET_BOARD_PLATFORM)
# Hybrid fastrpc
###########################################################
include $(CLEAR_VARS)

ifeq ($(TARGET_HAS_HYBRID_FASTRPC_RSM), true)
KBUILD_OPTIONS += KBUILD_EXTRA_SYMBOLS+=$(PWD)/$(call intermediates-dir-for,DLKM,rsm-fe-module-symvers)/Module.symvers

LOCAL_REQUIRED_MODULES := rsm-fe-module-symvers
LOCAL_ADDITIONAL_DEPENDENCIES += $(call intermediates-dir-for,DLKM,rsm-fe-module-symvers)/Module.symvers
KBUILD_OPTIONS += $(HYBRID_FASTRPC_RSM_SELECT)
endif

LOCAL_SRC_FILES   := $(wildcard $(LOCAL_PATH)/**/*) $(wildcard $(LOCAL_PATH)/*)
LOCAL_MODULE      := hfastrpc.ko
LOCAL_MODULE_KBUILD_NAME := hfastrpc.ko
LOCAL_MODULE_PATH := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
endif

#
# MODULE:   Makefile
#
# DESCRIPTION: Makefile for the ZLL Light devices
# 

LIGHT ?= Light_ColorLight

# Application target name
TARGET = $(LIGHT)
PDM_BUILD_TYPE ?=_EEPROM
#PDM_BUILD_TYPE ?= _EXTERNAL_FLASH


###############################################################################
#User definable make parameters that may be overwritten from the command line

# Default target device is the JN5169

JENNIC_CHIP ?= JN5168

JENNIC_CHIP_FAMILY ?=JN516x 

JENNIC_SDK ?= JN-SW-4168
###############################################################################
# Default DK4 development kit target hardware
DR ?= JN516X_RGB

#Always tell any actual drivers they're running under an RTOS in this usage
CFLAGS  += -DRTOS

# Tell the code what target hardware is  
CFLAGS  += -D$(DR)

###############################################################################
# Select the network stack (e.g. MAC, ZBPro, SE, HA)
JENNIC_STACK ?= ZLLHA
JENNIC_MAC ?= MiniMacShim

APP_CLUSTER_ZLL_SRC ?= 1

###############################################################################
# End device or router / coord
ZBPRO_DEVICE_TYPE ?= ZCR

###############################################################################
# Debug options define DEBUG either HW or SW
#DEBUG ?=SW
#DEBUG ?=HW
#
# Define which UART to use for HW debug
DEBUG_PORT ?= UART0

###############################################################################
# Define TRACE to use with DBG module
TRACE ?=1
ifeq ($(TRACE), 1)
CFLAGS  += -DDBG_ENABLE
endif

CFLAGS += -D$(TARGET)

CHANNEL ?=0
ifneq ($(CHANNEL), 0)
CFLAGS += -DMK_CHANNEL=$(CHANNEL)
endif

LNT ?=0
ifeq ($(LNT), 1)
CFLAGS += -DLNT
endif
#

APP_CLUSTER_ZLL_SRC ?= 1

##############################################################################
# For 4x use string based PDM id's for newer families use 16 bit id numbers
ifneq ($(JENNIC_CHIP_FAMILY), JN514x)
CFLAGS   += -DPDM_USER_SUPPLIED_ID
endif

###############################################################################

#CFLAGS += -DNXP_HARDWARE
#CFLAGS += -DDEBUG_ZCL
#CFLAGS += -DDEBUG_APP
#CFLAGS += -DDEBUG_START_UP
#CFLAGS += -DDEBUG_LIGHT_NODE
#CFLAGS += -DDEBUG_LIGHT_TASK
#CFLAGS += -DDEBUG_JOIN
#CFLAGS += -DDEBUG_COMMISSION
#CFLAGS += -DDEBUG_CLASSIC_JOIN
CFLAGS +=  -DDEBUG_EXCEPTIONS
#CFLAGS += -DDEBUG_TEMPERATURE

#CFLAGS += -DDEBUG_CLD_IDENTIFY 
#CFLAGS += -DDEBUG_CLD_LEVEL_CONTROL
#CFLAGS += -DDEBUG_CLD_ONOFF
#CFLAGS += -DDEBUG_LAMP
#CFLAGS += -DDEBUG_CLD_SCENES
#CFLAGS += -DDEBUG_CLD_COLOUR_CONTROL
#CFLAGS += -DDEBUG_CLD_COLOUR_CONTROL_UPDATES
#CFLAGS += -DDEBUG_CLD_COLOUR_CONTROL_CONVERSIONS
#CFLAGS += -DDEBUG_CLD_GROUPS

#CFLAGS  += -DSTRICT_PARAM_CHECK
###############################################################################
# Path definitions

# Use if application directory contains multiple targets
SDK_BASE_DIR        =  $(abspath ../../../../sdk/$(JENNIC_SDK))
APP_BASE            =  $(abspath ../..)
APP_BLD_DIR         = $(APP_BASE)/Common_Light/Build
APP_SRC_DIR         = $(APP_BASE)/Common_Light/Source
DEV_BLD_DIR         = $(APP_BASE)/$(TARGET)/Build
DEV_SRC_DIR         = $(APP_BASE)/$(TARGET)/Source

APP_COMMON_SRC_DIR  = $(APP_BASE)/Common/Source
APP_DRIVER_SRC_DIR  = $(APP_BASE)/Common_light/Source/DriverBulb


UTIL_SRC_DIR        = $(COMPONENTS_BASE_DIR)/Utilities/Source

###############################################################################
# Application Source files

# Note: Path to source file is found using vpath below, so only .c filename is required
APPSRC  = os_gen.c
APPSRC += os_irq.S
APPSRC += os_irq_alignment.S
APPSRC += os_irq_buserror.S
APPSRC += os_irq_illegalinstruction.S
APPSRC += os_irq_stackoverflowexception.S
APPSRC += os_irq_unimplementedmodule.S
APPSRC += pdum_gen.c
APPSRC += pdum_apdu.S
APPSRC += zps_gen.c
APPSRC += app_timer_driver.c
APPSRC += app_start_light.c
APPSRC += app_scenes.c
APPSRC += app_power_on_counter.c

APPSRC += app_buttons.c

APPSRC += zpr_light_node.c
APPSRC += ecb_decrypt.c

APPSRC += app_zcl_light_task.c
APPSRC += app_light_commission_task.c
APPSRC += app_manage_temperature.c

APPSRC += app_light_interpolation.c
APPSRC += appZpsBeaconHandler.c

#Light device type and it's associated driver 
APPSRC += App_$(TARGET).c
APPSRC += DriverBulb_$(DR).c
APPSRC += DriverBulb_Shim.c

CFLAGS += -D$(DR)
CFLAGS += -DEMBEDDED
CFLAGS += -DUSER_VSR_HANDLER


ifeq ($(TARGET),Light_ColorLight)
CFLAGS += -DRGB
endif

LINEAR_MODE ?= FALSE
ifeq ($(LINEAR_MODE),TRUE)
CFLAGS += -DLINEAR_MODE
VARIANT += _LINEAR
endif

APP_ZPSCFG = app.zpscfg

OPTIONAL_STACK_FEATURES = $(shell $(ZPSCONFIG) -n $(TARGET) -f $(APP_COMMON_SRC_DIR)/$(APP_ZPSCFG) -y )

BIN_SUFFIX=_$(DR)$(VARIANT)
###############################################################################
# Standard Application header search paths

INCFLAGS += -I$(APP_SRC_DIR)
INCFLAGS += -I$(APP_SRC_DIR)/..
INCFLAGS += -I$(DEV_SRC_DIR)

INCFLAGS += -I$(APP_COMMON_SRC_DIR)

# Application specific include files
INCFLAGS += -I$(COMPONENTS_BASE_DIR)/Utilities/Include

INCFLAGS += -I$(COMPONENTS_BASE_DIR)/ZCL/Include
INCFLAGS += -I$(COMPONENTS_BASE_DIR)/ZCL/Clusters/LightLink/Include
INCFLAGS += -I$(COMPONENTS_BASE_DIR)/Xcv/Include/
INCFLAGS += -I$(COMPONENTS_BASE_DIR)/Recal/Include/
INCFLAGS += -I$(COMPONENTS_BASE_DIR)/OVLY/Include
INCFLAGS += -I$(COMPONENTS_BASE_DIR)/MicroSpecific/Include

INCFLAGS += -I$(APP_DRIVER_SRC_DIR)

LDLIBS += Recal_$(JENNIC_CHIP_FAMILY)


###############################################################################
# Application libraries
# Specify additional Component libraries

#APPLIBS +=

###############################################################################

# You should not need to edit below this line

###############################################################################
###############################################################################
# Configure for the selected chip or chip family

include $(SDK_BASE_DIR)/Chip/Common/Build/config.mk
include $(SDK_BASE_DIR)/Platform/Common/Build/Config.mk
include $(SDK_BASE_DIR)/Stack/Common/Build/config.mk

###############################################################################

TEMP = $(APPSRC:.c=.o)
APPOBJS_TMP = $(TEMP:.S=.o)
APPOBJS := $(addprefix $(DEV_BLD_DIR)/,$(APPOBJS_TMP))

###############################################################################
# Application dynamic dependencies

APPDEPS_TMP = $(APPOBJS_TMP:.o=.d)
APPDEPS := $(addprefix $(DEV_BLD_DIR)/,$(APPDEPS_TMP))

###############################################################################
# Linker

# Add application libraries before chip specific libraries to linker so
# symbols are resolved correctly (i.e. ordering is significant for GCC)

APPLDLIBS := $(foreach lib,$(APPLIBS),$(if $(wildcard $(addprefix $(COMPONENTS_BASE_DIR)/Library/lib,$(addsuffix _$(JENNIC_CHIP).a,$(lib)))),$(addsuffix _$(JENNIC_CHIP),$(lib)),$(addsuffix _$(JENNIC_CHIP_FAMILY),$(lib))))
LDLIBS := $(APPLDLIBS) $(LDLIBS)
###############################################################################
# Dependency rules

.PHONY: all clean
# Path to directories containing application source
vpath % $(APP_SRC_DIR):$(APP_COMMON_SRC_DIR):$(ZLL_SRC_DIRS):$(ZCL_SRC):$(UTIL_SRC_DIR):$(DEV_SRC_DIR):$(APP_DRIVER_SRC_DIR)


all: $(DEV_BLD_DIR)/$(TARGET)_$(JENNIC_CHIP)$(BIN_SUFFIX).bin

-include $(APPDEPS)
$(DEV_BLD_DIR)/%.d:
	rm -f $*.o

$(DEV_SRC_DIR)/os_gen.c $(DEV_SRC_DIR)/os_gen.h $(DEV_SRC_DIR)/os_irq.S $(DEV_SRC_DIR)/os_irq_alignment.S $(DEV_SRC_DIR)/os_irq_buserror.S $(DEV_SRC_DIR)/os_irq_illegalinstruction.S $(DEV_SRC_DIR)/os_irq_stackoverflowexception.S $(DEV_SRC_DIR)/os_irq_unimplementedmodule.S: $(APP_SRC_DIR)/App_ZLL_Light_$(JENNIC_CHIP_FAMILY)$(OS_CONFIG_OPT).oscfgdiag $(OSCONFIG)
	$(info Configuring the OS ...)
	$(OSCONFIG) -f $< -o $(DEV_SRC_DIR) -v $(JENNIC_CHIP)
	@echo

$(DEV_SRC_DIR)/pdum_gen.c $(DEV_SRC_DIR)/pdum_gen.h: $(APP_COMMON_SRC_DIR)/$(APP_ZPSCFG) $(PDUMCONFIG)
	$(info Configuring the PDUM ...)
	$(PDUMCONFIG) -z $(TARGET) -f $< -o $(DEV_SRC_DIR)
	@echo

$(DEV_SRC_DIR)/zps_gen.c $(DEV_SRC_DIR)/zps_gen.h: $(APP_COMMON_SRC_DIR)/$(APP_ZPSCFG) $(ZPSCONFIG)
	$(info Configuring the Zigbee Protocol Stack ...)
	$(ZPSCONFIG) -n $(TARGET) -t $(JENNIC_CHIP) -l $(ZPS_NWK_LIB) -a $(ZPS_APL_LIB) -c $(TOOL_COMMON_BASE_DIR)/$(TOOLCHAIN_PATH) -f $< -o $(DEV_SRC_DIR)
	@echo

$(DEV_BLD_DIR)/%.o: %.S
	$(info Assembling $< ...)
	$(CC) -c -o $(subst Source,Build,$@) $(CFLAGS) $(INCFLAGS) $< -MD -MF $(DEV_BLD_DIR)/$*.d -MP
	@echo

$(DEV_BLD_DIR)/%.o: %.c
	$(info Compiling $< ...)
	$(CC) -c -o $(subst Source,Build,$@) $(CFLAGS) $(INCFLAGS) $< -MD -MF $(DEV_BLD_DIR)/$*.d -MP
	@echo

$(DEV_BLD_DIR)/$(TARGET)_$(JENNIC_CHIP)$(BIN_SUFFIX).elf: $(APPOBJS) $(addsuffix.a,$(addprefix $(COMPONENTS_BASE_DIR)/Library/lib,$(APPLDLIBS))) 
	$(info Linking $@ ...)
	$(CC) -Wl,--gc-sections -Wl,-u_AppColdStart -Wl,-u_AppWarmStart $(LDFLAGS) -TAppBuildZLLHA_$(JENNIC_CHIP).ld -o $@ -Wl,--start-group $(APPOBJS) $(addprefix -l,$(LDLIBS)) -lm -Wl,--end-group -Wl,-Map,$(DEV_BLD_DIR)/$(TARGET)_$(JENNIC_CHIP)$(BIN_SUFFIX).map 
	$(SIZE) $@ 
	
$(DEV_BLD_DIR)/$(TARGET)_$(JENNIC_CHIP)$(BIN_SUFFIX).bin: $(DEV_BLD_DIR)/$(TARGET)_$(JENNIC_CHIP)$(BIN_SUFFIX).elf 
	$(info Generating binary ...)
	$(OBJCOPY) -j .version -j .bir -j .flashheader -j .vsr_table -j .vsr_handlers  -j .rodata -j .text -j .data -j .bss -j .heap -j .stack -S -O binary $< $@


###############################################################################

clean:
	rm -f $(APPOBJS) $(APPDEPS) $(DEV_BLD_DIR)/$(TARGET)_$(JENNIC_CHIP)$(BIN_SUFFIX).bin $(DEV_BLD_DIR)/$(TARGET)_$(JENNIC_CHIP)$(BIN_SUFFIX).elf $(DEV_BLD_DIR)/$(TARGET)_$(JENNIC_CHIP)$(BIN_SUFFIX).map
	rm -f $(DEV_SRC_DIR)/os_gen.c $(DEV_SRC_DIR)/os_gen.h $(DEV_SRC_DIR)/os_irq*.S $(DEV_SRC_DIR)/pdum_gen.* $(DEV_SRC_DIR)/zps_gen*.*

###############################################################################

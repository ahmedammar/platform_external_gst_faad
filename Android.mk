LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

FAAD_TOP := $(LOCAL_PATH)

FAAD_BUILT_SOURCES := 		\
	libfaad/Android.mk

FAAD_BUILT_SOURCES := $(patsubst %, $(abspath $(FAAD_TOP))/%, $(FAAD_BUILT_SOURCES))

ifeq ($(NDK_BUILD),true)
LIB := $(SYSROOT)/usr/lib
else
LIB := $(TARGET_OUT_SHARED_LIBRARIES)
endif

.PHONY: libfaad-configure
libfaad-configure: $(TARGET_CRTBEGIN_DYNAMIC_O) $(TARGET_CRTEND_O) $(LIB)/libc.so $(LIB)/libz.so
	cd $(FAAD_TOP) ; \
	touch NEWS AUTHORS ChangeLog ; \
	autoreconf -i && \
	CC="$(CONFIGURE_CC)" \
	CFLAGS="$(CONFIGURE_CFLAGS)" \
	LD=$(TARGET_LD) \
	LDFLAGS="$(CONFIGURE_LDFLAGS)" \
	CPP=$(CONFIGURE_CPP) \
	CPPFLAGS="$(CONFIGURE_CPPFLAGS)" \
	PKG_CONFIG_PATH=$(CONFIGURE_PKG_CONFIG_PATH) \
	PKG_CONFIG_TOP_BUILD_DIR=/ \
	$(abspath $(FAAD_TOP))/configure --host=arm-linux-androideabi \
	--prefix=/system && \
	for file in $(FAAD_BUILT_SOURCES); do \
		rm -f $$file && \
		make -C $$(dirname $$file) $$(basename $$file) ; \
	done

CONFIGURE_TARGETS += libfaad-configure

-include $(FAAD_TOP)/libfaad/Android.mk

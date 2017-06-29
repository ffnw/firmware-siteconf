GLUON_SITE_PACKAGES := \
	gluon-mesh-batman-adv-15 \
	gluon-respondd \
	gluon-autoupdater \
	gluon-config-mode-core \
	gluon-config-mode-autoupdater \
	gluon-config-mode-hostname \
	gluon-config-mode-mesh-vpn \
	gluon-ebtables-filter-multicast \
	gluon-ebtables-filter-ra-dhcp \
	gluon-luci-admin \
	gluon-luci-autoupdater \
	gluon-luci-portconfig \
	gluon-luci-private-wifi \
	gluon-luci-wifi-config \
	gluon-mesh-vpn-fastd \
	gluon-next-node \
	gluon-radvd \
	gluon-setup-mode \
	gluon-status-page \
	haveged \
	iwinfo \
	ffnw-banner \
	ffnw-node-info \
	ffnw-config-mode-geo-location \
	ffnw-config-mode-contact-info \
	ffnw-hoodselector \
	ffnw-multiple-v6-watchdoog \
	ffnw-hoodselector-ctl \
	netmon-node-client

USB_BASIC := \
	kmod-usb-core \
	kmod-usb2 \
	kmod-usb-hid

USB_NIC := \
	kmod-usb-net \
	kmod-usb-net-asix \
	kmod-usb-net-rtl8150 \
	kmod-usb-net-rtl8152 \
	kmod-usb-net-dm9601-ether \
	kmod-usb-net-mcs7830

ifeq ($(GLUON_TARGET),x86-generic)
	GLUON_SITE_PACKAGES += \
		$(USB_BASIC) \
		kmod-usb-ohci-pci \
		kmod-phylib-broadcom \
		$(USB_NIC)
endif

ifeq ($(GLUON_TARGET),x86-64)
	GLUON_SITE_PACKAGES += \
		$(USB_BASIC) \
		$(USB_NIC) \
		kmod-phylib-broadcom \
		kmod-igb
endif

DEFAULT_GLUON_RELEASE := $(shell date '+%Y%m%d')-$(shell git log -1 --pretty=format:%h)
DEFAULT_GLUON_PRIORITY := 0
DEFAULT_GLUON_REGION := eu

GLUON_ATH10K_MESH := ibss

# Allow overriding from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)
GLUON_PRIORITY ?= $(DEFAULT_GLUON_PRIORITY)
GLUON_REGION ?= $(DEFAULT_GLUON_REGION)
GLUON_LANGS ?= de en

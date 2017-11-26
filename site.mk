GLUON_SITE_PACKAGES := \
	gluon-config-mode-core \
	gluon-setup-mode \
	gluon-mesh-batman-adv-15 \
	gluon-config-mode-autoupdater \
	gluon-config-mode-hostname \
	gluon-config-mode-mesh-vpn \
	gluon-ebtables-filter-multicast \
	gluon-ebtables-filter-ra-dhcp \
	gluon-web-autoupdater \
	gluon-web-network \
	gluon-web-wifi-config \
	gluon-web-private-wifi \
	gluon-radvd \
	gluon-status-page \
	gluon-web-mesh-vpn-fastd \
	haveged \
	iwinfo \
	ffnw-banner \
	ffnw-node-info \
	ffnw-config-mode-geo-location \
	ffnw-config-mode-contact-info \
	ffnw-hoods \
	ffnw-hoodselector \
	ffnw-multiple-v6-watchdoog

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
		$(USB_NIC)
endif

ifeq ($(GLUON_TARGET),x86-64)
	GLUON_SITE_PACKAGES += \
		$(USB_BASIC) \
		$(USB_NIC) \
		kmod-phy-broadcom \
		kmod-igb
endif

GLUON_ATH10K_MESH := ibss

# Allow overriding from the command line
GLUON_RELEASE ?= $(shell date '+%Y%m%d')-$(shell git log -1 --pretty=format:%h)
GLUON_PRIORITY ?= 2
GLUON_REGION ?= eu
GLUON_LANGS ?= de en

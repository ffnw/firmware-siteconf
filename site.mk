GLUON_FEATURES := \
	web-wizard \
	autoupdater \
	web-advanced \
	status-page \
	mesh-batman-adv-15 \
	config-mode-mesh-vpn \
%A
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-limit-arp \
	ebtables-source-filter \
	radvd \
	radv-filterd \
	lock-password \
	web-private-wifi \
	web-logging \
	geolocator \
	config-mode-geo-location-osm \
	hoodselector

GLUON_SITE_PACKAGES := \
	respondd-module-airtime \
	haveged \
	ffnw-banner \
	iwinfo \

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
		$(USB_NIC) \
		kmod-phy-broadcom
endif

ifeq ($(GLUON_TARGET),x86-64)
	GLUON_SITE_PACKAGES += \
		$(USB_BASIC) \
		$(USB_NIC) \
		kmod-phy-broadcom \
		kmod-igb
endif

GLUON_MULTIDOMAIN=1

GLUON_WLAN_MESH := 11s

# Allow overriding from the command line
%B
%C
GLUON_PRIORITY ?= 0
GLUON_REGION ?= eu
GLUON_LANGS ?= de en

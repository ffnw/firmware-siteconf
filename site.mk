GLUON_FEATURES := \
	web-wizard \
	autoupdater \
	web-advanced \
	status-page \
	mesh-batman-adv-15 \
%A
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-limit-arp \
	radvd \
	radv-filterd \
	web-private-wifi \
	geolocator \
	web-logging \
	hoodselector

GLUON_SITE_PACKAGES := \
	-gluon-config-mode-geo-location \
	gluon-config-mode-geo-location-with-geloc-map \
	-gluon-web-autoupdater \
	ffho-web-autoupdater \
	haveged \
	iwinfo \
	tecff-ath9k-broken-wifi-workaround \
	ffnw-banner \
	ffnw-hoods \
	ffnw-multiple-v6-watchdoog

# from https://github.com/Freifunk-Nord/gluon-ssid-changer:
GLUON_SITE_PACKAGES += \
	gluon-ssid-changer

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

GLUON_ATH10K_MESH := 11s

# Allow overriding from the command line
%B
%C
GLUON_PRIORITY ?= 0
GLUON_REGION ?= eu
GLUON_LANGS ?= de en

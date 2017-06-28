GLUON_SITE_PACKAGES := \
	gluon-mesh-batman-adv-15 \
	  # gluon-core
	    # gluon-site
	  # libgluonutil
	  # gluon-client-bridge
	    # gluon-core
	      # gluon-site
	  # gluon-ebtables
	    # gluon-core
	      # gluon-site
	gluon-config-mode-autoupdater \
	# gluon-config-mode-core-virtual (gluon-config-mode-core)
	  # gluon-setup-mode-virtual (gluon-setup-mod)
	    # gluon-web
	  # gluon-web-theme
	  # gluon-lock-password
	    # gluon-core
	      # gluon-site
	# gluon-autoupdater
	  # gluon-core
	    # gluon-site
	  # libgluonutil
	gluon-config-mode-hostname \
	  # gluon-config-mode-core-virtual (gluon-config-mode-core)
	    # ...
	gluon-config-mode-mesh-vpn \
	  # gluon-config-mode-core-virtual (gluon-config-mode-core)
	    # ...
	  # gluon-mesh-vpn-core
	    # gluon-core
	      # gluon-site
	    # gluon-wan-dnsmasq
	      # gluon-core
	        # gluon-site
	gluon-ebtables-filter-multicast \
	  # gluon-core
	    # gluon-site
	  # gluon-ebtables
	    # gluon-core
	      # gluon-site
	gluon-ebtables-filter-ra-dhcp \
	  # gluon-core
	    # gluon-site
	  # gluon-ebtables
	    # gluon-core
	      # gluon-site
	gluon-ebtables-segment-mld \
	  # gluon-core
	    # gluon-site
	  # gluon-ebtables
	    # gluon-core
	      # gluon-site
	gluon-ebtables-source-filter \
	  # gluon-core
	    # gluon-site
	  # gluon-ebtables
	    # gluon-core
	      # gluon-site
	gluon-web-autoupdater \
	    # gluon-web-admin
	      # gluon-config-mode-core-virtual (gluon-config-mode-core)
	        # ...
	  # gluon-autoupdater
	    # gluon-core
	      # gluon-site
	    # libgluonutil
	gluon-web-network \
	  # gluon-web-admin
	    # ...
	  # gluon-client-bridge
	    # ...
	gluon-web-wifi-config \
	  # gluon-web-admin
	    # ...
	gluon-web-private-wifi \
	  # gluon-web-admin
	    # ...
	gluon-radvd \
	  # gluon-core
	    # gluon-site
	gluon-status-page \
	  # gluon-status-page-api
	    # gluon-core
	      # gluon-site
	    # gluon-neighbour-info
	    # gluon-respondd
	      # gluon-core
	        # gluon-site
	      # libgluonutil
	gluon-web-mesh-vpn-fastd \
	  # gluon-web-admin
	  # gluon-mesh-vpn-fastd
	    # gluon-core
	      # gluon-site
	    # libgluonutil
	    # gluon-mesh-vpn-core
	      # gluon-core
	        # gluon-site
	      # gluon-wan-dnsmasq
	        # gluon-core
		  # gluon-site
	haveged \
	iwinfo \
	ffnw-banner \
	ffnw-node-info \
	ffnw-config-mode-geo-location \
	ffnw-config-mode-contact-info \
	ffnw-hoodselector \
	ffnw-multiple-v6-watchdoog \
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
DEFAULT_GLUON_PRIORITY := 7
DEFAULT_GLUON_REGION := eu

GLUON_ATH10K_MESH := ibss

# Allow overriding from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)
GLUON_PRIORITY ?= $(DEFAULT_GLUON_PRIORITY)
GLUON_REGION ?= $(DEFAULT_GLUON_REGION)
GLUON_LANGS ?= de en

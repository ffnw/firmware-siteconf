GLUON_SITE_PACKAGES := \
	gluon-mesh-batman-adv-15 \
	gluon-alfred \
	gluon-respondd \
	gluon-autoupdater \
	gluon-config-mode-autoupdater \
	gluon-config-mode-hostname \
	gluon-config-mode-mesh-vpn \
	gluon-ebtables-filter-multicast \
	gluon-ebtables-filter-ra-dhcp \
	gluon-config-mode-core \
	gluon-luci-admin \
	gluon-luci-autoupdater \
	gluon-luci-portconfig \
	gluon-luci-private-wifi \
	gluon-luci-wifi-config \
	gluon-next-node \
	gluon-mesh-vpn-fastd \
	gluon-radvd \
	gluon-legacy \
	gluon-setup-mode \
	gluon-status-page \
	iwinfo \
	iptables \
	haveged \
	ffnw-configurator \
	ffnw-nodewatcher \
	ffnw-banner \
	libwlocate \
	lwtrace \
	ffnw-node-info \
	ffnw-config-mode-geo-location \
	ffnw-config-mode-contact-info \
	ffnw-autoupdater-mod

DEFAULT_GLUON_RELEASE := 0.6+exp$(shell date '+%Y%m%d')

# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

GLUON_PRIORITY ?= 0

GLUON_LANGS ?= en de

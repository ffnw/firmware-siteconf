## Als Entwickler tätig werden

Falls dich das Thema der Software entwicklung begeistert und du gerne bereit bist dich in komplexe strukturen einzuarbeiten, sowie gerne einen beitreg zu Freifunk leisten möchtes kannst du dich unter folgenden Link über einen einstieg erkundigen:
https://wiki.ffnw.de/Entwicklung/Als\_Entwickler\_t%C3%A4tig\_werden

## Firmware Kompilieren

### Voraussetzungen (Stand Gluon v2018.2.x):

Muss auf dem Rechner installiert sein. Hier Beispiel Debian:

    apt-get install git subversion python build-essential gawk unzip libncurses-dev libz-dev libssl-dev

### Gluon kompilieren

Auf dieser Seite wird beschrieben, wie man die Gluon Firmware für das Freifunk Nordwest Netzwerk kompiliert. Um die Firmware zu kompilieren wird ein Rechner mit einem Linux Betriebssystem und ca. 70-100GB freier Speicher benötigt. Der make Befehl passt sich automatisch an die Anzahl von cores an.

*Wichtig* Je nach Entwicklungsstand muss die Branch Version angepasst werden.

    git clone https://github.com/freifunk-gluon/gluon.git ./freifunk_build -b v2018.2.x && cd ./freifunk_build
    git clone https://git.ffnw.de/ffnw-firmware/siteconf.git site -b gluon-domain-migration && cd site
    ./buildscript.sh patch
    ./buildscript.sh prepare GLUON_BRANCH <autoupdater-branch, also zB "stable" oder "testing">
    ./buildscript.sh prepare GLUON_RELEASE <Releasecodename, zB das aktuelle Datum im Format YYYYMMDD>
    ./buildscript.sh prepare <vpn, zB "fastd" oder "l2tp">
    ./buildscript.sh build <target, zB "x86-generic"> fast
    
*Hinweis* Auf Multicoresystemen sorgt die option `fast` dafür, dass alle vefügbaren CPU-Kerne für den Build genutzt werden.

### Manifest und initiale Signatur erstellen

    ./buildscript.sh create_manifest manifest
    ./contrib/sign.sh ../firmware/release_keys/ecdsa-privatekey ./output/images/sysupgrade/stable.manifest

Weitere Informationen z.B. zu automatischen Builds auch unter https://gluon.readthedocs.org/en/latest/features/autoupdater.html

### Prüfsummen erstellen

Die Prüfsummen werden auf dem Server automatisiert generiert.

### Referenzen

* https://wiki.openwrt.org/doc/howto/build
* https://buildroot.org/downloads/manual/manual.html

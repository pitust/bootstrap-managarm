
f := native-weston
$f_up := weston

$f_RUN := $B/withprefix $B/prefixes
$f_RUN += host-protoc cross-binutils native-gcc
$f_RUN += --

$f_CONFIGURE := $T/ports/$($f_up)/configure --host=x86_64-managarm --prefix=/usr
$f_CONFIGURE += --disable-xwayland --disable-x11-compositor --disable-weston-launch
$f_CONFIGURE_ENV := PKG_CONFIG_SYSROOT_DIR=$B/system-root
$f_CONFIGURE_ENV += PKG_CONFIG_PATH=$B/system-root/usr/lib/pkgconfig:$B/system-root/usr/share/pkgconfig

$f_MAKE_ALL := make all
$f_MAKE_INSTALL := make "DESTDIR=$B/system-root" install

$(call milestone_action,configure-$f install-$f)

configure-$f: | $(call upstream_tag,regenerate-$($f_up))
configure-$f:
	rm -rf $B/native/$f && mkdir -p $B/native/$f
	cd $B/native/$f && $($f_CONFIGURE_ENV) $($f_RUN) $($f_CONFIGURE)
	touch $(call milestone_tag,$@)

install-$f: | $(call milestone_tag,configure-$f)
	cd $B/native/$f && $($f_RUN) $($f_MAKE_ALL) && $($f_RUN) $($f_MAKE_INSTALL)
	touch $(call milestone_tag,$@)


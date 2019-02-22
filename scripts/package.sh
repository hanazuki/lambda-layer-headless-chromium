#!/bin/bash
set -euxo pipefail

cd

DESTDIR=$(mktemp -d)

install -D -t "$DESTDIR"/lib/chromium out/{headless_shell,chromedriver}
install -Dm0644 -t "$DESTDIR"/lib/chromium/swiftshader out/swiftshader/{libGLESv2.so,libEGL.so}
install -D -t "$DESTDIR"/bin src/chromium
ln -s -t "$DESTDIR"/bin ../lib/chromium/chromedriver

install -Dm0644 -t "$DESTDIR"/lib/chromium src/fonts.conf
sed -i 's|@FC_CACHEDIR@|/var/cache/fontconfig|' "$DESTDIR"/lib/chromium/fonts.conf
install -Dm0644 -t "$DESTDIR"/share/fonts/opentype/noto /usr/share/fonts/opentype/noto/NotoSansCJK-{Regular,Bold}.ttc
install -d "$DESTDIR"/var/cache/fontconfig
tmp_fcconf=$(mktemp)
sed "s|@FC_CACHEDIR@|$DESTDIR/var/cache/fontconfig|" src/fonts.conf > "${tmp_fcconf}"
FONTCONFIG_FILE=${tmp_fcconf} fc-cache -rv "$DESTDIR"/share/fonts/opentype/noto

mkdir -p "$PWD"/dist
archive_base=headless-chromium-${CR_VERSION:-master}
archive_zip=$PWD/dist/${archive_base}.zip
archive_tar=$PWD/dist/${archive_base}.tar.gz

pushd "$DESTDIR"
zip --symlink -r "${archive_zip}" .
tar -czvf "${archive_tar}" .

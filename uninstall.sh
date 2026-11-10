#!/system/bin/sh
PKG=site.lenirraxzone.perftuner
SD=/data/adb/service.d
mkdir -p "$SD"
cat > "$SD/lnr_perftuner_cleanup.sh" <<'EOS'
PKG=site.lenirraxzone.perftuner
until [ "$(getprop sys.boot_completed)" = 1 ]; do sleep 2; done
sleep 5
if [ ! -d /data/adb/modules/lnr_perftuner ] || [ -f /data/adb/modules/lnr_perftuner/remove ]; then
  i=0
  while [ $i -lt 5 ]; do
    pm path "$PKG" 2>/dev/null | grep -q '^package:' || break
    pm uninstall "$PKG" >/dev/null 2>&1
    i=$((i+1)); sleep 3
  done
  rm -rf /data/adb/perftuner
fi
rm -f "$0"
EOS
chmod 755 "$SD/lnr_perftuner_cleanup.sh"

[ -f /dev/perftuner/pid ] && kill "$(cat /dev/perftuner/pid)" 2>/dev/null

pm uninstall "$PKG" >/dev/null 2>&1

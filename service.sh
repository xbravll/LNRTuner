#!/system/bin/sh
MODDIR=${0%/*}
PKG=site.lenirraxzone.perftuner
until [ "$(getprop sys.boot_completed)" = 1 ]; do sleep 2; done
sleep 5

# Cadangan: kalau app belum terpasang (mis. flash lewat recovery / pm gagal saat install), pasang sekarang
if ! pm path "$PKG" 2>/dev/null | grep -q '^package:'; then
  if [ -f "$MODDIR/apk/PerfTuner.apk" ]; then
    cp -f "$MODDIR/apk/PerfTuner.apk" /data/local/tmp/perftuner_install.apk
    chmod 644 /data/local/tmp/perftuner_install.apk
    pm install -r /data/local/tmp/perftuner_install.apk >/dev/null 2>&1
    rm -f /data/local/tmp/perftuner_install.apk
  fi
fi

# boot: terapkan profile manual terakhir, atau jalankan daemon AI bila mode Auto aktif
"$MODDIR/bin/perftuner" boot /data/adb/perftuner

MODDIR=${0%/*}
PKG=site.lenirraxzone.perftuner
ACT=$PKG/.MainActivity

if [ ! -x "$MODDIR/bin/perftuner" ]; then echo "! Module belum aktif, reboot dulu."; exit 1; fi

if ! pm path "$PKG" 2>/dev/null | grep -q '^package:'; then
  if [ -f "$MODDIR/apk/PerfTuner.apk" ]; then
    echo "- Memasang aplikasi PerfTuner..."
    cp -f "$MODDIR/apk/PerfTuner.apk" /data/local/tmp/perftuner_install.apk
    chmod 644 /data/local/tmp/perftuner_install.apk
    pm install -r /data/local/tmp/perftuner_install.apk >/dev/null 2>&1
    rm -f /data/local/tmp/perftuner_install.apk
  fi
  pm path "$PKG" 2>/dev/null | grep -q '^package:' || { echo "! Aplikasi PerfTuner belum terpasang."; exit 1; }
fi

OUT=$(am start --user 0 -n "$ACT" 2>&1) || OUT=$(am start -n "$ACT" 2>&1)
case $OUT in
  *Error*|*Exception*|*"does not exist"*)
    echo "! Gagal membuka PerfTuner:"; echo "$OUT"; exit 1 ;;
esac
echo "- PerfTuner dibuka."
exit 0

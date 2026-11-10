PKG=site.lenirraxzone.perftuner

[ "$ARCH" = "arm64" ] || abort "! Hanya mendukung arm64 (ARCH=$ARCH)"
[ -f "$MODPATH/bin/perftuner" ] || abort "! bin/perftuner tidak ada di zip"

[ -f "$MODPATH/apk/PerfTuner.apk" ] || abort "! apk/PerfTuner.apk tidak ada di zip"

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/bin/perftuner" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/uninstall.sh" 0 0 0755

ui_print "- Memasang aplikasi PerfTuner..."
TMPAPK=/data/local/tmp/perftuner_install.apk
cp -f "$MODPATH/apk/PerfTuner.apk" "$TMPAPK" && chmod 644 "$TMPAPK"
OUT=$(pm install -r "$TMPAPK" 2>&1)
case $OUT in
  *Success*) ui_print "- Aplikasi terpasang." ;;
  *SIGNATURES*|*UPDATE_INCOMPATIBLE*|*DOWNGRADE*)
    pm uninstall "$PKG" >/dev/null 2>&1
    OUT=$(pm install -r "$TMPAPK" 2>&1)
    case $OUT in
      *Success*) ui_print "- Aplikasi terpasang ulang." ;;
      *) ui_print "! Gagal pasang app ($OUT). Akan dicoba lagi saat boot." ;;
    esac ;;
  *) ui_print "! pm install belum bisa sekarang. Akan dicoba lagi saat boot." ;;
esac
rm -f "$TMPAPK"

ui_print "- Selesai. Reboot, lalu tambahkan tile PerfTuner di Quick Settings."

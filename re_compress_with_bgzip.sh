#!/bin/bash
# re_compress_with_bgzip.sh

REF_DIR="/Volumes/T7/1000G_GRCh37_EUR_noFIN/filtered files EUR_noFIN_MVCF"

echo "🔁 Re-compressing .m3vcf.gz files with bgzip..."
for CHR in {1..22}; do
  FILE="${REF_DIR}/ALL.chr${CHR}.EUR_noFIN.m3vcf.gz"
  if [[ -f "$FILE" ]]; then
    echo "🗜️  Recompressing: $(basename "$FILE")"
    gunzip -c "$FILE" | bgzip -f > "${FILE}.bgz"
    mv "${FILE}.bgz" "$FILE"
  else
    echo "❌ File not found: $FILE"
  fi
done
echo "✅ All files recompressed using bgzip."

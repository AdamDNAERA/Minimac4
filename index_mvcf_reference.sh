#!/bin/bash
# index_mvcf_reference.sh

REF_DIR="/Volumes/T7/1000G_GRCh37_EUR_noFIN/filtered files EUR_noFIN_MVCF"

echo "🧬 Indexing M3VCF reference files (.tbi via tabix)..."

for CHR in {1..22}; do
  FILE="${REF_DIR}/ALL.chr${CHR}.EUR_noFIN.m3vcf.gz"
  if [[ -f "$FILE" ]]; then
    echo "📄 Indexing chr${CHR}..."
    tabix -f -p vcf "$FILE"
  else
    echo "⚠️  File not found: $FILE"
  fi
done

echo "✅ All reference M3VCF files processed."

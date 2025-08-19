#!/bin/bash

set -e

REF_DIR="/Volumes/T7/1000G_GRCh37_EUR_noFIN/filtered files EUR_noFIN"
OUT_DIR="/Volumes/T7/1000G_GRCh37_EUR_noFIN/filtered files EUR_noFIN_MVCF"

mkdir -p "$OUT_DIR"

echo "🗜️  Converting reference VCFs to M3VCF using Minimac4 in Docker..."

for CHR in {1..22} X Y; do
  REF_VCF="${REF_DIR}/ALL.chr${CHR}.EUR_noFIN.vcf.gz"
  OUT_FILE="${OUT_DIR}/ALL.chr${CHR}.EUR_noFIN.m3vcf.gz"

  echo "➡️  Converting chr${CHR}..."

  if [[ ! -f "$REF_VCF" ]]; then
    echo "❌ File not found: $REF_VCF"
    continue
  fi

  docker-compose run --rm minimac4 \
    --compress-reference "$REF_VCF" \
    --output "$OUT_FILE" \
    --threads 4

  echo "✅ chr${CHR} done"
done

echo "🎉 All chromosomes processed."

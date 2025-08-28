#!/usr/bin/env bash
set -euo pipefail

# Path to your m3vcf files (mounted into the container)
REF_DIR="/Volumes/T7/1000G_GRCh37_EUR_noFIN/filtered_files_EUR_noFIN_MVCF"

# Chromosomes to process
CHRS=( {1..22} X )

# Sanity checks
command -v minimac4 >/dev/null 2>&1 || { echo "minimac4 not in PATH"; exit 1; }
[ -d "$REF_DIR" ] || { echo "REF_DIR not found: $REF_DIR"; exit 1; }

for CHR in "${CHRS[@]}"; do
  INPUT="${REF_DIR}/ALL.chr${CHR}.EUR_noFIN.m3vcf.gz"
  OUTPUT="${REF_DIR}/ALL.chr${CHR}.EUR_noFIN.msav"

  echo "[INFO] Processing chr${CHR} ..."

  if [ ! -s "$INPUT" ]; then
    echo "[WARN] Missing or empty: $INPUT — skipping"; continue
  fi

  # Optional: confirm M3VCF header
  if ! zgrep -m1 -q '^##fileformat=M3VCF' "$INPUT"; then
    echo "[ERROR] Not M3VCF header: $INPUT — skipping"; continue
  fi

  minimac4 --update-m3vcf "$INPUT" > "$OUTPUT"

  if [ -s "$OUTPUT" ]; then
    echo "[OK] chr${CHR} → $OUTPUT"
  else
    echo "[ERROR] chr${CHR} produced empty output"
  fi
done

echo "[DONE] All chromosomes attempted."

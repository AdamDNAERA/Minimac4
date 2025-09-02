#!/usr/bin/env bash
set -euo pipefail

# Path to your m3vcf files (mounted into the container)
REF_DIR="/Volumes/T7/1000G_GRCh37_EUR_noFIN/filtered_files_EUR_noFIN_MVCF"

# Chromosomes to process
CHRS=({1..22} X)

# Sanity checks
if ! command -v minimac4 >/dev/null 2>&1; then
  echo "[FATAL] minimac4 not in PATH"; exit 1
fi
[ -d "$REF_DIR" ] || { echo "[FATAL] REF_DIR not found: $REF_DIR"; exit 1; }

echo "[INFO] minimac4 version: $(minimac4 --version || echo unknown)"

# helper: detect if header advertises M3VCF (not all do); set IS_M3VCF=1 if likely
is_m3vcf() {
  local f="$1"
  # Look for typical M3VCF hints. If absent, assume standard VCF/BCF
  if gzip -cd "$f" | head -n 400 | grep -Eq '^##(m3vcfVersion|M3VCF|minimac3Version)'; then
    return 0
  else
    return 1
  fi
}

for CHR in "${CHRS[@]}"; do
  INPUT="${REF_DIR}/ALL.chr${CHR}.EUR_noFIN.m3vcf.gz"
  OUTPUT="${REF_DIR}/ALL.chr${CHR}.EUR_noFIN.msav"

  echo "[INFO] Processing chr${CHR} ..."

  if [ ! -s "$INPUT" ]; then
    echo "[WARN] Missing or empty: $INPUT — skipping"; continue
  fi
  if [ ! -s "${INPUT}.tbi" ]; then
    echo "[ERROR] Missing index: ${INPUT}.tbi — skipping"; continue
  fi

  # Decide conversion path
  if is_m3vcf "$INPUT"; then
    echo "[INFO] Detected M3VCF-like header → using --update-m3vcf"
    CONVERT_CMD=(minimac4 --update-m3vcf "$INPUT")
  else
    echo "[INFO] No M3VCF tag detected → assuming phased VCF/BCF → using --compress-reference"
    CONVERT_CMD=(minimac4 --compress-reference "$INPUT")
  fi

  # Build .msav: binary goes to STDOUT; logs stay on STDERR
  if "${CONVERT_CMD[@]}" > "$OUTPUT"; then
    if [ -s "$OUTPUT" ]; then
      echo "[OK] chr${CHR} → $OUTPUT"
    else
      echo "[ERROR] chr${CHR} produced empty output"
    fi
  else
    echo "[ERROR] minimac4 failed on chr${CHR}"
  fi

done

echo "[DONE] All chromosomes attempted."

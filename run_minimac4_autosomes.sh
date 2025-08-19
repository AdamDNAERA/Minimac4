#!/bin/bash

echo "🚀 Starting Minimac4 imputation across autosomes..."

REF_DIR="/Volumes/T7/1000G_GRCh37_EUR_noFIN/filtered_files_EUR_noFIN_MVCF"
OUT_DIR="/phased_output/imputed_output"
THREADS=4

mkdir -p "$OUT_DIR"

for CHR in {1..22}; do
    echo "🧬 Imputing chromosome $CHR..."

    minimac4 \
        --refHaps "$REF_DIR/ALL.chr${CHR}.EUR_noFIN.m3vcf.gz" \
        --haps "/phased_output/chr${CHR}_phased.vcf.gz" \
        --map "/Volumes/T7/Genetic map/genetic_map_chr${CHR}.txt" \
        --output "$OUT_DIR/chr${CHR}_imputed.vcf.gz" \
        --region "chr${CHR}" \
        --threads "$THREADS"
done

echo "✅ Imputation completed for all autosomes."

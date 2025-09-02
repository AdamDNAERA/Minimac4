#!/bin/bash
#OLD/deprecated
# Path to your m3vcf files
REF_DIR="/Volumes/T7/1000G_GRCh37_EUR_noFIN/filtered_files_EUR_noFIN_MVCF"

# Chromosomes to process
CHRS=( {1..22} X )

for CHR in "${CHRS[@]}"; do
    INPUT="${REF_DIR}/ALL.chr${CHR}.EUR_noFIN.m3vcf.gz"
    OUTPUT="${REF_DIR}/ALL.chr${CHR}.EUR_noFIN.msav"
    
    echo "Processing chromosome $CHR ..."
    
    docker compose run --rm cli minimac4 --update-m3vcf "$INPUT" > "$OUTPUT"
    
    if [ $? -eq 0 ]; then
        echo "Chromosome $CHR done: $OUTPUT"
    else
        echo "Error processing chromosome $CHR"
    fi
done

echo "All chromosomes processed."

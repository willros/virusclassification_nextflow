nextflow.enable.dsl=2

process WRANGLE_KAIJU_MEGAHIT_CAT {
    
    publishDir("results/${sample_id}/cleaned_files", pattern: "*.csv", mode: 'copy')

    input:
    tuple val(sample_id), path(kaiju)
    tuple val(sample_id_), path(cat)
    tuple val(sample_id__), path(megahit)
    
    output:
    tuple val(sample_id), path("*.csv"), emit: csv
    
    script:
    """
    wrangle_kaiju_megahit_cat.py \
    ${kaiju} \
    ${cat} \
    ${megahit} \
    ${sample_id}_cat_kaiju_merged
    """  
    
}




nextflow.enable.dsl=2

process WRANGLE_KAIJU_RAW {
    
    publishDir("${params.cleaned_files}", pattern: "*.csv", mode: 'copy')

    input:
    tuple val(sample_id), path(kaiju_names)
    tuple val(sample_id_), path(kaiju_table)
    
    output:
    tuple val(sample_id), path("*.csv"), emit: csv
    
    script:
    """
    wrangle_kaiju_raw.py \
    ${kaiju_names} \
    ${kaiju_table} \
    ${sample_id}_kaiju_raw
    """  
    
}




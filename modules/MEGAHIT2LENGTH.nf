nextflow.enable.dsl=2

process MEGAHIT2LENGTH {
    
    publishDir("results/${sample_id}/megahit", pattern: "*.csv", mode: 'copy')

    input:
    tuple val(sample_id), path(assembly)
    
    output:
    tuple val(sample_id), path("*.csv"), emit: csv
    
    script:
    """
    config_length_megahit.py \
    ${assembly} \
    ${sample_id}
    """  
    
}




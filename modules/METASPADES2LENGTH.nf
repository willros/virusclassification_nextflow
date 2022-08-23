nextflow.enable.dsl=2

process METASPADES2LENGTH {
    
    publishDir("${params.metaspades_out}/", pattern: "*.csv", mode: 'copy')

    input:
    val(sample_id)
    path(contigs)
    
    output:
    tuple val(sample_id), path("*.csv"), emit: csv
    
    script:
    """
    config_length_metaspades.py \
    ${contigs} \
    ${sample_id}_contigs
    """  
    
}




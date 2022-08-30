nextflow.enable.dsl=2

process BRACKEN {
    
    publishDir("${params.kraken2_out}/raw", pattern: "*species.tsv", mode: 'copy')

    input:
    tuple val(sample_id), path(kraken_report)
    path(database)
    
    output:
    tuple val(sample_id), path("*species.tsv"), emit: bracken_report
    
    script:
    """
    bracken \
    -d ${database} \
    -i ${kraken_report} \
    -o ${sample_id}_bracken_raw.tsv
    """  
    
}




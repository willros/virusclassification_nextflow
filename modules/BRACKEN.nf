nextflow.enable.dsl=2

process BRACKEN {
    
    publishDir("${params.kraken2_out}", pattern: "*.tsv", mode: 'copy')

    input:
    tuple val(sample_id), path(kraken_report)
    path(database)
    
    output:
    tuple val(sample_id), path("*.tsv"), emit: kraken_report
    
    script:
    """
    bracken \
    -d ${database} \
    -i ${kraken_report} \
    -o bracken_report_${sample_id}.tsv
    """  
    
}




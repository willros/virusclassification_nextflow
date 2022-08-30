nextflow.enable.dsl=2

process KRAKEN2 {
    
    publishDir("${params.kraken2_out}/raw", pattern: "*.tsv", mode: 'copy')

    input:
    tuple val(sample_id), path(reads)
    path(database)
    
    output:
    tuple val(sample_id), path("*.tsv"), emit: kraken_report
    
    script:
    """
    kraken2 \
    --db ${database} \
    --report ${sample_id}_kraken2_raw.tsv \
    --use-names \
    --paired \
    ${reads[0]} \
    ${reads[1]}
    """  
    
}




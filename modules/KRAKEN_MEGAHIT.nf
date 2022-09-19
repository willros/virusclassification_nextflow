nextflow.enable.dsl=2

process KRAKEN_MEGAHIT {
    
    publishDir("results/${sample_id}/kraken/megahit", pattern: "*.tsv", mode: 'copy')

    input:
    tuple val(sample_id), path(assembly)
    path(database)
    
    output:
    tuple val(sample_id), path("*.tsv"), emit: kraken_report
    
    script:
    """
    kraken2 \
    --db ${database} \
    --report ${sample_id}_kraken2_contigs.tsv \
    --use-names \
    ${assembly}
    """  
    
}




nextflow.enable.dsl=2

process KRAKEN_MEGAHIT {
    
    publishDir("${params.kraken2_out}/megahit", pattern: "*.tsv", mode: 'copy')

    input:
    tuple val(sample_id), path(assembly)
    path(database)
    
    output:
    tuple val(sample_id), path("*.tsv"), emit: kraken_report
    
    script:
    """
    kraken2 \
    --db ${database} \
    --report ${sample_id}.kraken2_megahit.report.tsv \
    --use-mpa-style \
    --use-names \
    ${assembly}
    """  
    
}



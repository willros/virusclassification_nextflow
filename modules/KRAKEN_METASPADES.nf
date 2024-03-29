nextflow.enable.dsl=2

process KRAKEN_METASPADES {
    
    publishDir("results/${sample_id}/kraken/metaspades", pattern: "*.tsv", mode: 'copy')

    input:
    val(sample_id)
    path(assembly)
    path(database)
    
    output:
    tuple val(sample_id), path("*.tsv"), emit: kraken_report
    
    script:
    """
    kraken2 \
    --db ${database} \
    --report ${sample_id}.kraken2_metaspades.report.tsv \
    --use-names \
    ${assembly}
    """  
    
}




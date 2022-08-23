nextflow.enable.dsl=2

process CONTIGS2INDEX {    
    input:
    val(sample_id)
    path(assembly)
    
    output:
    path('*bt2*'), emit: index
    
    script:
    """
    bowtie2-build \
    ${assembly} \
    ${sample_id}
    """   
}


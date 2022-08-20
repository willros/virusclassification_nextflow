nextflow.enable.dsl=2

    process CONTIGS2INDEX {    
    publishDir("${params.bowtie2_out}/contigs_index/${sample_id}", pattern: "*.bt2", mode: 'copy')

    input:
    tuple val(sample_id), path(assembly)
    
    output:
    tuple val(sample_id), path('*.bt2'), emit: index
    
    
    script:
    """
    bowtie2-build \
    ${assembly} \
    ${sample_id}
    """   
}


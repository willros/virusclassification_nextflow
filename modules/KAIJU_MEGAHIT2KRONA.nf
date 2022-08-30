nextflow.enable.dsl=2

process KAIJU_MEGAHIT2KRONA {
    
    input:
    tuple val(sample_id), path(tree)
    path(nodes)
    path(names)
    
    output:
    tuple val(sample_id), path("*.krona"), emit: krona
    
    script:
    """
    kaiju2krona \
    -t ${nodes} \
    -n ${names} \
    -i ${tree} \
    -o ${sample_id}_megahit.krona
    """  
    
}




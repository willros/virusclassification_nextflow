nextflow.enable.dsl=2

process KAIJU2KRONA {
    
    publishDir("${params.kaiju_out}/", pattern: "*.krona", mode: 'copy')

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
    -o ${sample_id}.krona
    """  
    
}




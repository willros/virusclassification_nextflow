nextflow.enable.dsl=2

process KAIJU {
    
    input:
    tuple val(sample_id), path(reads)
    path(nodes)
    path(fmi)
    
    output:
    tuple val(sample_id), path("*kaiju.out"), emit: tree
    
    script:
    """
    kaiju \
    -t ${nodes} \
    -f ${fmi} \
    -i ${reads[0]} \
    -j ${reads[1]} \
    -v \
    -o ${sample_id}.kaiju.out
    """  
    
}




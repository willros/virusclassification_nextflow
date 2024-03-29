nextflow.enable.dsl=2

process KAIJU_MEGAHIT {
   
    input:
    tuple val(sample_id), path(assembly)
    path(nodes)
    path(fmi)
    
    output:
    tuple val(sample_id), path("*kaiju.out"), emit: tree
    
    script:
    """
    kaiju \
    -t ${nodes} \
    -f ${fmi} \
    -i ${assembly} \
    -v \
    -o ${sample_id}_megahit.kaiju.out
    """  
    
}




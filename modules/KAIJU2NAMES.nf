nextflow.enable.dsl=2

process KAIJU2NAMES {
    
    publishDir("results/${sample_id}/kaiju/raw", pattern: "*.out", mode: 'copy')

    input:
    tuple val(sample_id), path(tree)
    path(nodes)
    path(names)
    
    output:
    tuple val(sample_id), path("*.out"), emit: names
    
    script:
    """
    kaiju-addTaxonNames \
    -t ${nodes} \
    -n ${names} \
    -i ${tree} \
    -u \
    -p \
    -o ${sample_id}_kaiju_names_raw.out
    """  
    
}


// -u omits unclassified reads! 
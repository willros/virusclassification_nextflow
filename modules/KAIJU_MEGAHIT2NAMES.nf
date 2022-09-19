nextflow.enable.dsl=2

process KAIJU_MEGAHIT2NAMES {
    
    publishDir("results/${sample_id}/kaiju/megahit", pattern: "*.out", mode: 'copy')

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
    -p \
    -u \
    -o ${sample_id}_names_megahit.out
    """  
    
}


// -u omits unclassified reads! 
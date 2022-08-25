nextflow.enable.dsl=2

process KAIJU_MEGAHIT2NAMES {
    
    publishDir("${params.kaiju_out}/megahit", pattern: "*.out", mode: 'copy')

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
    -o ${sample_id}_names_megahit.out
    """  
    
}


// -u omits unclassified reads! 
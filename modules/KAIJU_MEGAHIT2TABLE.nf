nextflow.enable.dsl=2

process KAIJU_MEGAHIT2TABLE {
    
    publishDir("results/${sample_id}/kaiju/megahit", pattern: "*.tsv", mode: 'copy')

    input:
    tuple val(sample_id), path(tree)
    path(nodes)
    path(names)
    
    output:
    tuple val(sample_id), path("*.tsv"), emit: table
    
    script:
    """
    kaiju2table \
    -t ${nodes} \
    -n ${names} \
    -r genus \
    -e \
    -o ${sample_id}_table_megahit.tsv \
    ${tree}
    """  
    
}



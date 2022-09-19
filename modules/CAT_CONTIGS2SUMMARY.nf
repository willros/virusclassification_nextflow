nextflow.enable.dsl=2

process CAT_CONTIGS2SUMMARY {    
    publishDir("results/${sample_id}/cat", pattern: "*.txt", mode: 'copy')

    input:
    tuple val(sample_id), path(names)
    path(assembly)
    
    output:
    tuple val(sample_id), path('*.txt'), optional: true, emit: summary
   
    script:
    """
    CAT summarise \ 
    -i ${names} \
    -o CAT_${sample_id}__contigs_summary.txt \
    -c ${assembly}

    """ 
}


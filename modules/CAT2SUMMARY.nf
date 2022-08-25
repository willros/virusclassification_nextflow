nextflow.enable.dsl=2

process CAT2SUMMARY {    
    publishDir("${params.cat_out}", pattern: "*.txt", mode: 'copy')

    input:
    tuple val(sample_id), path(names)
    
    output:
    tuple val(sample_id), path('*.txt'), optional: true, emit: summary
   
    script:
    """
    CAT summarise \ 
    -i ${names} \
    -o CAT_${sample_id}_summary.txt
    """   
}


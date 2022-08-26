nextflow.enable.dsl=2

process CAT_CONTIGS {    

    input:
    tuple val(sample_id), path(assembly)
    path(database)
    path(taxonomy)
    
    output:
    tuple val(sample_id), path('*classification.txt'), optional: true, emit: classification
   
    script:
    """
    CAT contigs \
    -c ${assembly} \
    -d ${database} \
    -t ${taxonomy} 
    """   
}


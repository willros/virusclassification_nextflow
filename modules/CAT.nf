nextflow.enable.dsl=2

process CAT {    

    input:
    tuple val(sample_id), path(bins)
    path(database)
    path(taxonomy)
    
    output:
    tuple val(sample_id), path('*classification.txt'), optional: true, emit: classification
   
    script:
    bins_dir = bins[0].toRealPath().getParent()
    """
    CAT bins \
    -b ${bins_dir} \
    -d ${database} \
    -t ${taxonomy} \
    -s fa
    """   
}


nextflow.enable.dsl=2

process CAT_BINS2NAMES {    
    publishDir("${params.cat_out}", pattern: "*.txt", mode: 'copy')

    input:
    tuple val(sample_id), path(classification)
    path(taxonomy)
    
    output:
    tuple val(sample_id), path('*.txt'), optional: true, emit: names
   
    script:
    """
    CAT add_names \
    -i ${classification} \
    -o CAT_${sample_id}_bins_names.txt \
    -t ${taxonomy} \
    --only_official

    """   
}


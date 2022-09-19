nextflow.enable.dsl=2

process CAT_CONTIGS2NAMES {    
    publishDir("results/${sample_id}/cat", pattern: "*.txt", mode: 'copy')

    input:
    tuple val(sample_id), path(classification)
    path(taxonomy)
    
    output:
    tuple val(sample_id), path('*.txt'), optional: true, emit: names
   
    script:
    """
    CAT add_names \
    -i ${classification} \
    -o CAT_${sample_id}_contigs_names.txt \
    -t ${taxonomy} \
    --only_official
    """   
}


nextflow.enable.dsl=2

process CHECKV_MEGAHIT {    
    publishDir("results/${sample_id}/checkv", pattern: "*summary.tsv", mode: 'copy')

    input:
    tuple val(sample_id), path(assembly)
    path(database)
    
    output:
    tuple val(sample_id), path('*summary.tsv'), optional: true, emit: quality
   
    script:
    """
    checkv end_to_end \
    -d ${database} \
    ${assembly} \
    checkv_out 
    
    mv checkv_out/*summary.tsv ${sample_id}_quality_summary.tsv
    """   
}


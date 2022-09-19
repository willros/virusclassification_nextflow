nextflow.enable.dsl=2

process WRANGLE_BRACKEN {
    
    publishDir("results/${sample_id}/cleaned_files", pattern: "*.csv", mode: 'copy')

    input:
    tuple val(sample_id), path(bracken)
    
    output:
    tuple val(sample_id), path("*.csv"), emit: csv
    
    script:
    """
    wrangle_bracken.py \
    ${bracken} \
    ${sample_id}_bracken_raw
    """  
    
}




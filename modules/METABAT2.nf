nextflow.enable.dsl=2

process METABAT2 {

    publishDir("results/${sample_id}/metabat2", pattern: "*_bins*", mode: 'copy')

    input:
    tuple val(sample_id), path(assembly)
    path(bam)
    
    output:
    tuple val(sample_id), path("*_bins*"), optional: true, emit: bins    
    
    script:
    """
    metabat2 \
    -i ${assembly} \
    ${bam} \
    -m 1500 \
    -o ${sample_id}_bins 
    """  
    
}


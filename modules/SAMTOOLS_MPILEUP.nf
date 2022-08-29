nextflow.enable.dsl=2

process SAMTOOLS_MPILEUP {    

    publishDir("${params.samtools_out}", pattern: "*.tsv", mode: 'copy')
 
    input:
    path(bam)
    val(sample_id)
    
    output:
    tuple val(sample_id), path('*.tsv'), emit: coverage
    
    script:
    """
    samtools mpileup \
    -o coverage_${sample_id}.tsv \
    -a \
    ${bam}
    """   
}


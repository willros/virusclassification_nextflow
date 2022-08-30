nextflow.enable.dsl=2

process SAMTOOLS {    

    input:
    tuple val(sample_id), path(sam)
    
    output:
    path('*.bam'), emit: bam
    path('*.bai'), emit: index
    val(sample_id), emit: sample_id
    
    script:
    """
    samtools view \
    -b \
    ${sam} | \
    samtools sort \
    -o ${sample_id}.bam \
    - 
    
    samtools index ${sample_id}.bam
    """   
}


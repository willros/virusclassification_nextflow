nextflow.enable.dsl=2

process SAMTOOLS {    

    publishDir("${params.bowtie2_align2contigs}/aligned", pattern: "*.bam", mode: 'copy')
    publishDir("${params.bowtie2_align2contigs}/aligned", pattern: "*.bai", mode: 'copy')


    input:
    tuple val(sample_id), path(sam)
    
    output:
    path('*.bam'), emit: bam
    path('*.bai'), emit: index
    
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


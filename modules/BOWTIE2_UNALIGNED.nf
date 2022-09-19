nextflow.enable.dsl=2

process BOWTIE2_UNALIGNED {    
    publishDir("results/${sample_id}/bowtie2", pattern: "*.log", mode: 'copy')

    input:
    tuple val(sample_id), path(reads)
    val(index)
    
    output:
    tuple val(sample_id), path('*unaligned*'), emit: reads
    path('*.log'), emit: log
    
    script:
    """
    bowtie2 \
    -x ${index} \
    -1 ${reads[0]} \
    -2 ${reads[1]} \
    -S ${sample_id}_aligned.fastq \
    --un-conc ${sample_id}_unaligned.fastq \
    2> ${sample_id}.bowtie_raw.log
    """   
}


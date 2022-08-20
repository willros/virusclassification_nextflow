nextflow.enable.dsl=2

process BOWTIE2_ALIGN2CONTIGS {    
    publishDir("${params.bowtie2_align2contigs}/aligned", pattern: "*aligned.sam*", mode: 'copy')
    publishDir("${params.bowtie2_align2contigs}/log", pattern: "*.log", mode: 'copy')


    input:
    tuple val(sample_id), path(reads)
    val(index)
    
    output:
    tuple val(sample_id), path('*aligned.sam'), emit: sam
    path('*.log'), emit: log
    
    script:
    """
    bowtie2 \
    -x ${index} \
    -1 ${reads[0]} \
    -2 ${reads[1]} \
    -S ${sample_id}_aligned.sam \
    2> ${sample_id}.bowtie.log
    """   
}

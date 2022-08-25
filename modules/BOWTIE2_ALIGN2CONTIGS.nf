nextflow.enable.dsl=2

process BOWTIE2_ALIGN2CONTIGS {

    publishDir("${params.bowtie2_align2contigs}/log", pattern: "*.log", mode: 'copy')

    input:
    tuple val(sample_id), path(reads)
    path(index_files)
    
    output:
    tuple val(sample_id), path('*aligned.sam'), emit: sam
    path('*.log'), emit: log
    
    script:
    index = index_files[0].toRealPath().toString().split('\\.')[0]
    """
    bowtie2 \
    -x ${index} \
    -1 ${reads[0]} \
    -2 ${reads[1]} \
    -S ${sample_id}_aligned.sam \
    2> ${sample_id}.bowtie.log
    """   
}


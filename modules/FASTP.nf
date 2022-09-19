nextflow.enable.dsl=2

process FASTP {
    
    publishDir("results/${sample_id}/fastp", pattern: "*.html", mode: 'copy')

    input:
    tuple val(sample_id), path(reads)
    
    output:
    tuple val(sample_id), path("${sample_id}_filt_R*.fastq.gz"), emit: reads
    path("*.html"), emit: html
    
    script:
    """
    fastp \
    -i ${reads[0]} \
    -I ${reads[1]} \
    -o ${sample_id}_filt_R1.fastq.gz \
    -O ${sample_id}_filt_R2.fastq.gz \
    --detect_adapter_for_pe --length_required 30 \
    --cut_front --cut_tail --cut_mean_quality 10 \
    --html ${sample_id}.fastp.html 
    """  
    
}




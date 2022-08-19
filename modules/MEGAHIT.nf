nextflow.enable.dsl=2

process MEGAHIT {
    
    publishDir("${params.megahit_out}/", pattern: "${sample_id}.contigs.fa", mode: 'copy')

    input:
    tuple val(sample_id), path(reads)
    
    output:
    tuple val(sample_id), path("${sample_id}.contigs.fa"), emit: assembly
    
    script:
    """
    megahit \
    -1 ${reads[0]} \
    -2 ${reads[1]} \
    --out-dir megahit \
    --out-prefix ${sample_id}
    
    mv megahit/${sample_id}.contigs.fa ${sample_id}.contigs.fa
    """  
    
}




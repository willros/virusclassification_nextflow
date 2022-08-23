nextflow.enable.dsl=2

process METASPADES {
    
    publishDir("${params.metaspades_out}/", pattern: "*.fasta", mode: 'copy')

    input:
    tuple val(sample_id), path(reads)
    
    output:
    val(sample_id), emit: sample_id
    path("${sample_id}_contigs.fasta"), emit: contigs
    path("${sample_id}_scaffolds.fasta"), emit: scaffold

    
    script:
    """
    metaspades.py \
    -1 ${reads[0]} \
    -2 ${reads[1]} \
    -o metaspades
   
    
    mv metaspades/contigs.fasta ${sample_id}_contigs.fasta
    mv metaspades/scaffolds.fasta ${sample_id}_scaffolds.fasta

    """  
    
}




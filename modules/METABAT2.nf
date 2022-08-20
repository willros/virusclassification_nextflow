nextflow.enable.dsl=2

process METABAT2 {
    
    publishDir("${params.metabat2_out}/", pattern: "*.fasta", mode: 'copy')
    publishDir("${params.metabat2_out}/", pattern: "*.tsv", mode: 'copy')

    input:
    tuple val(sample_id), path(assembly)
    path(bam)
    
    output:
    tuple val(sample_id), path("*.fasta"), emit: bins
    path("*.tsv"), emit: logfile
    
    
    script:
    """
    metabat2 \
    -i ${assembly} \
    ${bam} \
    -o ${sample_id}_bins.fasta \
    -a ${sample_id}_bins.table.tsv 
    """  
    
}




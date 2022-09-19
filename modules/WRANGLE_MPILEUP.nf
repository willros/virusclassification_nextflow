nextflow.enable.dsl=2

process WRANGLE_MPILEUP {
    
    publishDir("results/${sample_id}/cleaned_files", pattern: "*.csv", mode: 'copy')

    input:
    tuple val(sample_id), path(coverage)
    
    output:
    tuple val(sample_id), path("*.csv"), emit: csv
    
    script:
    """
    wrangle_contig_info.py \
    ${coverage} \
    ${sample_id}_contigs_coverage_mpileup
    """  
    
}




nextflow.enable.dsl=2

process PLOT_CONTIG_COVERAGE {
    
    publishDir("results/${sample_id}/plots", pattern: "*.pdf", mode: 'copy')

    input:
    tuple val(sample_id), path(mpileup)
    
    output:
    tuple val(sample_id), path("*.pdf"), emit: plots
    
    script:
    """
    contig_coverage_plot.py \
    ${mpileup} \
    ${sample_id}
    """  
    
}




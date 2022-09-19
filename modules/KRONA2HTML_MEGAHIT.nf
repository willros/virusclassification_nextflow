nextflow.enable.dsl=2

process KRONA2HTML_MEGAHIT {
    
    publishDir("results/${sample_id}/kaiju/megahit", pattern: "*.html", mode: 'copy')

    input:
    tuple val(sample_id), path(krona)
    
    output:
    tuple val(sample_id), path("*.html"), emit: html
    
    script:
    """
    ktImportText \
    -o ${sample_id}_krona_megahit.html \
    ${krona}
    """  
    
}




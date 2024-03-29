nextflow.enable.dsl=2

process KRONA2HTML {
    
    publishDir("results/${sample_id}/kaiju/raw", pattern: "*.html", mode: 'copy')

    input:
    tuple val(sample_id), path(krona)
    
    output:
    tuple val(sample_id), path("*.html"), emit: html
    
    script:
    """
    ktImportText \
    -o ${sample_id}_kaiju_krona_raw.html \
    ${krona}
    """  
    
}




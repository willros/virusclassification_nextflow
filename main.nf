nextflow.enable.dsl=2

include { FASTP } from './modules/FASTP.nf'
include { BOWTIE2_UNALIGNED } from './modules/BOWTIE2_UNALIGNED.nf'
include { KAIJU } from './modules/KAIJU.nf'
include { KAIJU2KRONA } from './modules/KAIJU2KRONA.nf'
include { KRONA2HTML } from './modules/KRONA2HTML.nf'
include { KAIJU2TABLE } from './modules/KAIJU2TABLE.nf'
include { KRAKEN2 } from './modules/KRAKEN2.nf'
include { MEGAHIT } from './modules/MEGAHIT.nf'
include { MEGAHIT2LENGTH } from './modules/MEGAHIT2LENGTH.nf'
include { METABAT2 } from './modules/METABAT2.nf'
include { CONTIGS2INDEX } from './modules/CONTIGS2INDEX.nf'
include { BOWTIE2_ALIGN2CONTIGS } from './modules/BOWTIE2_ALIGN2CONTIGS.nf'
include { SAMTOOLS } from './modules/SAMTOOLS.nf'
include { METASPADES } from './modules/METASPADES.nf'
include { METASPADES2LENGTH } from './modules/METASPADES2LENGTH.nf'
include { KAIJU_MEGAHIT } from './modules/KAIJU_MEGAHIT.nf'
include { KAIJU_MEGAHIT2KRONA } from './modules/KAIJU_MEGAHIT2KRONA.nf'
include { KRONA2HTML_MEGAHIT } from './modules/KRONA2HTML_MEGAHIT.nf'
include { KAIJU_MEGAHIT2TABLE } from './modules/KAIJU_MEGAHIT2TABLE.nf'


// input files
files = channel.fromFilePairs( params.fastq_in, checkIfExists: true )

// bowtie for saving unaligned
index = channel.value( params.index )

// kaiju
nodes = channel.value( params.kaiju_nodes_refseq )
fmi = channel.value( params.kaiju_fmi_refseq )
names = channel.value( params.kaiju_names_refseq )

// kraken
kraken_db = channel.value( params.kraken_db_standard )


workflow {

    // PREPROCESS
    FASTP(files)
    BOWTIE2_UNALIGNED(FASTP.out.reads, index)
    
    // KAIJU TAXONOMY RAW READS
    KAIJU(BOWTIE2_UNALIGNED.out.reads, nodes, fmi)
    KAIJU2KRONA(KAIJU.out.tree, nodes, names)
    KRONA2HTML(KAIJU2KRONA.out.krona)
    KAIJU2TABLE(KAIJU.out.tree, nodes, names)
    
    // KRAKEN TAXONOMY RAW READS
    KRAKEN2(BOWTIE2_UNALIGNED.out.reads, kraken_db)
    
    // ASSEMBLY 
    MEGAHIT(BOWTIE2_UNALIGNED.out.reads)
    MEGAHIT2LENGTH(MEGAHIT.out.assembly)
    METASPADES(BOWTIE2_UNALIGNED.out.reads) 
    METASPADES2LENGTH(METASPADES.out.sample_id, METASPADES.out.contigs)
    
    // KAIJU TAXONOMY CONTIGS
    KAIJU_MEGAHIT(MEGAHIT.out.assembly, nodes, fmi)
    KAIJU_MEGAHIT2KRONA(KAIJU_MEGAHIT.out.tree, nodes, names)
    KRONA2HTML_MEGAHIT(KAIJU_MEGAHIT2KRONA.out.krona)
    KAIJU_MEGAHIT2TABLE(KAIJU_MEGAHIT.out.tree, nodes, names)
    
    // BINNING
    // changing to metaspades 
    CONTIGS2INDEX(METASPADES.out.sample_id, METASPADES.out.contigs)
    BOWTIE2_ALIGN2CONTIGS(BOWTIE2_UNALIGNED.out.reads, CONTIGS2INDEX.out.index)
    SAMTOOLS(BOWTIE2_ALIGN2CONTIGS.out.sam)
    METABAT2(METASPADES.out.sample_id, METASPADES.out.contigs, SAMTOOLS.out.bam)

}
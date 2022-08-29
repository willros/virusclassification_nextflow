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
include { KRAKEN_MEGAHIT } from './modules/KRAKEN_MEGAHIT.nf'
include { KRAKEN_METASPADES } from './modules/KRAKEN_METASPADES.nf'
include { CAT_BINS } from './modules/CAT_BINS.nf'
include { CAT_BINS2NAMES } from './modules/CAT_BINS2NAMES.nf'
include { BRACKEN_MEGAHIT } from './modules/BRACKEN_MEGAHIT.nf'
include { BRACKEN } from './modules/BRACKEN.nf'
include { KAIJU_MEGAHIT2NAMES } from './modules/KAIJU_MEGAHIT2NAMES.nf'
include { CAT_CONTIGS } from './modules/CAT_CONTIGS.nf'
include { CAT_CONTIGS2NAMES } from './modules/CAT_CONTIGS2NAMES.nf'
include { KAIJU2NAMES } from './modules/KAIJU2NAMES.nf'
include { SAMTOOLS_MPILEUP } from './modules/SAMTOOLS_MPILEUP.nf'
include { WRANGLE_MPILEUP } from './modules/WRANGLE_MPILEUP.nf'

// include { CAT_CONTIGS2SUMMARY } from './modules/CAT_CONTIGS2SUMMARY.nf'


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

// cat
cat_database = channel.value( params.CAT_database )
cat_taxonomy = channel.value( params.CAT_taxonomy )



workflow {

    // PREPROCESS
    FASTP(files)
    BOWTIE2_UNALIGNED(FASTP.out.reads, index)
    
    // KAIJU TAXONOMY RAW READS
    KAIJU(BOWTIE2_UNALIGNED.out.reads, nodes, fmi)
    KAIJU2KRONA(KAIJU.out.tree, nodes, names)
    KRONA2HTML(KAIJU2KRONA.out.krona)
    KAIJU2TABLE(KAIJU.out.tree, nodes, names)
    KAIJU2NAMES(KAIJU.out.tree, nodes, names)
    
    // KRAKEN TAXONOMY RAW READS
    KRAKEN2(BOWTIE2_UNALIGNED.out.reads, kraken_db)
    BRACKEN(KRAKEN2.out.kraken_report, kraken_db)
    
    // ASSEMBLY 
    MEGAHIT(BOWTIE2_UNALIGNED.out.reads)
    MEGAHIT2LENGTH(MEGAHIT.out.assembly)
    // METASPADES(BOWTIE2_UNALIGNED.out.reads) 
    // METASPADES2LENGTH(METASPADES.out.contigs)
    
    // KAIJU TAXONOMY CONTIGS MEGAHIT
    KAIJU_MEGAHIT(MEGAHIT.out.assembly, nodes, fmi)
    KAIJU_MEGAHIT2KRONA(KAIJU_MEGAHIT.out.tree, nodes, names)
    KRONA2HTML_MEGAHIT(KAIJU_MEGAHIT2KRONA.out.krona)
    KAIJU_MEGAHIT2TABLE(KAIJU_MEGAHIT.out.tree, nodes, names)
    KAIJU_MEGAHIT2NAMES(KAIJU_MEGAHIT.out.tree, nodes, names)

    // KRAKEN TAXONOMY CONTIGS READS MEGAHIT
    KRAKEN_MEGAHIT(MEGAHIT.out.assembly, kraken_db)
    BRACKEN_MEGAHIT(KRAKEN_MEGAHIT.out.kraken_report, kraken_db)
    
    // KRAKEN TAXONOMY CONTIGS READS METASPADES
    // KRAKEN_METASPADES(METASPADES.out.sample_id, METASPADES.out.contigs, kraken_db)
    
    // BINNING
    // changing to megahit 
    CONTIGS2INDEX(MEGAHIT.out.assembly)
    BOWTIE2_ALIGN2CONTIGS(BOWTIE2_UNALIGNED.out.reads, CONTIGS2INDEX.out.index)
    SAMTOOLS(BOWTIE2_ALIGN2CONTIGS.out.sam)
    METABAT2(MEGAHIT.out.assembly, SAMTOOLS.out.bam)
    
    // CAT TAXONOMY ON CONTIGS
    CAT_CONTIGS(MEGAHIT.out.assembly, cat_database, cat_taxonomy)
    CAT_CONTIGS2NAMES(CAT_CONTIGS.out.classification, cat_taxonomy)
    // CAT_CONTIGS2SUMMARY(CAT_CONTIGS2NAMES.out.names, MEGAHIT.out.assembly)
    
    // COVERAGE OF CONTIGS
    SAMTOOLS_MPILEUP(SAMTOOLS.out.bam, SAMTOOLS.out.sample_id)
    WRANGLE_MPILEUP(SAMTOOLS_MPILEUP.out.coverage)
    
    
    // if (METABAT2.out.bins != null){
    
        // TAXONOMY OF BINNING 
        // What to do if output from metabat2 is empty?? Skip this step then. But how? 
        // CAT_BINS(METABAT2.out.bins, cat_database, cat_taxonomy)
        // CAT_BINS2NAMES(CAT_BINS.out.classification, cat_taxonomy)
    
    
    // }
    
    
    
    

}
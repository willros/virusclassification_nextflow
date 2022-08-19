nextflow.enable.dsl=2

include { FASTP } from './modules/FASTP.nf'
include { BOWTIE2 } from './modules/BOWTIE2.nf'
include { KAIJU } from './modules/KAIJU.nf'
include { KAIJU2KRONA } from './modules/KAIJU2KRONA.nf'
include { KRONA2HTML } from './modules/KRONA2HTML.nf'
include { KAIJU2TABLE } from './modules/KAIJU2TABLE.nf'
include { KRAKEN2 } from './modules/KRAKEN2.nf'
include { MEGAHIT } from './modules/MEGAHIT.nf'
include { MEGAHIT2LENGTH } from './modules/MEGAHIT2LENGTH.nf'


// input files
files = channel.fromFilePairs( params.fastq_in, checkIfExists: true )

// bowtie
index = channel.value( params.index )

// kaiju
nodes = channel.value( params.kaiju_nodes_refseq )
fmi = channel.value( params.kaiju_fmi_refseq )
names = channel.value( params.kaiju_names_refseq )

// kraken
kraken_db = channel.value( params.kraken_db_standard )


workflow {

    FASTP(files)
    BOWTIE2(FASTP.out.reads, index)
    KAIJU(BOWTIE2.out.reads, nodes, fmi)
    KAIJU2KRONA(KAIJU.out.tree, nodes, names)
    KRONA2HTML(KAIJU2KRONA.out.krona)
    KAIJU2TABLE(KAIJU.out.tree, nodes, names)
    KRAKEN2(BOWTIE2.out.reads, kraken_db)
    MEGAHIT(BOWTIE2.out.reads)
    MEGAHIT2LENGTH(MEGAHIT.out.assembly)
}
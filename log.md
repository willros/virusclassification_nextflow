## 2022-08-18
`To get BOWTIE2 process to run for every output tuple from FASTP, it was cruical to add the index as channel.value, to get the combinatorics!`

`bowtie`: The log file does not work with 2> .log... WHY?

#### Download kaiju virus db:
```bash
wget https://kaiju.binf.ku.dk/database/kaiju_db_viruses_2022-03-29.tgz
tar zxvf kaiju_db_viruses_2022-03-29.tgz 
```

The kaiju process works but produces a non file... Maybe because it is also from the stdout channel? 

Everything is nonefile!! WHY???
**SOLUTION TO ABOVE PROBLEM**
I had the argument cleanup = true in the .config file, which deletes content of work file. Since I had NOT put the publishDir mode as copy, the final results were just a symlink to the deleted work directory!. 

## 2022-08-19 
* Think I need to run kaiju against bigger database, containing both bacteria and viruses. 
`download the refseq database from kaijus server`
```bash
wget https://kaiju.binf.ku.dk/database/kaiju_db_refseq_2022-03-23.tgz
tar zxvf kaiju_db_refseq_2022-03-23.tgz
```

In `krona2table`the -u flag exists, which: *Unclassified reads are not counted for the total reads when calculating percentages for classified reads.*
Include or not include this? 

The KAIJU2TABLE module results in the error:
`unknown recognition error type: groovyjarjarantlr4.v4.runtime.LexerNoViableAltException` and complains that it does not have an input file. 

Trying to run in outside Nextflow:
```bash
kaiju2table -t /home/viller/virusclass/databases/kaiju_db/refseq/nodes.dmp -n /home/viller/virusclass/databases/kaiju_db/refseq/names.dmp -r genus -e -o kaiju_summary.tsv Dol1_S19_L001.kaiju.out
```
The above command works! Why does it not work inside nextflow main.nf?

**NOW the KAIJU2TABLE works, without me changing anything...** WEIRD!! 

* Download standard kraken database from https://benlangmead.github.io/aws-indexes/k2
```bash 
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20220607.tar.gz
```
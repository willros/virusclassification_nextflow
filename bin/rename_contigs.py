#!/usr/bin/env python

import fire

def rename_contigs(file: str) -> None:
    '''
    Rename the files of contigs from megahit, to look like: >contig_1, >contig_2 etc. 
    
    file: The fasta file of contigs from megahit
    '''
    
    with open(file, 'r') as fasta:
        content = [line.strip() for line in fasta.readlines()]
    
    #write new file
    
    num = 1
    with open(file, 'w') as new_fasta:
        for line in content:
            if line.startswith('>'):
                line = f'>contig_{num}'
                num += 1
            print(line, file=new_fasta)


if __name__ == '__main__':
    fire.Fire(rename_contigs)

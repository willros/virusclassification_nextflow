#!/usr/bin/env python

import pandas as pd
import fire

def extract_length(file: str, name: str) -> None:
    '''
    Saves a .csv file with the length and name of the contigs from the megahit. 
    
    file: The fasta file of contigs from megahit
    name: The name of the .csv file (preferable the sample_id)
    '''
    
    with open(file, 'r') as fasta:
        content = fasta.readlines()
    
                                  
    (pd.DataFrame()
          .assign(info=[x.strip() for x in content if x.startswith('>')],
                  name=lambda x: x['info'].str.extract(r'>(.*?) flag'),
                  length=lambda x: x['info'].str.extract(r'len=(\d*)').astype(int),
                  sequence=[x.strip() for x in content if not x.startswith('>')])
          .drop(columns=['info'])
          .sort_values('length', ascending=False)
          .to_csv(f'{name}.csv', index=False)
    )
    

if __name__ == '__main__':
    fire.Fire(extract_length)

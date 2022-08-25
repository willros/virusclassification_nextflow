#!/usr/bin/env python

import pandas as pd
import fire

def extract_length(file: str, name: str) -> None:
    '''
    Saves a .csv file with the length and name of the contigs from the metaspades assembly. 
    
    file: The fasta file of contigs from megahit
    name: The name of the .csv file (preferable the sample_id)
    '''
    
    with open(file, 'r') as fasta:
        df = pd.DataFrame([line.strip() for line in fasta.readlines() if line.startswith('>')],
                          columns=['line'])
        
    (df
     .assign(length=lambda x: x['line'].str.extract(r'length_(\d*)').astype(int),
             name=lambda x: x['line'].str.extract(r'NODE_(\d*)'))
     .loc[:, ['length', 'name']]
     .assign(name=lambda x: x['name'].str.strip())
     .sort_values('length', ascending=False)
     .to_csv(f'{name}.csv', index=False)
    )
    

if __name__ == '__main__':
    fire.Fire(extract_length)

#!/usr/bin/env python
import fire
import pandas as pd

def wrangle_kaiju_raw(names_file: str, 
                      table_file: str,
                      name: str):
    '''
    Merges the kaiju names and kaiju table raw files and returns a workable csv file.
    '''
    
    kaiju_names = (pd.read_csv(names_file, 
                              sep='\t', 
                              header=None,
                              index_col=False, 
                              usecols=[2, 7],
                              names=['taxon_id', 'taxonomy'])
                   .dropna()
                   .assign(taxonomy=lambda x: x.taxonomy.str.split(';').str[:-1])
                   .explode('taxonomy')
                   .assign(taxonomy=lambda x: x.taxonomy.str.strip())
                  )
    
    kaiju_table = (pd.read_csv(table_file,
                              sep='\t',
                              usecols=[1, 2, 3, 4]) # add column 2: the number of reads
                   .dropna()
                   .assign(taxon_id=lambda x: x.taxon_id.astype(int))
                   .assign(percent=lambda x: x.percent / 100)
                  )
    
    merged = (pd.merge(kaiju_names, kaiju_table, on='taxon_id')
              .sort_values('percent', ascending=False)
              .drop_duplicates()
             )
    
    merged.to_csv(f'{name}.csv', index=False)


if __name__ == '__main__':
    fire.Fire(wrangle_kaiju_raw)
#!/usr/bin/env python
import fire
import pandas as pd
import numpy as np

def wrangle_bracken_species_raw(file: str, name: str):
    '''
    Reads in a bracken species tsv from bracken and wrangles it to a workable format.
    Returns a pd.DataFrame.
    '''
    
    bracken_raw = pd.read_csv(file, 
                              sep='\t', 
                              header=None, 
                              names=['percent', 'new_est_reads', 'unknown', 
                                     'level', 'tax_id', 'name'])
    
    bracken = (bracken_raw
                 .drop(columns=['unknown'])
                 .assign(percent=lambda x: x['percent'] / 100, 
                         domain=lambda x: np.select([x['name'].str.contains('Viruses'),
                                                     x['name'].str.contains('Bacteria'), 
                                                     x['name'].str.contains('Eukaryota')],
                                                                ['Virus', 'Bacteria', 'Eukaryota'], default=pd.NA))
                 .assign(domain=lambda x: x['domain'].fillna(method='ffill'))
                 .dropna()
                 .loc[lambda x: ~x.name.str.contains('cellular')]
                 .drop(columns=['new_est_reads'])
                )
    
    bracken.to_csv(f'{name}.csv', index=False)


if __name__ == '__main__':
    fire.Fire(wrangle_bracken_species_raw)

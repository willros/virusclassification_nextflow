#!/usr/bin/env python
import fire
import pandas as pd
import numpy as np

def wrangle_kaiju_megahit_cat(kaiju: str, 
                              cat: str, 
                              megahit: str, 
                              name: str) -> None:
    '''
    Wrangles and merges the CAT, kaiju and MEGAHIT output from the MEGAHIT contigs.
    :param str kaiju: The kaiju out name path
    :param str cat: The CAT out txt path
    :param str megahit: The path to the megahit csv file. 
    :param str name: Name of the new csv file. 
    :returns: New merged csv file
    '''
    
    kaiju_raw = pd.read_csv(kaiju,
                    sep='\t',
                    header=None,
                    usecols=[1, 2, 6, 7],
                    names=['name', 'taxon_id', 'aa_match', 'taxonomy'])
    
    megahit = pd.read_csv(megahit)

    kaiju = (kaiju_raw.merge(megahit, on='name', how='outer')
     .sort_values('length', ascending=False)
     #.dropna()
     .assign(taxonomy=lambda x: x.taxonomy.str.split(';').str[:-1])
     .assign(last_level_kaiju=lambda x: x.taxonomy.str[-1])
     .assign(second_level_kaiju=lambda x: x.taxonomy.str[-2])
     .assign(third_level_kaiju=lambda x: x.taxonomy.str[-3])
     .assign(kingdom_kaiju=lambda x: np.select([x.taxonomy.str[0] != 'cellular organisms'],
                                                   [x.taxonomy.str[0]],
                                                   default=x.taxonomy.str[1])))
    
    
    cat_raw = pd.read_csv(cat,
                  sep='\t')

    cat = (cat_raw
     .rename(columns={'# contig': 'name',
                      'species': 'last_level_cat',
                      'genus': 'second_level_cat',
                      'family': 'third_level_cat'})
    # .loc[lambda x: x.classification != 'no taxid assigned']
    # .loc[lambda x: x['superkingdom'] != 'no support']
    # .loc[lambda x: x['phylum'] != 'no support']
     .drop(columns=['lineage', 'lineage scores'])
           
    # DROPPED the if CAT does not have any output
    # OR add fillna(" ") to have str instead of NaN
     .fillna(" ")
     .assign(kingdom_cat=lambda x: x['superkingdom'].str[:-6])
     .drop(columns='superkingdom')
    )

    merged = kaiju.merge(cat, on='name', how='outer').sort_values('length', ascending=False)
    
    merged.to_csv(f'{name}.csv', index=False)

if __name__ == '__main__':
    fire.Fire(wrangle_kaiju_megahit_cat)
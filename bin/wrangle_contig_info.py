#!/usr/bin/env python
import fire
import pandas as pd

def wrangle_contig_info(file: str, name: str) -> None:
    """
    Wrangles the output csv from samtools mpileup to contain some more information.
    """
    coverage = pd.read_csv(file,
                       sep='\t', 
                       header=None, 
                       usecols=[0,1,3],
                       names=['contig', 'position', 'coverage'])
    

    coverage = (coverage
         .assign(median_coverage = lambda x: x.groupby('contig', as_index=False)['coverage'].transform(lambda x: x.median()))
         .assign(mean_coverage = lambda x: x.groupby('contig', as_index=False)['coverage'].transform(lambda x: x.mean()))
         .assign(length = lambda x: x.groupby('contig', as_index=False)['coverage'].transform(lambda x: x.size))
         .assign(coverage_per_base=lambda x: x.mean_coverage / x.length)
         .sort_values('coverage_per_base', ascending=False)
               )
    
    coverage.to_csv(f'{name}.csv', index=False)

if __name__ == '__main__':
    fire.Fire(wrangle_contig_info)

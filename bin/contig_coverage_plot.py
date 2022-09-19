#!/usr/bin/env python
import pandas as pd
import altair as alt
import numpy as np
from altair_saver import save
import fire

alt.data_transformers.disable_max_rows()

def plot_contig_coverage_facet(file: str,
                               name: str) -> None:
    '''
    Returns a pdf of plots for short, medium and long contig in the csv file generated from samtools mpileup and the 
    wrangle_contig_info.py script. 
    :params str file: Path to the samtools mpileup file in the cleaned_files folder.
    :params str name: The sample id. 
    :returns: 3 pdf files in the results/plot folder. 
    '''
    
    contigs_coverage = (pd.read_csv(file)
        .assign(category=lambda x: pd.cut(x.length, bins=[1, 500, 2500, np.inf],
                                          labels=['short', 'medium', 'long']))
        .assign(category=lambda x: pd.Categorical(x.category, ['short', 'medium', 'long']))
        .sort_values('category'))

    
    step_size = {'short': 50, 'medium': 150, 'long': 2000}
    colors = {"short": 'blue', "medium": 'green', "long": 'purple'}

    for contig in contigs_coverage.category.unique():
        
        base = alt.Chart().mark_line(color=colors[contig]).encode(
         alt.X('position:N', axis=alt.Axis(values=np.arange(0, 20000, step_size[contig]))),
         alt.Y('coverage:Q')
            ).properties(width=125, height=125)

        rule = alt.Chart().mark_rule(color='red').encode(
         alt.Y('mean(coverage):Q')
            ).properties(width=125, height=125)

        layered = (alt.layer(base, rule, data=contigs_coverage.loc[lambda x, contig=contig: x.category == contig])
         .encode(alt.Y(title='Coverage'),
                 alt.X(title='Position'))
         .facet('contig:N', columns=6, title=f'Coverage of contigs with {contig} length')
         .resolve_scale(y='independent', x='independent'))
        
        save(layered, f"{name}_{contig}_coverageplot.pdf")
    
        
if __name__ == '__main__':
    fire.Fire(plot_contig_coverage_facet)

    


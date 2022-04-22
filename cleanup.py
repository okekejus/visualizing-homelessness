#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""

@author: jokeke

"""

import numpy as np 
import pandas as pd 
import matplotlib as mpl 
import matplotlib.pyplot as plt

raw_data_2020 = pd.read_excel('data/2007-2020-PIT-Estimates-by-state.xlsx', sheet_name = "2020", na_values=['NA']).iloc[:57, :18].drop([3, 56])


types_changed = raw_data_2020[['Overall Homeless, 2020', 'Overall Homeless - Under 18, 2020', 
               'Overall Homeless - Age 18 to 24, 2020',
               'Overall Homeless - Over 24, 2020', 'Overall Homeless - Female, 2020',
               'Overall Homeless - Male, 2020', 'Overall Homeless - Transgender, 2020',
               'Overall Homeless - Gender Non-Conforming, 2020',
               'Overall Homeless - Non-Hispanic/Non-Latino, 2020',
               'Overall Homeless - Hispanic/Latino, 2020',
               'Overall Homeless - White, 2020',
               'Overall Homeless - Black or African American, 2020',
               'Overall Homeless - Asian, 2020',
               'Overall Homeless - American Indian or Alaska Native, 2020',
               'Overall Homeless - Native Hawaiian or Other Pacific Islander, 2020']].apply(pd.to_numeric)

raw_data_2020[['Overall Homeless, 2020', 'Overall Homeless - Under 18, 2020', 
               'Overall Homeless - Age 18 to 24, 2020',
               'Overall Homeless - Over 24, 2020', 'Overall Homeless - Female, 2020',
               'Overall Homeless - Male, 2020', 'Overall Homeless - Transgender, 2020',
               'Overall Homeless - Gender Non-Conforming, 2020',
               'Overall Homeless - Non-Hispanic/Non-Latino, 2020',
               'Overall Homeless - Hispanic/Latino, 2020',
               'Overall Homeless - White, 2020',
               'Overall Homeless - Black or African American, 2020',
               'Overall Homeless - Asian, 2020',
               'Overall Homeless - American Indian or Alaska Native, 2020',
               'Overall Homeless - Native Hawaiian or Other Pacific Islander, 2020']] = types_changed


                                                                                                       
                                                                                                       
# Renaming columns 
raw_data_2020.columns = ["State", "Total.Population","CoC", "Total.Homeless", "Homeless.U18", "Homeless.18.to.24", 
              "Homeless.Over.24", "Homeless.Female", "Homeless.Male", "Homeless.Trans", 
              "Homeless.NC", "Homeless.Non.Lat", "Homeless.Lat", "Homeless.White", 
              "Homeless.Black", "Homeless.Asian", "Homeless.Indian", "Homeless.Native"]

raw_data_2020['Homeless.Under.24'] = np.add(raw_data_2020['Homeless.U18'],raw_data_2020['Homeless.18.to.24'])

raw_data_2020 = raw_data_2020.drop(['Homeless.U18', 'Homeless.18.to.24'], axis=1)

raw_data_2020['Homeless.Rate'] = np.multiply(np.divide(raw_data_2020['Total.Homeless'], raw_data_2020['Total.Population']), 10000)


# including regions 
regions = pd.read_csv('data/Regions.csv').drop([55])

    
new_frame = pd.merge(raw_data_2020, regions)


plt.style.use('classic')

plt.hist(raw_data_2020['Homeless.Rate'], bins=40, color="#ADD8E6", edgecolor="black");

def homeless_rate(x): 
    data = np.multiply(np.divide(x, new_frame['Total.Population']), 10000)
    return data


new_frame.columns
rates = new_frame[['Total.Homeless',
       'Homeless.Over.24', 'Homeless.Female', 'Homeless.Male',
       'Homeless.Trans', 'Homeless.NC', 'Homeless.Non.Lat', 'Homeless.Lat',
       'Homeless.White', 'Homeless.Black', 'Homeless.Asian', 'Homeless.Indian',
       'Homeless.Native', 'Homeless.Under.24', 'Homeless.Rate']].apply(homeless_rate)

new_frame[['Total.Homeless',
       'Homeless.Over.24', 'Homeless.Female', 'Homeless.Male',
       'Homeless.Trans', 'Homeless.NC', 'Homeless.Non.Lat', 'Homeless.Lat',
       'Homeless.White', 'Homeless.Black', 'Homeless.Asian', 'Homeless.Indian',
       'Homeless.Native', 'Homeless.Under.24', 'Homeless.Rate']] = rates


new_frame.to_csv('data/New_Data_2020.csv')

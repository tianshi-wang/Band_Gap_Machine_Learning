'''
The module connect grepData.py and dataTreatment.py.
It pre-treats grepped entries:
1. Add atomic percentage of each element.
2. Look up dictionaries.py to convert entry values from string to float, e.g. 'point_group'
The output is a treated enrty_list for each examples.
Usage: entry_list_float = entryToFloat.entryToFloat(grepped_entry_list)
Tianshi Wang @ Udel
'''

import dictionaries

def entryToFloat(grepped_entry):
    try:
        grepped_entry['point_group'] = dictionaries.point_group_dic[grepped_entry['point_group']]
    except KeyError:
        grepped_entry['point_group'] = 0
    entry_float = grepped_entry
    return entry_float



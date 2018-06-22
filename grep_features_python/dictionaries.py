##
'''
This modules contains different dictionaries.
The dictionaries are needed when mapping strings to float numbers.
For example, we assume band gap may relate to crystal symmetry such as point_group. However, randomly assign each
point group a number will not capture that information. In this case, we mapping point_group to the number of possible
symmetry operations, e.g. m:2 and m-3m:48.
The dictionaries shows the mapping relationship.
Tianshi Wang @Udel

'''

point_group_dic = {
'1':1,
'-1':2,
'2':2,
'm':2,
'2/m':4,
'222':4,
'mm2':4,
'mmm':8,
'4':4,
'-4':4,
'4/m':8,
'422':8,
'4mm':8,
'-42m':8,
'4/mmm':16,
'3':3,
'-3':6,
'32':6,
'3m':6,
'-3m':12,
'6':6,
'-6':6,
'6/m':12,
'622':12,
'6mm':12,
'-62m':12,
'6/mmm':24,
'23':12,
'm-3':24,
'432':24,
'-43m':24,
'm-3m':48
}

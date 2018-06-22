'''
fomularToElementDict: transfer a list of compound fomula to a list of dictionaries in the form {Si:1, O:2}
'''

import re
from elementsInfo import ELEMENTS

class ElementDictList(object):
    def __init__(self,compoundFomulaList):
        self.elementDictList = []           # Each member is a dictionary {'Fe':1,'O':2}
        self.elementList = []      # Each member is a list ['Fe', 'O']
        self.sortedElementList = []    # Same as self.elementList, except elements are sorted w.r.t. elenegativity.
        self.compoundFomulaList = compoundFomulaList

    def fomulaToElementDict(self):
        compoundIndex = 0
        for fomula in self.compoundFomulaList:
            singleElementDict={}
            elements = re.findall('[A-Z][^A-Z]*', fomula)   # Now in the form ['Fe2', 'O3', 'Ni']
            for element in elements:                   # element in the form 'Fe2'
                element = re.split('(\d+)',element)    # element in the form ['Fe', 2]
                try:
                    element.remove('')
                except ValueError:
                    pass
                if len(element)==1:
                    singleElementDict[element[0]]=1
                elif len(element)==2:
                    singleElementDict[element[0]]=int(element[1])     # created a dictionary {'Fe':2, 'O':3,'Ni':1}
            self.elementDictList.append(singleElementDict)
            self.elementList.append([*singleElementDict.keys()])
        return

    # Sort element with respect to its electron-negativity.

    def sortElements(self):
        for elementlist in self.elementList:
            ele_eleneg_dic = {}  # a dictionary: {element:electron_negativity, ...}
            print(elementlist)
            for element in elementlist:
                elementInfo = ELEMENTS[element]
                ele_eleneg_dic[element] = elementInfo.eleneg
                sortedElementList = sorted(ele_eleneg_dic, key=ele_eleneg_dic.get)
            self.sortedElementList.append(sortedElementList)
        # Add more element so that len(sortedElementList)==4
        #     for i in range(len(sortedElementList), 4):
        #         sortedElementList.append('empty')
        return



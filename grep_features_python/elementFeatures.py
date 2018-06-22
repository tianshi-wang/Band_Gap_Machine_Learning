from elementsInfo import ELEMENTS
import numpy as np

def dataTreatElement(list):
# Add useful features ('element1', 'element2', 'element3', 'element4')
    i = 0    # example (compound) index, n
    j = 0   # element index, every element takes three column.
    elementFeatureMatrix=np.zeros(0)
    max_element_num = 4
    while i < len(list.sortedElementList):        # Iteration over compounds.
        elements = list.sortedElementList[i]
        elementDict = list.elementDictList[i]
        # sort the elements according to their electron_negtivity
        singleCompoundFeatureList = np.zeros(0)   # All features for all elements. Ele1_fea1, ele1_fea2,..,elen_feam
        for element in elements:
            elementInfo = ELEMENTS[element]
            elementFraction = elementDict[element]/sum(elementDict.values())
            singleElementFeatures = [elementFraction, elementInfo.group, elementInfo.period, elementInfo.mass, elementInfo.eleneg, elementInfo.eleaffin,
                                     elementInfo.covrad, elementInfo.atmrad, elementInfo.vdwrad ,elementInfo.tmelt ]
            singleCompoundFeatureList = np.append(singleCompoundFeatureList,singleElementFeatures)
        if len(elements)<4:
            for j in range(len(elements),4):
                singleCompoundFeatureList = np.append(singleCompoundFeatureList, np.zeros(len(singleElementFeatures)))
        if i==0:
            elementFeatureMatrix = singleCompoundFeatureList
        else:
            elementFeatureMatrix = np.vstack([elementFeatureMatrix,singleCompoundFeatureList])
        i += 1
    return elementFeatureMatrix
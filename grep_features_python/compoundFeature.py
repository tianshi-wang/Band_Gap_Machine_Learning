#Input a list of material fomula (e.g. Fe2O3)
#First, grep data from materialsproject
#Second, organize the grepped data for each material_id
#Thirdly, return the values with lowest energy (energy_above_hull==0)
#Each material return a (1,n) array.

# Usage: materialInfo=grepData([materia_list]), materialInfo.grep_dict_list, return grepped dictonary_list.
# The list is then treated by dataTreatment.py to get a n*m matrix.

# Tianshi Wang, Udel

# Accept grepData return: dictionaries
# Output a n*m matrix. All elements are float numbers.
# Import features module and elementsInfo module
# Usage: No need to create an instance. Import dataTreatment, treatedData = dataTreatment.dataTreat(grepped_dict_list)
# Tianshi Wang, Udel


from pymatgen import MPRester
import pymatgen
from pymatgen.analysis.phase_diagram import PhaseDiagram, PDPlotter
import numpy as np
import entryToFloat



class CompoundEntries(object):
    def __init__(self, materialsprojectKey, compoundFomulaList):
        self.rester = MPRester(materialsprojectKey)
        self.materialFormulaList = compoundFomulaList
        # self.features = ['element1','element2', 'formation_energy_per_atom' ]
        #self.featureSize=len(self.features)
        self.grepped_entry_list = [None]*len(self.materialFormulaList)
        self.compoundFeatureMatrix = np.array([])
        self.compoundFeatures = ['nsites', 'density', 'energy_per_atom', 'point_group']

    def dataPretreatment(self,data_stable_phase):
        data_stable_phase.update(data_stable_phase['spacegroup'])    # Add sub-dictionary to the main-dictionary.
        del data_stable_phase['spacegroup']  # Remove sub-dictionary.
        # remove 'cif' and 'icsd_ids' from dictionaries for they are too long.
        del data_stable_phase['cif']
        del data_stable_phase['icsd_ids']
        return data_stable_phase


    def grep(self,formula): # Give me one formula at a time. return one directory.
        try:
            data = self.rester.get_data(formula)  # data is list of directories.
        except pymatgen.ext.matproj.MPRestError:
            data = []

        j = 0
        if data == []:  # No data on MaterialsProject for this compound
            return []
        stable_phase_found = False
        while j<len(data):
            if data[j]['e_above_hull']==0:
                stable_phase_found = True
                data_stable_phase = data[j]
                break
            elif j == len(data)-1 and stable_phase_found == False:
                return []
                print("No 'e_above_hull'==0 for " + materialFormula)
            j += 1
        treated_data_stable_phase = self.dataPretreatment(data_stable_phase)
        treated_data_stable_phase = entryToFloat.entryToFloat(treated_data_stable_phase)
        return treated_data_stable_phase

    def grepCompoundFeatureMatrix(self):
        index = 0
        for formula in self.materialFormulaList:
            print(formula)
            stablePhaseEntry = self.grep(formula)
            singleCompoundFeature = []
            if stablePhaseEntry != []:
                for feature in self.compoundFeatures:
                    try:
                        singleCompoundFeature = np.append(singleCompoundFeature, stablePhaseEntry[feature])   # a list
                    except KeyError:
                        singleCompoundFeature = np.append(singleCompoundFeature, 0)
                if index==0:
                    self.compoundFeatureMatrix = singleCompoundFeature
                else:
                    self.compoundFeatureMatrix = np.vstack([self.compoundFeatureMatrix, singleCompoundFeature])
            elif stablePhaseEntry == []:         # retrived data is []. Add zeros.
                if index==0:
                    self.compoundFeatureMatrix = np.zeros(len(self.compoundFeatures))
                else:
                    self.compoundFeatureMatrix = np.vstack([self.compoundFeatureMatrix, np.zeros(len(self.compoundFeatures))])
            index += 1
        return






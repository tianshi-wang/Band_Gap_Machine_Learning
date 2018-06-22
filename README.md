# Band_Gap_Machine_Learning
Apply machine learning techniques to classify metal/nonmetal and to predict band gap. The features (the selected properties of an compound) are grepped from different databases.

To view the workflow, please go to the /workflow.
The /grep_features_python contains a Python script which can grep data from different databases and generate the training set, cross-validation set, and test set. To run it, please use a Python >= 3.5, and install Numpy and Pymatgen.

Those generated set can be used to train support vector machine (SVM) models using the MATLAB code in /SVM_MATLAB. In the MATLAB code,  the messages printed on screen and comments can help you. 

Tianshi Wang 
University of Delaware

https://tswang.wixsite.com/home

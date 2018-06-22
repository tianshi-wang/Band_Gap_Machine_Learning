%% Apply machine learning in predicting band gap of materials
% 
% The procedure:
% 1. Train SVM Classifier for metal/nonmetal classification.
% 2. Apply the classifier on test set.
% 3. Train SVM regression for bandgap prediction.
% 4. Apply the regression on test set.
%
% Datasets
% 1. Totally 44 features for each compound.
% 2. The first 40 features are element-related, while the rest depends on
% crystal structure.
% 3. The features were collected from element-database and MaterialsProject
% using our in-house Python code:
% 4. The y values in dataSetClassfication are only +1(metal) and -1(non-metal).
% 5. The y values in dataSetBandgap are experimental band gap for nonmetals.
%
% Tianshi Wang @ University of Delaware

%% Initialization
clear ; close all; clc


%% ============= Part 1: Train SVM Classifier ===============
% For each C in paraSet
% 1. Calculate SVM model using traningSet.
% 2. Get the cost for both trainingSet and CVSet
% 3. Compare the costs matrix. Choose C minimizing cost of CVSet. 

fprintf('Start to train SVM Classifier for classifying metal and nonmetal\n')
fprintf('The task is to choose the kernel and BoxConstraint \n')
fprintf('First we use Gaussian kernel. To try other kernels, change "KernelFunction".\n')

% Load from csv files. 
% The files are converted from python output file using MS Excel.

XTrain = csvread('./dataSetClassification/trainingSetX.txt');
yTrain = csvread('./dataSetClassification/trainingSetY.txt');
Xcv = csvread('./dataSetClassification/cvSetX.txt');
ycv = csvread('./dataSetClassification/cvSetY.txt');


formatSpec = 'Data loaded: XTrain (size of %d*%d), yTrain (%d*%d),Xcv (%d*%d),and ycv(%d*%d).\n';
fprintf(formatSpec, size(XTrain), size(yTrain), size(Xcv), size(ycv))

% Train SVM classifier 
paraSet = [0.0001, 0.001, 0.01, 0.02, 0.04, 0.08, 0.16, 0.32, 0.64, 1.28,...
    2.56, 5.12, 10.24, 20.48, 40.96, 81.92, 163.84, 327.68];
costMatrix = zeros(length(paraSet),3);

fprintf('\nCalculating performance of SVM Classifier using different BoxConstraint...\n')
fprintf('boxConstraint Error_train  Errort_CV \n')

for cIndex = 1:length(paraSet)
    C = paraSet(cIndex);
    model = fitcsvm(XTrain, yTrain, 'KernelFunction', 'rbf',...
        'BoxConstraint', C,...
        'KernelScale', 'auto', ...
        'ClassNames',[-1,1], ...
        'Standardize', true);
% Calculate cost for training set.
% The cost function is defined as mean(predictions not equal yval)
    costTraining = costFunctionClassification(XTrain, yTrain, model);
% Calculate cost for CV set.
    costCV = costFunctionClassification(Xcv, ycv, model);
    result = [C, costTraining, costCV];
    
    formatSpec = ' %10.4f  %10.4f %10.4f \n';
    fprintf(formatSpec, result)
    costMatrix(cIndex,:)=result;
end
fprintf('\nTraining Done for SVM Classifier!\n')
fprintf('The chosen C should give us the lowest prediction error on CV set.\n')
fprintf('Press any key to use the trained model to predict metal/nonmetal for compounds in testset.\n')
pause;

% Output for second order polynomial (C=0.08):
%      C     costTraining cost_CV
%     0.0010    0.0843    0.1250 
%     0.0100    0.0567    0.1033  
%     0.0200    0.0513    0.1000  
%     0.0400    0.0437    0.0983  
%     0.0800    0.0380    0.0933  
%     0.1600    0.0343    0.1000  
%     0.3200    0.0307    0.1067  
%     0.6400    0.0300    0.1100 
%     1.2800    0.0257    0.1167   
%     2.5600    0.0210    0.1150  
%     5.1200    0.0170    0.1233  


%% ========== Part 2: Apply the trained model on Testset ================
%  The following code will load the next dataset into your environment and 
%  plot the data. 
%

fprintf('\nCalculating on testSet using the chosen model and C.\n')
XTest = csvread('./dataSetClassification/testSetX.txt');
yTest = csvread('./dataSetClassification/testSetY.txt');

% The chosen Kernel from last part is second order polynomial.
% The selected C is 0.08.

C_selected = 2.56;
model = fitcsvm(XTrain, yTrain, 'KernelFunction', 'rbf',...
    'BoxConstraint', C_selected,...
    'KernelScale', 'auto', ...
    'ClassNames',[-1,1], ...
    'Standardize', true);
% Calculate cost for Testset
costTest = costFunctionClassification(XTest, yTest, model);

fprintf('SVM classificator training done!\n')
formatSpec = 'Prediction accuracy is %.2f%% on testset with %d examples.\n';
fprintf(formatSpec, (1-costTest)*100, length(yTest))
fprintf('If everything goes well, the classification correction rate is ~89%%.\n')

plotClassification(XTest, yTest, model)

fprintf('Plotted classification results as shown in Fig.1 and Fig.2.\n')
fprintf('Press any key to start training SVM for bandgap prediction.\n')

pause;

%% ========== Part 3: Training Bandgap SVM with Kernels ==================
%  After you have implemented the kernel, we can now use it to train the 
%  SVM classifier.
% 
fprintf('\nTraining SVM with RBF Kernel (this may take 1 to 2 minutes) ...\n');
XTrainingBandgap = csvread('./dataSetBandgap/XtrainingBandgap.csv');
yTrainingBandgap = csvread('./dataSetBandgap/YtrainingBandgap.csv');
XcvBandgap = csvread('./dataSetBandgap/XcvBandgap.csv');
ycvBandgap = csvread('./dataSetBandgap/YcvBandgap.csv');

% SVM Parameters

% We set the tolerance and max_passes lower here so that the code will run
% faster. However, in practice, you will want to run the training to
% convergence.         'PolynomialOrder', 2 , ...
fprintf('   BoxConstraint  RMSE_training   RMSE_CV\n')
for cIndex = 1:length(paraSet)
    C = paraSet(cIndex);
    modelBandgap = fitrsvm(XTrainingBandgap, yTrainingBandgap, ...
        'KernelFunction', 'rbf',...
        'BoxConstraint', C,...
        'KernelScale', 'auto', ...
        'Standardize', true);
% Calculate cost for training set.
% The cost function is defined as mean(predictions not equal yval)
    [rmseTrainingBandgap, deviationTrain] = accuracyBandgap(XTrainingBandgap, ...
        yTrainingBandgap, modelBandgap);
% Calculate cost for CV set.
    [rmseCVBandgap,deviationCV] = accuracyBandgap(XcvBandgap, ycvBandgap, modelBandgap);

    rmseBandgap = [C, rmseTrainingBandgap, rmseCVBandgap];
    
    formatSpec = ' %10.4f   %12.4f   %12.4f\n';
    fprintf(formatSpec, rmseBandgap)
end

fprintf('\nSVM regression model training done!\n' )
fprintf('Again, the best boxconstraint shows lowerest RMSE on CV set.\n' )
fprintf('Press any key to start band gap prediction.\n')
pause;




%% =============== Part 4: Predict band gaps on testset ================
%  The following code will load the testset.
XtestBandgap = csvread('./dataSetBandgap/XtestBandgap.csv');
ytestBandgap = csvread('./dataSetBandgap/YtestBandgap.csv');
fprintf('\n Test set loaded.\n')

%The chosen kernel function and boxconstraint is rbf and 5.12, respectively.
C = 5.12;
modelBandgap = fitrsvm(XTrainingBandgap, yTrainingBandgap, ...
    'KernelFunction', 'rbf',...
    'BoxConstraint', C,...
    'KernelScale', 'auto', ...
    'Standardize', true);

% Calculate cost for training set.
% The cost function is defined as mean(predictions not equal yval)

[rmseTestBandgap, deviationTest] = accuracyBandgap(XtestBandgap, ytestBandgap, modelBandgap);
formatSpec = 'The rmse of bandgap prediction is %0.2f eV on testset.\n';
fprintf(formatSpec,rmseTestBandgap)

plotBandgap(XtestBandgap, ytestBandgap, modelBandgap)
fprintf('\nPlotted the predicted band gap compared experimental results in Fig.3.\n')
fprintf('All done! Thank you for trying the code.\n')

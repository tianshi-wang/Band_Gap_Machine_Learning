function cost = costFunctionClassification(X, y, model)

%Use the trained model to predict 
%scores(:,2) shows the scores for positive prediction.
%The predicted values are -1 or 1.
[~,scores] = predict(model,X);  
predictPositive = scores(:,2)./abs(scores(:,2));
% To print the predictions, uncomment the following line.
%[scores(:,2), predictPositive,y]
cost = mean(double(predictPositive~=y));
end

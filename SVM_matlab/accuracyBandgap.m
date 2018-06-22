function [rmse,deviation] = accuracyBandgap(X, y, model)

%Use the trained model to predict 
%scores(:,2) shows the scores for positive prediction.
%The predicted values are -1 or 1.
predictions = predict(model,X);  
% To print the predictions, uncomment the following line.
%[scores(:,2), predictPositive,y]
rmse = sqrt((predictions-y)'*(predictions-y)/length(y));
deviation = (predictions-y)./y;
end

function plotClassification(X,y,model)
    fprintf('\nNow calculating the prediction likelihood.\n')
    ScoreModel = fitPosterior(model);   %Score_to_postProbabilities
    [~,postProbs] = predict(ScoreModel,X); %postProbs[:,2]: probability of +1.
    [~,scores] = predict(model,X);  
    predictPositive = scores(:,2)./abs(scores(:,2));
    % results: prediction likelihood of metal, prediction, experimental
    % result.
    results = [postProbs(:,2),predictPositive,y];
    
    %trueMetal: Prediction==experiment==metal or 1
    %falseMetal: Prediction==nonmetal (-1), exp==metal (1)
    %trueNonmetal: Prediction==experiment==nonmetal
    %falseNonmetal: Prediction==metal, experiment==nonmetal
    trueMetal = results(results(:,2)==1&results(:,3)==1,:); 
    falseMetal = results(results(:,2)==-1&results(:,3)==1,:);
    trueNonmetal = results(results(:,2)==-1&results(:,3)==-1,:);
    falseNonmetal = results(results(:,2)==1&results(:,3)==-1,:);

    %Plot the numbers of TrueMetal, FalseMetal, TrueNonmetal, and
    %FalseNonmetal in a pie chart.
    figure;
    h=pie([length(trueMetal),length(falseMetal),length(trueNonmetal),length(falseNonmetal)]);
    title({'Metal/Nonmental Classification Results on Testset',''});
    hText = findobj(h,'Type','text');
    hText(1).String = {'TrueMetal: ', string(length(trueMetal))};
    hText(2).String = strcat('FalseMetal: ', string(length(falseMetal)));
    hText(3).String = {'TrueNonmetal: ', string(length(trueNonmetal))};
    hText(4).String = strcat('FalseNonmetal: ', string(length(falseNonmetal)));
    
     
    %Plot the prediction confidence.
    %The y axis has no physicl meaning, simply to convert 1D display to 2D.
    figure;
    scatter(trueMetal(:,1), rand(length(trueMetal),1), 'ro','filled')
    hold on;
    title('Metal/nonmetal classification confidence');
    scatter(falseMetal(:,1), rand(length(falseMetal),1), 'rx')
    scatter(trueNonmetal(:,1), rand(length(trueNonmetal),1), 'bo','filled')
    scatter(falseNonmetal(:,1), rand(length(falseNonmetal),1), 'bx')
    xticks([0,0.25,0.5,0.75,1])
    yticks([])
    xticklabels({'100%','75%','50%','75%','75%'})
    xlabel('Prediction confidence')
    legend('TrueMetal','FalseMetal', 'TrueNonmetal', 'FalseNonmetal',...
        'location', 'best')
    hold off;

end
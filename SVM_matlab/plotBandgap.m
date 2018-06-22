function plotBandgap(X, y, model)
    predictions = predict(model,X);  
    figure;
    scatter(y, predictions, 'ro','filled')
    maxBandgap = max(y);
    hold on
    plot([0,maxBandgap], [0,maxBandgap],'LineWidth',1,'color','b')
    xlabel('Experimental band gap (eV)')
    ylabel('Predicted band gap (eV)')
    title('Predicted band gap compared to experimental band gap')
end
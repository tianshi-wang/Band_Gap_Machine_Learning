function visualizeBoundaryLinear(X, y, model)


plotData(X, y);
hold on;
plot(X(model.IsSupportVector,1), X(model.IsSupportVector,2), 'ko')
% Add a grid to draw the boundary seperating -1 and 1.
[x1Grid,x2Grid] = meshgrid(min(X(:,1)):0.1:max(X(:,1)),...
    min(X(:,2)):0.1:max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
[~,scores] = predict(model,xGrid);
contour(x1Grid, x2Grid,reshape(scores(:,2),size(x1Grid)),[0,0],'k')
hold off

end

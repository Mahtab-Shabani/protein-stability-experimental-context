% Prepare features
X = double([ ...
    strcmp(T_DDG.ORGANISM, 'Escherichia coli'), ...
    isnan(T_DDG.PH), ...
    isnan(T_DDG.TM) ...
]);

y = T_DDG.DDG;

% Train regression model
mdl = fitlm(X, y);

% Prediction
y_pred = predict(mdl, X);

% Performance
RMSE = sqrt(mean((y - y_pred).^2))

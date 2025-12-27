%% 5.1 stabilizing / destabilizing
%% Binary classification
% ??G < 0 ? Stabilizing
% ??G > 0 ? Destabilizing

% Add stability label
isStabilizing = T_DDG.DDG < 0;

T_DDG.STABILITY = cell(height(T_DDG),1);
T_DDG.STABILITY(isStabilizing)  = {'Stabilizing'};
T_DDG.STABILITY(~isStabilizing) = {'Destabilizing'};


%% 5.2 Distribution of mutation stability
figure;
counts = [sum(isStabilizing), sum(~isStabilizing)];
bar(counts);
set(gca,'XTickLabel',{'Stabilizing','Destabilizing'});
ylabel('Number of mutations');
title('Distribution of mutation stability (FireProtDB mini)');

%% 5.3 Effect of experimental method on ??G variability
methods = unique(T_DDG.METHOD);
meanDDG = zeros(length(methods),1);
stdDDG  = zeros(length(methods),1);
nSample = zeros(length(methods),1);

for i = 1:length(methods)
    idx = strcmp(T_DDG.METHOD, methods{i});
    meanDDG(i) = mean(T_DDG.DDG(idx));
    stdDDG(i)  = std(T_DDG.DDG(idx));
    nSample(i) = sum(idx);
end

% Remove methods with very small sample size
valid = nSample >= 10;

figure;
errorbar(meanDDG(valid), stdDDG(valid), 'o');
hold on;

% Set ticks
set(gca,'XTick',1:sum(valid));
set(gca,'XTickLabel','');   % remove default labels

% Get Y limits safely (MATLAB 2014a compatible)
yl = ylim;
y = yl(1) - 0.05 * (yl(2) - yl(1));

x = 1:sum(valid);

validMethods = methods(valid);

for i = 1:length(x)
    text(x(i), y, validMethods{i}, ...
        'Rotation',45, ...
        'HorizontalAlignment','right', ...
        'VerticalAlignment','top', ...
        'FontSize',9);
end

ylabel('\Delta\DeltaG (kcal/mol)');
title('Effect of experimental method on \Delta\DeltaG variability');
box on;

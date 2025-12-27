%% 4- 
% Step 1 – Quick sanity check

validIdx = T_clean.DDG > -20 & T_clean.DDG < 20;
T_DDG = T_clean(validIdx, :);

disp('DDG-only dataset size:');
size(T_DDG)

% Distribution of DDG
summary(T_DDG)

% histogram
figure;
hist(T_DDG.DDG, 15);
xlabel('\Delta\DeltaG (kcal/mol)');
ylabel('Count');
title('Physically valid DDG distribution');



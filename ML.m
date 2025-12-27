stabIdx = T_DDG.DDG < 0;
destIdx = T_DDG.DDG > 0;

T_stab = T_DDG(stabIdx,:);
T_dest = T_DDG(destIdx,:);

% Oversample stabilizing
T_stab_os = T_stab(randi(height(T_stab), height(T_dest), 1), :);

T_balanced = [T_dest; T_stab_os];


%% Step 6.1 – Prepare ML dataset

% T_ML = T_DDG;
T_ML = T_balanced ;

% Remove rows with missing METHOD
valid = ~cellfun(@isempty, T_ML.METHOD);
T_ML = T_ML(valid,:);

disp('ML dataset size:');
size(T_ML)

%% Step 6.2 – Binary label

% Stabilizing = 1, Destabilizing = 0
Y = double(T_ML.DDG < 0);

%% Step 6.3 – Feature encoding

% METHOD ? numeric
[method_id, method_labels] = grp2idx(T_ML.METHOD);

% ORGANISM ? numeric
[org_id, org_labels] = grp2idx(T_ML.ORGANISM);

% PH and TM (numeric)
PH = T_ML.PH;
TM = T_ML.TM;

% Replace missing numeric values with median
PH(isnan(PH)) = nanmedian(PH);
TM(isnan(TM)) = nanmedian(TM);

% Feature matrix
X = [method_id, org_id, PH, TM];

% [ experimental method | organism | pH | melting temperature ]

%% Step 7 – Train/Test split

rng(1); % reproducibility
n = size(X,1);
idx = randperm(n);

train_ratio = 0.7;
nTrain = round(train_ratio * n);

X_train = X(idx(1:nTrain),:);
Y_train = Y(idx(1:nTrain));

X_test  = X(idx(nTrain+1:end),:);
Y_test  = Y(idx(nTrain+1:end));


%% Step 8 – Logistic Regression

B = glmfit(X_train, Y_train, 'binomial', 'link', 'logit');

% Prediction
Y_prob = glmval(B, X_test, 'logit');
Y_pred = Y_prob > 0.5;


%% Step 9 – Evaluation

accuracy = mean(Y_pred == Y_test);

disp(['Test Accuracy: ', num2str(accuracy)]);

%% Step 10 – Confusion Matrix

TP = sum((Y_pred == 1) & (Y_test == 1));
TN = sum((Y_pred == 0) & (Y_test == 0));
FP = sum((Y_pred == 1) & (Y_test == 0));
FN = sum((Y_pred == 0) & (Y_test == 1));

ConfMat = [TP FP; FN TN];

disp('Confusion Matrix [TP FP; FN TN]:');
disp(ConfMat)

%% Precision / Recall / F1

Precision = TP / (TP + FP);
Recall    = TP / (TP + FN);
F1        = 2 * (Precision * Recall) / (Precision + Recall);

disp(['Precision: ', num2str(Precision)])
disp(['Recall: ', num2str(Recall)])
disp(['F1-score: ', num2str(F1)])


%% Step 11 – Decision Tree Classifier

tree = fitctree(X_train, Y_train);

% Prediction
Y_tree = predict(tree, X_test);

% Accuracy
tree_acc = mean(Y_tree == Y_test);
disp(['Decision Tree Accuracy: ', num2str(tree_acc)]);

% show tree
view(tree,'Mode','graph');


%% 2- Find indices of required columns
targetCols = {'PROTEIN','ORGANISM','DDG','TM','PH','METHOD'};
colIdx = zeros(size(targetCols));

for i = 1:length(targetCols)
    colIdx(i) = find(strcmp(headers, targetCols{i}));
end

% Initialize cell arrays
PROTEIN = {};
ORGANISM = {};
DDG = [];
TM = [];
PH = [];
METHOD = {};

for i = 1:length(lines)
    parts = strsplit(lines{i}, ',');
    
    % Safety check
    if length(parts) >= max(colIdx)
        PROTEIN{end+1,1}  = parts{colIdx(1)};
        ORGANISM{end+1,1}= parts{colIdx(2)};
        DDG(end+1,1)     = str2double(parts{colIdx(3)});
        TM(end+1,1)      = str2double(parts{colIdx(4)});
        PH(end+1,1)      = str2double(parts{colIdx(5)});
        METHOD{end+1,1}  = parts{colIdx(6)};
    end
end

% Create table
T_small = table(PROTEIN, ORGANISM, DDG, TM, PH, METHOD);

disp('Mini-project dataset created successfully');
size(T_small)

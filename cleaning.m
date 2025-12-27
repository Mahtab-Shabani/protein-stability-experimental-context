% 3- Clean dataset 

%% --- Convert DDG safely ---
DDG_col = T_small.DDG;

if isnumeric(DDG_col)
    DDG_num = DDG_col;

elseif iscell(DDG_col)
    DDG_num = str2double(DDG_col);

elseif ischar(DDG_col)
    DDG_num = str2double(cellstr(DDG_col));

elseif isstring(DDG_col)
    DDG_num = str2double(DDG_col);

else
    error('Unknown DDG data type');
end

%% --- Same for TM ---
TM_col = T_small.TM;

if isnumeric(TM_col)
    TM_num = TM_col;
elseif iscell(TM_col)
    TM_num = str2double(TM_col);
elseif ischar(TM_col)
    TM_num = str2double(cellstr(TM_col));
elseif isstring(TM_col)
    TM_num = str2double(TM_col);
else
    TM_num = nan(height(T_small),1);
end

%% --- Same for PH ---
PH_col = T_small.PH;

if isnumeric(PH_col)
    PH_num = PH_col;
elseif iscell(PH_col)
    PH_num = str2double(PH_col);
elseif ischar(PH_col)
    PH_num = str2double(cellstr(PH_col));
elseif isstring(PH_col)
    PH_num = str2double(PH_col);
else
    PH_num = nan(height(T_small),1);
end

%% --- Build clean table (NO reassignment errors) ---
T_clean = table( ...
    T_small.PROTEIN, ...
    T_small.ORGANISM, ...
    DDG_num, ...
    TM_num, ...
    PH_num, ...
    T_small.METHOD, ...
    'VariableNames', {'PROTEIN','ORGANISM','DDG','TM','PH','METHOD'} ...
);

%% --- Remove missing DDG ---
validIdx = ~isnan(T_clean.DDG);
T_clean = T_clean(validIdx,:);

disp('Final clean dataset size:');
size(T_clean)



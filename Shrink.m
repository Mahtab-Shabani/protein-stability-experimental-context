%% 0- Shrinking 
clc;
clear;

inputFile  = 'fireprotdb_20251015-164116.csv';
outputFile = 'FireProtDB_small.csv';

% Open input file
fid_in = fopen(inputFile, 'r');
fid_out = fopen(outputFile, 'w');

% Read and write header line
headerLine = fgetl(fid_in);
fprintf(fid_out, '%s\n', headerLine);

% Number of data rows to extract
N = 50000;   % <<< decision here

% Copy first N rows
for i = 1:N
    line = fgetl(fid_in);
    if ~ischar(line)
        break;
    end
    fprintf(fid_out, '%s\n', line);
end

fclose(fid_in);
fclose(fid_out);

disp('Small dataset created successfully.');
disp('FireProtDB 50k dataset created successfully.');
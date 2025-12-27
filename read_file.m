%% 1 - Reading
clc;
clear;

filename = 'FireProtDB_small.csv';

fid = fopen(filename,'r');

% Read header line
headerLine = fgetl(fid);

% Split header into column names
headers = strsplit(headerLine, ',');

disp('Header columns detected:');
disp(headers');

% Read remaining lines as raw text
rawData = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);

lines = rawData{1};
disp(['Total data rows: ' num2str(length(lines))]);

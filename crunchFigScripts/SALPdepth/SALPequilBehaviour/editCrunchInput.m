%% This function takes a Crunchtope input file,
%  reads it in line by line, making each line an entry in the cell A.
%  It the replaces the specified line with a string of your choosing
%  and writes the resulting edited file out to a new file name of your choosing.
function editCrunchInput(lineNum, newLine)

% Read file into cell A line by line.
fid = fopen('slaveInput.in','r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);

% Change cell A.
A{lineNum} = newLine;

% Write cell A into an output file.
fid = fopen('slaveInput.in', 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
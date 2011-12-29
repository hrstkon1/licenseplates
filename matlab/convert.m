OUTPUT_FOLDER = 'output';
OUTPUT_FILE_PREFIX = 'data-';

INPUT_FILE = '../data/np-images-1000.mat';
%%
load(INPUT_FILE)

for i = 1:numel(data)
   fprintf('Processing %d / %d \n', i, numel(data)); 
   out = convertExampleIntoCellArray(data(i));
   if numel(out) 
       filename = sprintf('%s/%s%d.csv', OUTPUT_FOLDER, OUTPUT_FILE_PREFIX, i);
       fid = fopen(filename, 'w+');
       writeCellArrayIntoStream(out, fid);

       fclose(fid);
   else
       fprintf('ERROR\n');
   end
end
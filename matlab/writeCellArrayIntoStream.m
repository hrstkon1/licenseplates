function writeCellArrayIntoStream(data, fid)
    for i = 1:size(data,1)
        fprintf(fid, '%s\t', cell2mat(data(i,1)));
        for j = 2:size(data,2)-1
            fprintf(fid, '%.10f\t', cell2mat(data(i,j)));
        end
        fprintf(fid, '%.10f\n', cell2mat(data(i,size(data,2))));
    end
end


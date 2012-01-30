function out = convertExampleIntoCellArray(example, fid)
    USE_CROPPED_IMAGE = 1;
    
    if USE_CROPPED_IMAGE == 1 
        [data left] = cropInputImage(example.nimg);
        example.text.l = example.text.l - left + 1;
        example.text.r = example.text.r - left + 1;
    else
        data = example.img;
    end
    data = data';
    
    leftCharIndex = 1;

    i = 1;
    out = {};
    while i < size(data,1)
       if leftCharIndex < numel(example.text.l) && i == example.text.l(leftCharIndex)
           for j = 0:example.text.w(leftCharIndex)-1
             out = [out; getOutLine(data, i+j, example.text.str(leftCharIndex))];  
           end
           i = i+j;
           out = [out; '&' cell(size(data(i,:)))];
           leftCharIndex = leftCharIndex + 1;
       else
           if i < example.text.l(1)
               out = [out; getOutLine(data, i, '[')]; 
           elseif i > example.text.r(end)
                out = [out; getOutLine(data, i, ']')]; 
           else
                out = [out; getOutLine(data, i, '#')]; 
           end
       end
       i = i+1;
    end
end

function line = getOutLine(data, pos, char)
    line = [char num2cell(data(pos,:))];
end
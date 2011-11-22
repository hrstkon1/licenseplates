function out = convertExampleIntoMatrix(example, fid)
    USE_CROPPED_IMAGE = 1;
    
    if USE_CROPPED_IMAGE == 1 
        data = example.nimg;
    else
        data = example.img;
    end
    data = data';
    
    leftCharIndex = 1;
    rightCharIndex = 1;
    
    i = 1;
    out = {};
    while i < size(data,1)
       if leftCharIndex < numel(example.text.l) && i == example.text.l(leftCharIndex)
           for j = 0:example.text.w(leftCharIndex)-1
             out = [out; getOutLine(data, i+j, example.text.str(leftCharIndex))];  
           end
           i = i+j;
           leftCharIndex = leftCharIndex + 1;
       else
           out = [out; getOutLine(data, i, '#')]; 
       end
       i = i+1;
    end
end

function line = getOutLine(data, pos, char)
    line = [char num2cell(data(pos,:))];
end
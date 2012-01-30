function [out leftBound rightBound] = cropInputImage(img)
    criterion = @(x) sum(x) > 4;
    for i = 1:size(img, 2)
       if criterion(img(:,i))
           leftBound = i;
           break;
       end 
    end
    
    for i = fliplr(1:size(img, 2))
        if criterion(img(:,i))
            rightBound = i;
            break;
        end
    end
    
    out = img(:,leftBound:rightBound);
end


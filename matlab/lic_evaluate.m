function [p_d p_fa] = lic_evaluate(data, results)
    PERCENTAGE_LOWER_BOUND = 0.85;
    PERCENTAGE_UPPER_BOUND = 1.15;
    
    p_d = 0;
    p_fa = 0;
    allChars = 0;
    allSpaces = 0;
    for ii = 1:numel(data)
        ground_truth = data(ii);
        result = results{ii};
        
        [img, left] = cropInputImage(ground_truth.nimg);
        ground_truth.text.l = ground_truth.text.l - left + 1;
        ground_truth.text.r = ground_truth.text.r - left + 1;

        [chars columns] = get_label_string(result);
        
        for i = 1:numel(chars)
            result = 0;
            for j = 1:numel(ground_truth.text.str)
%                if strcmp(chars(i), ground_truth.text.str(j))
                    overlap = getOverlapPercentage([ground_truth.text.l(j) ground_truth.text.r(j)], columns(:, i));
                    if overlap >= PERCENTAGE_LOWER_BOUND && overlap <= PERCENTAGE_UPPER_BOUND
                        result = 1;
                        break;
                    end
 %               end
            end

            if result == 1
                p_d = p_d + 1;
            end
        end
        allChars = allChars + numel(chars);

        spacesColumns = getSpacesColumns(ground_truth.text.l, ground_truth.text.r, img);

        for i = 1:numel(chars)
            result = 0;
            for j = 1:size(spacesColumns, 2)
                overlap = getOverlapPercentage(spacesColumns(:, j), columns(:, i));
                if overlap >= PERCENTAGE_LOWER_BOUND && overlap <= PERCENTAGE_UPPER_BOUND
                    result = 1;
                    break;
                end
            end

            if result == 1
                p_fa = p_fa + 1;
            end
        end
        allSpaces = allSpaces + size(spacesColumns,2);
    end
    p_d = p_d / allChars; 
    p_fa = p_fa / allSpaces;
    
    if p_fa > 1
        p_fa = 1;
    end
end

function x = getOverlapPercentage(groundTruthInterval, resultInterval)
    a = groundTruthInterval(1):groundTruthInterval(2);
    b = resultInterval(1):resultInterval(2);
    x = numel(intersect(a,b))/numel(a);
end

function spacesColumns = getSpacesColumns(left, right, img)
    if left(1) > 1
        prev = 1;
        index = 1;
    else
        prev = 1;
        index = 2;
    end
    spacesColumns = [];
    for i = index:numel(left)
        spacesColumns = [spacesColumns [prev; left(i)]];
        prev = right(i);
    end
    spacesColumns = [spacesColumns [prev; size(img, 2)]];
end
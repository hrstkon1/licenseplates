function [labelsString, columns] = get_label_string(sj_labels) 
    STATE_LEFT_SPACE = 0;
    STATE_MIDDLE = 1;
    
    state = STATE_LEFT_SPACE;
    
    labelsString = [];
    columns = [];
    for i = 1:numel(sj_labels)
        isSpace = strcmp('#', sj_labels(i));
        
        switch state
            case STATE_LEFT_SPACE
                if isSpace == 0
                    state = STATE_MIDDLE;
                    middleString = sj_labels{i};
                    start = i;
                end
            case STATE_MIDDLE
                if isSpace == 1
                   state = STATE_LEFT_SPACE;
                   labelsString = [labelsString middleString(1)];
                   columns = [columns [start; i-1]];
                end
        end 
    end
    
    if state == STATE_MIDDLE
       labelsString = [labelsString middleString(1)];
       columns = [columns [start; i]]; 
    end
end


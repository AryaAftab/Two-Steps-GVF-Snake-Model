function [Precision, Recall, F_measure] = Calculate_fmeasure(input, output)
    % Calculate f-measure Index from sengmented area vs the output form photoshop Cs5
    %
    % input:
    %   input : sengmented area
    % ouput:
    %   output : sengmented area from photoshop Cs5

    TP = 0;
    TN = 0;
    FP = 0;
    FN = 0;
    for counter1 = 1:size(output, 1)
        for counter2 = 1:size(output, 2)
            if (input(counter1, counter2) == 1 && output(counter1, counter2) == 1)
                TP = TP + 1;
            end
            if (input(counter1, counter2) == 0 && output(counter1, counter2) == 0)
                TN = TN + 1;
            end
            if (input(counter1, counter2) == 1 && output(counter1, counter2) ==0 )
                FN = FN + 1;
            end    
            if (input(counter1, counter2) == 0 && output(counter1, counter2) ==1)
                FP = FP + 1;
            end           
        end
    end
    Precision = TP / (TP + FP)
    Recall = TP / (TP + FN)
    F_measure = 2 * (Precision * Recall) / (Precision + Recall)

function runTemporalMVPA(data, labels, timePoints, timePointNum, windowLength, stepSize,runNum)
    for r = 1:runNum
        [decodingACC, windowCenter] = MVPA(data, labels, timePoints, timePointNum, windowLength, stepSize);
        all_decoding(r, :) = decodingACC;
    end
    
    meanACC = mean(all_decoding, 1) * 100;
    semACC = std(all_decoding, 0, 1) / sqrt(runNum) * 100;
    
    figure;
    hold on;
    fill([windowCenter, fliplr(windowCenter)], ...
         [meanACC + semACC, fliplr(meanACC - semACC)], ...
         [1 0 0], 'EdgeColor', 'none', 'FaceAlpha', 0.7);
    
    plot(windowCenter, meanACC, 'b');  
    
    yline(50, 'k--', 'Chance Level', 'LabelHorizontalAlignment', 'left');
    
    xlabel('Time (ms)');
    ylabel('Accuracy (%)');
    title('Decoding Accuracy');
    grid on;
    ylim([30 100]);
end

function [decodingACC, windowCenter] = MVPA(data, label, timePoints,timePointNum, windowLength, stepSize)

    foldNum = 10; 
    splitData = cvpartition(label, 'KFold', foldNum, 'Stratify', true);

    start_times = 1:stepSize:(timePointNum - windowLength + 1);
    
    for idx = 1:length(start_times)
        t_start = start_times(idx);
        t_end = t_start + windowLength - 1;
    
        windowData = mean(data(:, :, t_start:t_end), 3);
%         windowData = reshape(data(:, :, t_start:t_end), size(data,1), []);

        for k = 1:foldNum
            train_indices = training(splitData, k);
            test_indices = test(splitData, k);
    
            X_train = windowData(train_indices, :);
            Y_train = label(train_indices);
    
            X_test = windowData(test_indices, :);
            Y_test = label(test_indices);
    
            svm_model = fitcsvm(X_train, Y_train, 'Standardize', true, ...
                                 'KernelFunction', 'linear', 'ClassNames', unique(Y_train));
    
            Y_predicted = predict(svm_model, X_test);
    
            foldACC(k) = sum(Y_predicted == Y_test) / length(Y_test);
        end
    
        decodingACC(idx) = mean(foldACC);
    end
    
    for i = 1:length(start_times)
        windowCenter(i) = mean(timePoints((i-1)*stepSize + 1:i*stepSize));
    end
end
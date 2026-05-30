function [timeGenMatrix, windowCenters] = MVPA_timeGeneralization(data, label, timePoints, timePointNum, windowLength, stepSize)

    foldNum = 10; 
    splitData = cvpartition(label, 'KFold', foldNum, 'Stratify', true);

    start_times = 1:stepSize:(timePointNum - windowLength + 1);
    num_windows = length(start_times);
    timeGenMatrix = zeros(num_windows, num_windows);

    % Precompute all time-windowed data
    for i = 1:num_windows
        t_start = start_times(i);
        t_end = t_start + windowLength - 1;
        windowedData{i} = mean(data(:, :, t_start:t_end), 3); 
    end

    % Time generalization loop
    for train_idx = 1:num_windows
        for test_idx = 1:num_windows
            for k = 1:foldNum
                train_indices = training(splitData, k);
                test_indices = test(splitData, k);

                X_train = windowedData{train_idx}(train_indices, :);
                Y_train = label(train_indices);

                X_test = windowedData{test_idx}(test_indices, :);
                Y_test = label(test_indices);

                model = fitcsvm(X_train, Y_train, ...
                    'Standardize', true, ...
                    'KernelFunction', 'linear', ...
                    'ClassNames', unique(Y_train));

                pred = predict(model, X_test);
                foldACC(k) = mean(pred == Y_test);
            end
            timeGenMatrix(train_idx, test_idx) = mean(foldACC);
        end
    end

    % Compute window centers for x/y axis labels
    for i = 1:num_windows
        t_start = start_times(i);
        t_end = t_start + windowLength - 1;
        windowCenters(i) = mean(timePoints(t_start:t_end));
    end

    % Plotting time generalization matrix
    figure;
    imagesc(windowCenters, windowCenters, timeGenMatrix);
    colorbar;
    xlabel('Testing Time (ms)');
    ylabel('Training Time (ms)');
    title('Time Generalization Matrix');
    axis square;
end

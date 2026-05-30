function spatialMVPA(data, labels, timePoints, chanlocs)

    [startTime, endTime] = getTimeWindowUI();

    [~, startIdx] = min(abs(timePoints - startTime));
    [~, endIdx] = min(abs(timePoints - endTime));

    windowData = mean(data(:, :, startIdx:endIdx), 3);  

    [nTrials, nChannels] = size(windowData);
    foldNum = 10;
    splitData = cvpartition(labels, 'KFold', foldNum, 'Stratify', true);
    channelACC = zeros(nChannels, 1);

    for ch = 1:nChannels
        acc_per_fold = zeros(foldNum, 1);
        for k = 1:foldNum
            train_idx = training(splitData, k);
            test_idx = test(splitData, k);

            X_train = windowData(train_idx, ch);  
            Y_train = labels(train_idx);

            X_test = windowData(test_idx, ch);
            Y_test = labels(test_idx);

            model = fitcsvm(X_train, Y_train, 'KernelFunction', 'linear', 'Standardize', true);
            pred = predict(model, X_test);

            acc_per_fold(k) = mean(pred == Y_test);
        end
        channelACC(ch) = mean(acc_per_fold);
    end

    figure;
    topoplot(channelACC, chanlocs, 'maplimits', [min(channelACC), max(channelACC)]);
    colorbar;
    title(sprintf('Spatial MVPA Accuracy (%d–%d ms)', timePoints(startIdx), timePoints(endIdx)));
end
function [startTime, endTime] = getTimeWindowUI()

    startTime = [];
    endTime = [];

    fig = uifigure("Name", 'Analysis Time', 'Position', [500 500 200 200]);
    uilabel(fig, "Text", 'Start Time (ms):', 'Position', [20 150 100 30]);
    startTimeText = uieditfield(fig, 'numeric', 'Position', [130 150 50 30]);
    uilabel(fig, "Text", 'End Time (ms):', 'Position', [20 100 100 30]);
    endTimeText = uieditfield(fig, 'numeric', 'Position', [130 100 50 30]);

    uibutton(fig,'Text','Done', 'Position', [75 50 50 30], ...
        'ButtonPushedFcn', @doneFunc);
    uiwait(fig);

    function doneFunc(~, ~)
        startTime = startTimeText.Value;
        endTime = endTimeText.Value;
        delete(fig);    
    end
end


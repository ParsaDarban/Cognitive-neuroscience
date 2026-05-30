function timeResolvedRDM(faceData, dollData, windowLength, stepSize)    
    face = faceData.data; 
    doll = dollData.data;

    faceLabels = [faceData.event.type];
    dollLabels = [dollData.event.type];

    faceIDs = mod(faceLabels, 1000);
    dollIDs = mod(dollLabels, 1000);

    uniqueFaceIDs = unique(faceIDs);
    uniqueDollIDs = unique(dollIDs);

    chNum = size(face, 1);
    timeNum = size(face, 2);

    nStimuli = length(uniqueFaceIDs) + length(uniqueDollIDs);

    meanDataFace = zeros(length(uniqueFaceIDs), chNum, timeNum);
    meanDataDoll = zeros(length(uniqueDollIDs), chNum, timeNum);

    for i = 1:length(uniqueFaceIDs)
        id = uniqueFaceIDs(i);
        idx = find(faceIDs == id);
        meanDataFace(i, :, :) = mean(face(:, :, idx), 3);
    end

    for i = 1:length(uniqueDollIDs)
        id = uniqueDollIDs(i);
        idx = find(dollIDs == id);
        meanDataDoll(i, :, :) = mean(doll(:, :, idx), 3);
    end

    labels = strings(nStimuli, 1);
    for i = 1:length(uniqueFaceIDs)
        labels(i) = "F" + string(i);
    end
    for i = 1:length(uniqueDollIDs)
        labels(length(uniqueFaceIDs) + i) = "N" + string(i);
    end

    nWindows = floor((timeNum - windowLength) / stepSize) + 1;

    rdmTimeWindowed = zeros(nStimuli, nStimuli, nWindows);

    for w = 1:nWindows
        windowIdx = (w-1)*stepSize + (1:windowLength);

        data_window = zeros(nStimuli, chNum);

        for stim = 1:length(uniqueFaceIDs)
            data_window(stim, :) = mean(meanDataFace(stim, :, windowIdx), 3);
        end

        for stim = 1:length(uniqueDollIDs)
            idxStim = length(uniqueFaceIDs) + stim;
            data_window(idxStim, :) = mean(meanDataDoll(stim, :, windowIdx), 3);
        end

        for i = 1:nStimuli
            for j = 1:nStimuli
                r = corr(data_window(i, :)', data_window(j, :)');
                rdmTimeWindowed(i, j, w) = 1 - r;
            end
        end
    end

    figure;
    imagesc(rdmTimeWindowed(:, :, 10));
    colormap(jet);
    colorbar;
    title('Time-resolved RDM');
    xticks(1:nStimuli);
    yticks(1:nStimuli);
    xticklabels(labels);
    yticklabels(labels);
    xtickangle(45);
    axis square;
end

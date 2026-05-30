function RDM(faceData, dollData)
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

    meanData = zeros(18, chNum * timeNum);  
    labels = strings(18,1);                 

    for i = 1:length(uniqueFaceIDs)
        id = uniqueFaceIDs(i);
        idx = find(faceIDs == id);  
        data_i = mean(face(:,:,idx), 3);  
        meanData(i, :) = data_i(:)';      
        labels(i) = "F" + string(i);      
    end

    for i = 1:length(uniqueDollIDs)
        id = uniqueDollIDs(i);
        idx = find(dollIDs == id);
        data_i = mean(doll(:,:,idx), 3);
        meanData(9+i, :) = data_i(:)';
        labels(9+i) = "N" + string(i);
    end

    rdm = zeros(18, 18);
    for i = 1:18
        for j = 1:18
            rdm(i,j) = 1 - corr(meanData(i,:)', meanData(j,:)');
        end
    end

    figure;
    imagesc(rdm);
    xticks(1:18); yticks(1:18);
    xticklabels(labels); yticklabels(labels);
    xtickangle(45);
    colormap(jet); colorbar;
    title('RDM (1 - correlation)');
end

function [data, labels, timePoints, chanlocs] = MVPAprepareData(faceData, dollData)
    face = faceData.data;
    doll = dollData.data;

    chNum = size(face,1);
    timePointNum = size(face,2);
    faceEpochNum = size(face,3);
    dollEpochNum = size(doll,3);

    if size(doll, 1) ~= chNum || size(doll, 2) ~= timePointNum
        error('Data must have same size');
    end

    faceLabel = ones(faceEpochNum, 1); 
    dollLabel = zeros(dollEpochNum, 1); 

    faceReshaped = permute(face, [3, 1, 2]); 
    dollReshaped = permute(doll, [3, 1, 2]); 
    
    data = cat(1, faceReshaped, dollReshaped);  % [trials x channels x time]
    labels = cat(1, faceLabel, dollLabel);
    timePoints = faceData.times;
    chanlocs = faceData.chanlocs;
end
function rdm = computeRDM(data, mode)
% data: [trials x channels x time]
% mode: 'average' یا 'time-resolved'
% خروجی:
%   rdm: اگر mode='average' → [trials x trials]
%        اگر mode='time-resolved' → [trials x trials x time]

    [trialNum, chNum, timeNum] = size(data);

    switch lower(mode)
        case 'average'
            avgPattern = mean(data, 3); % [trials x channels]
            rdm = computeDistanceMatrix(avgPattern);

        case 'time-resolved'
            rdm = zeros(trialNum, trialNum, timeNum);
            for t = 1:timeNum
                patterns = squeeze(data(:,:,t)); % [trials x channels]
                rdm(:,:,t) = computeDistanceMatrix(patterns);
            end

        otherwise
            error('Invalid mode. Choose "average" or "time-resolved".');
    end
end

function D = computeDistanceMatrix(X)
% X: [trials x features]
% D: [trials x trials] dissimilarity matrix based on 1 - correlation

    trialNum = size(X,1);
    D = zeros(trialNum);

    for i = 1:trialNum
        for j = 1:trialNum
            r = corr(X(i,:)', X(j,:)');
            D(i,j) = 1 - r;  % dissimilarity
        end
    end
end


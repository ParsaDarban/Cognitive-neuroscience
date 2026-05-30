function [data, labels, timePoints, timePointNum, chanlocs] = MVPAprepareData(faceData, dollData)
    
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
    
    data = cat(1, faceReshaped, dollReshaped); 
    labels = cat(1, faceLabel, dollLabel);
    timePoints = faceData.times;
    chanlocs = faceData.chanlocs;
end

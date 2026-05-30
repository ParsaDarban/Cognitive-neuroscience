function [faceData, dollData] = sortStimuli(data,faceData,dollData)
    datastr = load(data);
    sig = datastr.EEG;
    idx(1,:) = find(sig(64,:) ~= 0);
    labelStimu(1,:) = sig(64,idx);

    faceStimu = find(floor(labelStimu /10) == 496);
    faceStimuLabel = labelStimu(faceStimu);
    
    dollStimu = find(floor(labelStimu /10) == 436);
    dollStimuLabel = labelStimu(dollStimu);
    
    for i = 1:length([faceData.event.type])
        faceData.event(i).type = faceStimuLabel(i);
    end

    for i = 1:length([dollData.event.type])
        dollData.event(i).type = dollStimuLabel(i);
    end
end

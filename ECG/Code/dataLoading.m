function [face_data ,doll_data] = dataLoading(preProcessedData, sub496, sub436)
    face_data = pop_loadset('filename', sub496, 'filepath', preProcessedData);
    doll_data = pop_loadset('filename', sub436, 'filepath', preProcessedData);
end


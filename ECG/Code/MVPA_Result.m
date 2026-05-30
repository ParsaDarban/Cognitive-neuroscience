clc;clear;close all

%% subject1
preprocessedData = 'E:\UT\UT\8\Cognitive Neuroscience\HW\HW3\Preprocessed\Subject1';
[face_data ,doll_data] = dataLoading(preprocessedData, 'sub01_496.set', 'sub01_436.set');
[data, labels, timePoints, timePointNum, chanlocs] = MVPAprepareData(face_data, doll_data);
runTemporalMVPA(data, labels, timePoints, timePointNum, 50, 50,100);
spatialMVPA(data, labels, timePoints, chanlocs);
MVPA_timeGeneralization(data, labels, timePoints, timePointNum, 20, 20);

%% subject2
preprocessedData = 'E:\UT\UT\8\Cognitive Neuroscience\HW\HW3\Preprocessed\Subject2';
[face_data ,doll_data] = dataLoading(preprocessedData, 'sub02_496.set', 'sub02_436.set');
[data, labels, timePoints, timePointNum, chanlocs] = MVPAprepareData(face_data, doll_data);
runTemporalMVPA(data, labels, timePoints, timePointNum, 50, 50,100);
spatialMVPA(data, labels, timePoints, chanlocs);
MVPA_timeGeneralization(data, labels, timePoints, timePointNum, 20, 20);

%% subject3
preprocessedData = 'E:\UT\UT\8\Cognitive Neuroscience\HW\HW3\Preprocessed\Subject3';
[face_data ,doll_data] = dataLoading(preprocessedData, 'sub03_496.set', 'sub03_436.set');
[data, labels, timePoints, timePointNum, chanlocs] = MVPAprepareData(face_data, doll_data);
runTemporalMVPA(data, labels, timePoints, timePointNum, 50, 50,100);
spatialMVPA(data, labels, timePoints, chanlocs);
MVPA_timeGeneralization(data, labels, timePoints, timePointNum, 20, 20);

%% subject4
preprocessedData = 'E:\UT\UT\8\Cognitive Neuroscience\HW\HW3\Preprocessed\Subject4';
[face_data ,doll_data] = dataLoading(preprocessedData, 'sub04_496.set', 'sub04_436.set');
[data, labels, timePoints, timePointNum, chanlocs] = MVPAprepareData(face_data, doll_data);
runTemporalMVPA(data, labels, timePoints, timePointNum, 50, 50,100);
spatialMVPA(data, labels, timePoints, chanlocs);
MVPA_timeGeneralization(data, labels, timePoints, timePointNum, 20, 20);

%% subject5
preprocessedData = 'E:\UT\UT\8\Cognitive Neuroscience\HW\HW3\Preprocessed\Subject5';
[face_data ,doll_data] = dataLoading(preprocessedData, 'sub05_496.set', 'sub05_436.set');
[data, labels, timePoints, timePointNum, chanlocs] = MVPAprepareData(face_data, doll_data);
runTemporalMVPA(data, labels, timePoints, timePointNum, 50, 50,100);
spatialMVPA(data, labels, timePoints, chanlocs);
MVPA_timeGeneralization(data, labels, timePoints, timePointNum, 20, 20);

%% subject6
preprocessedData = 'E:\UT\UT\8\Cognitive Neuroscience\HW\HW3\Preprocessed\Subject6';
[face_data ,doll_data] = dataLoading(preprocessedData, 'sub06_496.set', 'sub06_436.set');
[data, labels, timePoints, timePointNum, chanlocs] = MVPAprepareData(face_data, doll_data);
runTemporalMVPA(data, labels, timePoints, timePointNum, 50, 50,100);
spatialMVPA(data, labels, timePoints, chanlocs);
MVPA_timeGeneralization(data, labels, timePoints, timePointNum, 20, 20);

%% subject7
preprocessedData = 'E:\UT\UT\8\Cognitive Neuroscience\HW\HW3\Preprocessed\Subject7';
[face_data ,doll_data] = dataLoading(preprocessedData, 'sub07_496.set', 'sub07_436.set');
[data, labels, timePoints, timePointNum, chanlocs] = MVPAprepareData(face_data, doll_data);
runTemporalMVPA(data, labels, timePoints, timePointNum, 50, 50,100);
spatialMVPA(data, labels, timePoints, chanlocs);
MVPA_timeGeneralization(data, labels, timePoints, timePointNum, 20, 20);

%% subject9
preprocessedData = 'E:\UT\UT\8\Cognitive Neuroscience\HW\HW3\Preprocessed\Subject9';
[face_data ,doll_data] = dataLoading(preprocessedData, 'sub09_496.set', 'sub09_436.set');
[data, labels, timePoints, timePointNum, chanlocs] = MVPAprepareData(face_data, doll_data);
runTemporalMVPA(data, labels, timePoints, timePointNum, 50, 50,100);
spatialMVPA(data, labels, timePoints, chanlocs);
MVPA_timeGeneralization(data, labels, timePoints, timePointNum, 20, 20);

%% subject10
preprocessedData = 'E:\UT\UT\8\Cognitive Neuroscience\HW\HW3\Preprocessed\Subject10';
[face_data ,doll_data] = dataLoading(preprocessedData, 'sub10_496.set', 'sub10_436.set');
[data, labels, timePoints, timePointNum, chanlocs] = MVPAprepareData(face_data, doll_data);
runTemporalMVPA(data, labels, timePoints, timePointNum, 50, 50,100);
spatialMVPA(data, labels, timePoints, chanlocs);
MVPA_timeGeneralization(data, labels, timePoints, timePointNum, 20, 20);
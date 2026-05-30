close all; clc; clear

%% Load Signal
sig = load('Sorting_data\singleIT.mat','data_IT');
sig = sig.data_IT;
fs = 30e3;
time = 0:1/fs:length(sig)/fs-1/fs;

%% Filtering
fc = 300;
filtered_sig = filtering(sig,fc,fs);

%% Detecting Spike
T = 5;
th = spike_threshold(filtered_sig,T,fs);
[single_spike, spike_indices] = peak_detector(filtered_sig, th, fs);

%% PCA + t-SNE & Clustering
pca_tsne_feature = pca_tsne(single_spike, 30);
elbow(pca_tsne_feature,(1:10));
k = 4;  
clustering(pca_tsne_feature,k);

%% Random t-SNE & Clustering
% rand_tsne_feature = random_tsne(single_spike, 10000);
% elbow(pca_tsne_feature,(1:10));
% k = 4;  
% clustering(rand_tsne_feature,k);

%% Function
function filter_sig = filtering(sig, fc, fs)
    wn = 2*(fc/fs);
    [a,b] = butter(7,wn,'high');
    filter_sig = filtfilt(a,b,sig);
end

function th = spike_threshold(data,T,fs)
    data_window = data(1:T*fs);  
    th = 0.9 * max(data_window);
end

function [single_spike, spike_indices] = peak_detector(data, theta, fs)

    d1 = diff(data);
    sign = d1(1:end-1) .* d1(2:end) <= 0; 
    peak_indices = find(sign) + 1; 
    valid_peaks = peak_indices(data(peak_indices) >= theta);

    pre_samples = round(0.002 * fs);  
    post_samples = round(0.002 * fs); 
    waveform_length = pre_samples + post_samples + 1;

    single_spike = NaN(length(valid_peaks), waveform_length);
    spike_indices = NaN(length(valid_peaks), 1);  

    count = 0; 

    for i = 1:length(valid_peaks)
        idx = valid_peaks(i);
        if idx - pre_samples >= 1 && idx + post_samples <= length(data)
            segment = data(idx - pre_samples : idx + post_samples);
            count = count + 1;
            single_spike(count, :) = segment';
            spike_indices(count) = idx;  
        end
    end

    single_spike = single_spike(1:count, :);
    spike_indices = spike_indices(1:count);  

    t = (1:waveform_length) / fs * 1000; 
    figure
    plot(t, single_spike')
    xlabel('Time (ms)')
    ylabel('Amplitude')
    grid on

    figure
    hold on
    for i = 1:1000:length(single_spike(:,1))
        plot(t, single_spike(i, :));
    end
    xlabel('Time (ms)');
    ylabel('Amplitude');
    grid on
end

function tsne_out = pca_tsne(spike, pca_feat_num)
    [~, score] = pca(spike);
    pca_features = score(:, 1:pca_feat_num);

    tsne_out = tsne(pca_features, 'NumDimensions', 3);
    
    scatter3(tsne_out(:,1), tsne_out(:,2), tsne_out(:,3), 10, 'filled');
   % title('3D t-SNE on PCA-reduced Spikes');
end

function rand_tsne_out = random_tsne(spike, random_idx)
    idx = randperm(size(spike, 1), random_idx); 
    sample_spikes = spike(idx, :);
    rand_tsne_out = tsne(sample_spikes, 'NumDimensions', 3);
    
    scatter3(rand_tsne_out(:,1), rand_tsne_out(:,2), rand_tsne_out(:,3), 10, 'filled');
    %title('3D t-SNE on PCA-reduced Spikes');
end

function elbow(features,k_range)
    sse = zeros(length(k_range), 1);
    
    for k = k_range
        [~, ~, sumd] = kmeans(features, k);
        
        sse(k) = sum(sumd);
    end
    
    figure;
    plot(k_range, sse, '-o');
    xlabel('Number of Clusters (k)');
    ylabel('Sum of Squared Errors (SSE)');
    %title('Elbow Plot for K-means Clustering');
    grid on;
end

function clustering(features,k)
    [idx, ~] = kmeans(features, k);    
    
    % tsne1 vs tsne2
    figure;
    subplot(1,3,1);
    scatter(features(:,1), features(:,2), 30, idx, 'filled');
    xlabel('t-sne 1');
    ylabel('t-sne 2');
    title('t-sne1 vs t-sne2');
    grid on;
    
    % tsne1 vs tsne3
    subplot(1,3,2);
    scatter(features(:,1), features(:,3), 30, idx, 'filled');
    xlabel('t-sne 1');
    ylabel('t-sne 3');
    title('t-sne1 vs t-sne3');
    grid on;
    
    % tsne2 vs tsne3
    subplot(1,3,3);
    scatter(features(:,2), features(:,3), 30, idx, 'filled');
    xlabel('t-sne 2');
    ylabel('t-sne 3');
    title('t-sne2 vs t-sne3');
    grid on;
    
    
    figure;
    scatter3(features(:,1), features(:,2),features(:,3), 8, idx, 'filled');
    xlabel('PC 1');
    ylabel('PC 2');
    zlabel('PC 3');
    % title('t-SNE with K-means Clustering');
    grid on;
end
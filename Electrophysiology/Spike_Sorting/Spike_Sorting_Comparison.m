close all; clc; clear

%% Real Spikes 
real_spike = load("Sorting_data\Spikes.mat","ind_spikes_it");
real_spike = real_spike.ind_spikes_it;
fs_spike = mean(diff(real_spike));
len_real_spike = length(real_spike);

%% Load Signal
sig = load('Sorting_data\singleIT.mat','data_IT');
sig = sig.data_IT;
fs = 30e3;
time = 0:1/fs:length(sig)/fs-1/fs;
% factor = round(length(sig)/max(real_spike));
% downsample_sig = downsample(sig,factor);

%% Filtering
fc = 300;
filtered_sig = filtering(sig,fc,fs);

%% Detecting Spike
theta = spike_threshold(filtered_sig);
[single_spike, spike_indices] = peak_detector(filtered_sig, theta, fs);

%%
factor = round(mean(diff(real_spike))/mean(diff(spike_indices)));
downsample_sig = downsample(spike_indices,30);

% %% PCA
% spike_feature = pca_feat(single_spike);
% 
% %% Clustering
% k_range = 1:10; 
% elbow(spike_feature,k_range)
% k = 5;
% clustering(spike_feature,k)

%% Functions
function filter_sig = filtering(sig, fc, fs)
    wn = 2*(fc/fs);
    [a,b] = butter(7,wn,'high');
    filter_sig = filtfilt(a,b,sig);
end

function theta = spike_threshold(data)
    sigma_n = median(abs(data)/0.6745);
    theta = 5 * sigma_n;
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

function features = pca_feat(spike)
    single_spike_m0 = spike - mean(spike, 1);
    [coeff,score,latent] = pca(single_spike_m0);

    explained_variance = 100 * latent / sum(latent);
    figure;
    bar(explained_variance(1:10))
    xlabel('Principal Component Index')
    ylabel('Variance Explained (%)')
    %title('PC Variance')
    grid on
    
    features = score(:, 1:3);  
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
    [idx, C, sumd] = kmeans(features, k);
    
    figure;
    subplot(1,3,1);
    scatter(features(:,1), features(:,2), 30, idx, 'filled');
    xlabel('PC 1');
    ylabel('PC 2');
    title('PC1 vs PC2');
    grid on;
    
    % PC1 vs PC3
    subplot(1,3,2);
    scatter(features(:,1), features(:,3), 30, idx, 'filled');
    xlabel('PC 1');
    ylabel('PC 3');
    title('PC1 vs PC3');
    grid on;
    
    % PC2 vs PC3
    subplot(1,3,3);
    scatter(features(:,2), features(:,3), 30, idx, 'filled');
    xlabel('PC 2');
    ylabel('PC 3');
    title('PC2 vs PC3');
    grid on;
    
    
    figure;
    scatter3(features(:,1), features(:,2),features(:,3), 8, idx, 'filled');
    xlabel('PC 1');
    ylabel('PC 2');
    zlabel('PC 3');
    % title('PC1 vs PC2 vs PC3');
    grid on;
end
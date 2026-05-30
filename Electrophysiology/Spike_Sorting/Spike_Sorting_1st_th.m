close all; clc; clear

%% Load and plot Signal and histogram of data
sig = load('Sorting_data\singleIT.mat','data_IT');
sig = sig.data_IT;
fs = 30e3;
time = 0:1/fs:length(sig)/fs-1/fs;
figure
plot(time,sig)
title('Recorded Signal')
ylabel('Amplitude(\muV)')
xlabel('Time(s)')

% Histogram 
figure
histogram(sig,500)
hold on;
pd = fitdist(sig(:), 'Normal');
x_vals = linspace(min(sig), max(sig),4000);
y_vals = pdf(pd, x_vals) * length(sig) * (x_vals(2) - x_vals(1));
plot(x_vals, y_vals*13, 'r', 'LineWidth', 3);

legend('Amplitude Histogram', 'Fitted Normal Distribution');
title('Signal Histogram')
ylabel('Frequency')

sig_mean = mean(sig);
sig_std = std(sig);

%% Filtering
fc = 300;
wn = 2*(fc/fs);
[a,b] = butter(7,wn,'high');
figure
freqz(a,b)
%title('Highpass Butterworth')
xlim([0 0.1])
ylim([-150 20])
filtered_sig = filtfilt(a,b,sig);
%%
figure
subplot(2,1,1)
plot(time,sig)
%title('Signal Before and After Filtering in Time Domain')
xlabel('Before')
ylabel('Amplitude(\muV)')
subplot(2,1,2)
plot(time,filtered_sig)
xlabel('After')
ylabel('Amplitude(\muV)')

% Frequency Domain
f = linspace(-fs/2, fs/2, length(sig));
sig_freq = fftshift(fft(sig));
filtered_sig_freq = fftshift(fft(filtered_sig)); 

figure
subplot(2,1,1)
plot(f, abs(sig_freq))
%title('Signal Before and After Filtering in Frequency Domain')
xlabel('Before')
ylabel('Amplitude')
xlim([-500 1000])
ylim([0 2e7])
subplot(2,1,2)
plot(f, abs(filtered_sig_freq))
xlabel('After')
ylabel('Amplitude')
xlim([-500 1000])

%% Detecting Spike
theta = spike_threshold(filtered_sig);
[single_spike, spike_indices] = peak_detector(filtered_sig, theta, fs);

%% PCA
single_spike_m0 = single_spike - mean(single_spike, 1);
[coeff,score,latent] = pca(single_spike_m0);

explained_variance = 100 * latent / sum(latent);
figure;
bar(explained_variance(1:10))
xlabel('Principal Component Index')
ylabel('Variance Explained (%)')
%title('PC Variance')
grid on

figure;
scatter(score(:,1), score(:,2), 8,'filled')
xlabel('PC 1')
ylabel('PC 2')
%title('PCA (2D)')
grid on

figure;
scatter3(score(:,1), score(:,2), score(:,3), 10, 'filled')
xlabel('PC 1')
ylabel('PC 2')
zlabel('PC 3')
%title('PCA (3D)')
grid on
view(45, 30);

%% Clustering
spike_feature = score(:, 1:3);  
k_range = 1:10; 
sse = zeros(length(k_range), 1);

for k = k_range
    [~, ~, sumd] = kmeans(spike_feature, k);
    
    sse(k) = sum(sumd);
end

figure;
plot(k_range, sse, '-o');
xlabel('Number of Clusters (k)');
ylabel('Sum of Squared Errors (SSE)');
%title('Elbow Plot for K-means Clustering');
grid on;

[idx, C, sumd] = kmeans(spike_feature, 5);

% PC1 vs PC2
figure;
subplot(1,3,1);
scatter(spike_feature(:,1), spike_feature(:,2), 30, idx, 'filled');
xlabel('PC 1');
ylabel('PC 2');
title('PC1 vs PC2');
grid on;

% PC1 vs PC3
subplot(1,3,2);
scatter(spike_feature(:,1), spike_feature(:,3), 30, idx, 'filled');
xlabel('PC 1');
ylabel('PC 3');
title('PC1 vs PC3');
grid on;

% PC2 vs PC3
subplot(1,3,3);
scatter(spike_feature(:,2), spike_feature(:,3), 30, idx, 'filled');
xlabel('PC 2');
ylabel('PC 3');
title('PC2 vs PC3');
grid on;


figure;
scatter3(spike_feature(:,1), spike_feature(:,2),spike_feature(:,3), 8, idx, 'filled');
xlabel('PC 1');
ylabel('PC 2');
zlabel('PC 3');
% title('PC1 vs PC2 vs PC3');
grid on;

%% Functions
function theta = spike_threshold(data)
    sigma_n = median(abs(data)/0.6745);
    theta = 5 * sigma_n;
end

function [single_spike, spike_indices] = peak_detector(data, theta, fs)

    diff_data = diff(data);
    sign = diff_data(1:end-1) .* diff_data(2:end) <= 0; 
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

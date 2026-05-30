close all; clear;clc

%% Raw data
data = load("dataVasati.mat");

%% Spike
spike = cat(3, data.SpikeTrain_it_all.data);

per_neuron_spike = cell(1, 92);
for i = 1:92
    per_neuron_spike{i} = spike(:, :, i);
end

%% Picture
stimLabels = zeros(1, 500); 

stimLabels(1:200)     = 1; % Face
stimLabels(201:320)   = 2; % Body
stimLabels(321:390)   = 3; % Natural
stimLabels(391:500)   = 4; % Artificial

pic = cell(2,92);
for i = 1:92
    pic{1,i} = [data.SpikeTrain_it_all(i).cm.index];
    pic{2,i} = stimLabels(pic{1,i});
end

%% Final Data 
final_data = cell(2,92);
[final_data{1,:}] = deal(per_neuron_spike{1,:});
[final_data{2,:}] = deal(pic{2,:});

%% Extract each category in neuron
for i = 1:92
    category = final_data{2,i};
    sig = final_data{1,i};

    faceInd = find(category == 1);
    bodyInd = find(category == 2);
    naturalInd = find(category == 3);
    artificialInd = find(category == 4);
    
    extracted_category_sig{1,i} = sig(faceInd,:);
    extracted_category_sig{2,i} = sig(bodyInd,:);
    extracted_category_sig{3,i} = sig(naturalInd,:);
    extracted_category_sig{4,i} = sig(artificialInd,:); 

end

%% PSTH
psth = cell(4, 92);
window_size = 20;  

for neuron = 1:92
    for category = 1:4
        psth_data = extracted_category_sig{category, neuron}; 
        mean_spike = mean(psth_data, 1);                      
        smooth_psth = movmean(mean_spike, window_size);       

        psth{category, neuron} = smooth_psth;
    end
end

%% PSTH plot
neuronInd = 1;
for neuron = [1,5,10,20,40,80,90,92]
    neuron_id = neuron;
    %figure;
    subplot(4,2,neuronInd)
    hold on;
    colors = ['r', 'g', 'b', 'k'];
    for c = 1:4
        plot(psth{c, neuron_id},Color=colors(c));
    end
    legend('Face', 'Body', 'Natural', 'Artificial')
    xlabel('Time')
    ylabel('Spike Rate')
    title(['PSTH for Neuron ' num2str(neuron_id)])

    neuronInd = neuronInd + 1;
end
%% Check most respond
for neuron = 1:92
    for category = 1:4
        psth_respond = psth{category, neuron}; 
        max_values(category) = max(psth_respond);  
    end

    [~, respond(neuron)] = max(max_values);  
end
counts = histcounts(respond, 1:1:5);  

disp(['Face: ' num2str(counts(1))])
disp(['Body: ' num2str(counts(2))])
disp(['Natural: ' num2str(counts(3))])
disp(['Artificial: ' num2str(counts(4))])

%% Fano Factor
window = 50;
step = 5;
[num_categories, num_neurons] = size(extracted_category_sig);
num_timepoints = size(extracted_category_sig{1,1}, 2);
num_windows = floor((num_timepoints - window)/step) + 1;

for neuron = 1:num_neurons
    for category = 1:num_categories
        spike_data = extracted_category_sig{category, neuron};  
        fano_factors = zeros(1, num_windows);

        for w = 1:num_windows
            start_idx = (w-1)*step + 1;
            end_idx = start_idx + window - 1;

            spike_counts = sum(spike_data(:, start_idx:end_idx), 2);  
            mu = mean(spike_counts);    
            sigma2 = var(spike_counts);  
            
            mu_vector(w) = mu;
            sigma2_vector(w) = sigma2;

            fano_factors(w) = sigma2 / mu; 
        end
        
        mu_cell{category,neuron} = mu_vector;
        sigma2_cell{category,neuron} = sigma2_vector;

        fano_factors = movmean(fano_factors, 3);
        fano_cell{category, neuron} = fano_factors;
    end
end
 
%% fano factor plot
neuronInd = 1;
figure;
for neuron = [1,5,10,20,40,80,90,92]
    neuron_id = neuron;
    subplot(4,2,neuronInd)
    hold on;
    colors = ['r', 'g', 'b', 'k'];
    for c = 1:4
        plot(fano_cell{c, neuron_id},Color=colors(c));
    end
    legend('Face', 'Body', 'Natural', 'Artificial')
    xlabel('Time')
    ylabel('Spike Rate')
    title(['Fano Factor for Neuron ' num2str(neuron_id)])

    neuronInd = neuronInd + 1;
end

%% Mean-Matched Fano Factor
for category = 1:num_categories
    slopes = zeros(1, num_windows);
    for w = 1:num_windows
        all_mu = [];
        all_sigma2 = [];
        for neuron = 1:num_neurons
            mu_val = mu_cell{category, neuron}(w);
            sigma2_val = sigma2_cell{category, neuron}(w);

            all_mu(end+1) = mu_val;
            all_sigma2(end+1) = sigma2_val;
        end
        p = polyfit(all_mu, all_sigma2, 1);
        slopes(w) = p(1);
    end
    mean_matched_slopes_per_category{category} = slopes;
end

%% Mean-Matched Fano Factor Result
figure;
hold on;
colors = ['r', 'g', 'b', 'k'];
labels = {'Face', 'Body', 'Natural', 'Artificial'};

for category = 1:num_categories
    plot(mean_matched_slopes_per_category{category}, 'Color', colors(category), 'LineWidth', 2);
end

xlabel('Time slice');
ylabel('Mean-matched Fano factor (slope)');
%title('Mean-Matched Fano Factor Over Time by Category');
legend(labels);
grid on;

%% One example for Mean-Matched Fano Factor in one window
window_to_plot = 54;
figure;
for category = 1:num_categories
    for neuron = 1:num_neurons
        mu_vals = mu_cell{category, neuron};
        sigma2_vals = sigma2_cell{category, neuron};

        mu_val = mu_vals(window_to_plot);
        sigma2_val = sigma2_vals(window_to_plot);

        all_mu(end+1) = mu_val;
        all_sigma2(end+1) = sigma2_val;
   
    end

    subplot(2,2,category)
    hold on
    scatter(all_mu, all_sigma2, 20, 'filled')

    p = polyfit(all_mu, all_sigma2, 1);
    mean_N = linspace(min(all_mu), max(all_mu), 100);
    var = polyval(p, mean_N);

    plot(mean_N, var, 'r', 'LineWidth', 2)
    xlabel('Mean spike count')
    ylabel('Variance of spike count')
    legend(['slope = ' num2str(p(1), '%.2f')])
    title(['Category ' num2str(category)])
    grid on
end

%% SVM for classifying
% preprocessing
svm_class_dataa = cell(4,92); 

for neuron = 1:num_neurons
    for category = 1:num_categories
        svm_data = extracted_category_sig{category, neuron};  
        trial = size(svm_data,1);
        svm_vector = zeros(trial, num_windows);

        for w = 1:num_windows
            start_idx = (w-1)*step + 1;
            end_idx = start_idx + window - 1;

            window_data = svm_data(:, start_idx:end_idx);  
            mean_spike_count = mean(window_data, 2);   
            svm_vector(:,w) = mean_spike_count; 
        end

        svm_class_dataa{category, neuron} = svm_vector;
    end
end

num_timepoints = num_windows;
svm_data_per_time = cell(num_timepoints, num_categories);

for t = 1:num_timepoints
    for category = 1:num_categories
        trials_per_cat = size(svm_class_dataa{category, 1}, 1);
        data_matrix = zeros(trials_per_cat, num_neurons);
        for neuron = 1:num_neurons
            data_matrix(:, neuron) = svm_class_dataa{category, neuron}(:, t);
        end
        svm_data_per_time{t, category} = data_matrix;
    end
end

%% Classifier Train
num_windows = 101;
num_categories = 4;
svm_models = cell(num_windows, 1);

for t = 1:num_windows
    X = [];
    Y = [];

    for c = 1:num_categories
        data = svm_data_per_time{t, c};
        X = [X; data];
        Y = [Y; c * ones(size(data,1), 1)];
    end

    svm_models{t} = fitcecoc(X, Y);  
end

%% Classifier Test
accuracies = zeros(num_windows, 1);
recalls = zeros(num_windows, num_categories);

for t = 1:num_windows
    X = [];
    Y = [];

    for c = 1:num_categories
        data = svm_data_per_time{t, c};
        X = [X; data];
        Y = [Y; c * ones(size(data,1), 1)];
    end

    cv = cvpartition(Y, 'KFold', 5);
    y_true_all = []; y_pred_all = [];

    for fold = 1:5
        test_idx = test(cv, fold);
        X_test = X(test_idx, :);
        Y_test = Y(test_idx);

        model = svm_models{t};
        Y_pred = predict(model, X_test);

        y_true_all = [y_true_all; Y_test];
        y_pred_all = [y_pred_all; Y_pred];
    end

    accuracies(t) = sum(y_pred_all == y_true_all) / length(y_true_all);

    for c = 1:num_categories
        true_c = (y_true_all == c);
        pred_c = (y_pred_all == c);
        recalls(t, c) = sum(true_c & pred_c) / sum(true_c);  
    end
end

%% Result
figure;
bar(accuracies);
xlabel('Time window index');
ylabel('Accuracy');
ylim([0 1]);
grid on;

[~, best_time] = max(accuracies);
figure;
bar(recalls(best_time, :));
xlabel('Category (1=Face, 2=Body, 3=Natural, 4=Artificial)');
ylabel('Recall');
ylim([0 1]);
grid on;

%% Time-Time Decoding
decoding_matrix = zeros(num_timepoints, num_timepoints); 

for train_time = 1:num_timepoints
    model = svm_models{train_time}; 

    for test_time = 1:num_timepoints
        X_test = [];
        y_test = [];

        for c = 1:num_categories
            data = svm_data_per_time{test_time, c};
            X_test = [X_test; data];
            y_test = [y_test; ones(size(data, 1), 1) * c];
        end

        y_pred = predict(model, X_test);
        acc = mean(y_pred == y_test);

        decoding_matrix(train_time, test_time) = acc;
    end
end

%% 
figure;
imagesc(decoding_matrix);
colorbar;
xlabel('Test Time Bin');
ylabel('Train Time Bin');
%title('Time-Time Decoding Matrix');
caxis([0.2 0.7]);
colormap(jet);

%% Mutual Information
num_neurons = size(svm_data_per_time{1,1},2);
MI_category = zeros(num_windows, num_categories);

for t = 1:num_windows
    X = []; Y_cat = cell(num_categories,1);
    
    for c = 1:num_categories
        data = svm_data_per_time{t, c};  
        X = [X; data];

        for cat = 1:num_categories
            if c == cat
                Y_cat{cat} = [Y_cat{cat}; 1 * ones(size(data,1), 1)];
            else
                Y_cat{cat} = [Y_cat{cat}; 0 * ones(size(data,1), 1)];
            end
        end
    end

    % binning
    num_bins = 5;  
    X_binned = zeros(size(X));
    for n = 1:num_neurons
        edges = linspace(min(X(:,n)), max(X(:,n)), num_bins+1);
        X_binned(:,n) = discretize(X(:,n), edges);
    end

    for cat = 1:num_categories
        Y = Y_cat{cat};
        mi_per_neuron = zeros(1, num_neurons);
        for n = 1:num_neurons
            mi_per_neuron(n) = mutualinfo(X_binned(:,n), Y);
        end
        MI_category(t, cat) = mean(mi_per_neuron);
    end
end

figure;
lin = linspace(1,505,101);
plot( lin, MI_category, 'LineWidth', 2);
xlabel('Time');
ylabel('Mutual Information');
legend({'Face','Body','Natural','Artificial'});
%title('MI between neural activity and each category vs. others');
grid on;


function mi = mutualinfo(x, y)
    joint_prob = accumarray([x y+1], 1) / length(x);
    px = sum(joint_prob, 2);
    py = sum(joint_prob, 1);

    [xx, yy] = find(joint_prob);
    mi = 0;
    for i = 1:length(xx)
        j = xx(i);
        k = yy(i);
        pxy = joint_prob(j, k);
        mi = mi + pxy * log2(pxy / (px(j) * py(k)));
    end
end

%%
% num_time_bins = 101;
% num_classes = 4;
% num_permutations = 5;
% 
% labels_all = [];
% for c = 1:num_classes
%     n_trials = size(svm_data_per_time{1, c}, 1);
%     labels_all = [labels_all; c * ones(n_trials, 1)];
% end
% 
% null_matrices = zeros(num_time_bins, num_time_bins, num_permutations);
% 
% for perm = 1:num_permutations
%     shuffled_labels = labels_all(randperm(length(labels_all)));
% 
%     for train_time = 1:num_time_bins
%         model = svm_models{train_time};
% 
%         for test_time = 1:num_time_bins
%             X_test = [];
%             for c = 1:num_classes
%                 X_test = [X_test; svm_data_per_time{test_time, c}];
%             end
% 
%             Y_pred = predict(model, X_test);
%             null_matrices(train_time, test_time, perm) = mean(Y_pred == shuffled_labels);
%         end
%     end
% end
% 
% %%
% 
% p_vals = zeros(num_time_bins, num_time_bins);
% 
% for i = 1:num_time_bins
%     for j = 1:num_time_bins
%         null_dist = squeeze(null_matrices(i,j,:));
%         p_vals(i,j) = mean(null_dist >= decoding_matrix(i,j));  
%     end
% end
% %%
% [h_fdr, crit_p, adj_p] = fdr_bh(p_vals(:), 0.05, 'pdep');
% signif_mask = reshape(h_fdr, num_time_bins, num_time_bins);
% %%
% figure;
% imagesc(decoding_matrix);
% colorbar;
% xlabel('Test Time');
% ylabel('Train Time');
% title('Time-Time Decoding Matrix with Significance');
% colormap(jet);
% caxis([0.2 0.7]); 
% hold on;
% 
% [y_sig, x_sig] = find(signif_mask);
% plot(x_sig, y_sig, 'k.', 'MarkerSize', 8);
% 
% %%
% function [h, crit_p, adj_p] = fdr_bh(pvals, q, method, report)
%     if nargin < 2
%         q = 0.05;
%     end
%     if nargin < 3
%         method = 'pdep';
%     end
%     if nargin < 4
%         report = 'no';
%     end
%     
%     s = size(pvals);
%     pvals = pvals(:); 
%     
%     [sorted_p, sort_ids] = sort(pvals);
%     unsort_ids(sort_ids) = 1:length(pvals);
%     
%     V = length(pvals);
%     I = (1:V)';
%     
%     if strcmpi(method, 'pdep')
%         cVID = 1;
%     elseif strcmpi(method, 'dep')
%         cVID = sum(1./(1:V));
%     else
%         error('Unknown method.');
%     end
%     
%     thresh = (I / V) * q / cVID;
%     wtd_p = V * sorted_p ./ I;
%     
%     rej = sorted_p <= thresh;
%     if any(rej)
%         crit_p = max(sorted_p(rej));
%     else
%         crit_p = 0;
%     end
%     
%     h = pvals <= crit_p;
%     h = reshape(h, s);
%     
%     adj_p = zeros(V,1);
%     adj_p(end) = min(wtd_p(end), 1);
%     for ii = V-1:-1:1
%         adj_p(ii) = min(max(wtd_p(ii), adj_p(ii+1)), 1);
%     end
%     adj_p = adj_p(unsort_ids);
%     adj_p = reshape(adj_p, s);
%     
%     if strcmpi(report, 'yes')
%         fprintf('FDR BH: %d/%d hypotheses rejected at q = %.3f\n', sum(h(:)), numel(h), q);
%     end
% end

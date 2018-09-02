function get_train_test_structs(params)
%% get wFCs

% load data
load(params.data_file_path);  

% collect all wFCs from all subjects 
wFCs = get_wFCs(sCall, TS, params);

% separate training wFCs
data_train = struct;
data_train.sCall_window = wFCs.sCall_window(:, :, :, params.train_idx); 
data_train.fCall_window = wFCs.fCall_window(:, :, :, params.train_idx);
save(strcat('../INTER_MATS/data_train', '.mat'), 'data_train');
% load(strcat('../INTER_MATS/data_train', '.mat'), 'data_train');

%% cluster wFCs and get transition matrix and steady state distribution

[train_struct] = cluster_wFCs(data_train.fCall_window, params); % GMM over spectral embedding of wFCs
[train_struct.trans_mat, train_struct.ss_distrib] = get_trans_mat_and_ss_distrib(train_struct.hard_assigns, params);

%% save mats

save(strcat('../INTER_MATS/train_struct', params.fstring, '.mat'), 'train_struct');

end
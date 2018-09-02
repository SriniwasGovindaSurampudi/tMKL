function run_tMKL(params)

%% Load Necessary Files

load(params.data_file_path, 'sCall', 'TS');
load(strcat('../INTER_MATS/data_train', '.mat'), 'data_train');
load(strcat('../INTER_MATS/train_struct', params.fstring, '.mat'), 'train_struct');

%% Prepare Structure for tMKL

tMKL_ip_cell = cell(1, params.num_comps);
for idx_comp = 1 : params.num_comps
    
    comp_struct = struct;
    idx_win = find(train_struct.hard_assigns == idx_comp);
    comp_struct.sCall_window = data_train.sCall_window(:, :, idx_win);
    comp_struct.fCall_window = data_train.fCall_window(:, :, idx_win);
    tMKL_ip_cell{1, idx_comp} = comp_struct;
    clear comp_struct;
    
end
%}

%% Training and Testing the Model
tMKL_cell = cell(1, params.num_comps);
% load(strcat('../INTER_MATS/tMKL', params.fstring, '_m',num2str(params.num_scls), '.mat'), 'tMKL_cell');

for idx_comp = 1 : params.num_comps
    
    comp_struct = struct;
    window_belongingness = train_struct.soft_assigns(train_struct.hard_assigns == idx_comp, idx_comp);
    comp_struct.pi = training_version3(tMKL_ip_cell{1, idx_comp}.sCall_window, tMKL_ip_cell{1, idx_comp}.fCall_window, params, window_belongingness);
    [~, comp_struct.corr] = testing_version3(data_train.sCall_window, data_train.fCall_window, comp_struct.pi, params);
    tMKL_cell{1, idx_comp} = comp_struct;
    disp(['idx_comp', num2str(idx_comp)])
    
end

%% save the model
save(strcat('../INTER_MATS/tMKL', params.fstring, '_m',num2str(params.num_scls), '.mat'), 'tMKL_cell');

end
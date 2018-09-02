function [FC_pred_grand_avg, corr_grand_avg] = grand_average_prediction(params)

%% Load Necessary Files

load(params.data_file_path, 'sCall', 'fCall', 'TS');  
load(strcat('../INTER_MATS/tMKL', params.fstring, '_m',num2str(params.num_scls), '.mat'), 'tMKL_cell');
load(strcat('../INTER_MATS/train_struct', params.fstring, '.mat'), 'train_struct');

%% Predict wFC for Each Subject and State
% also convert each wFC to corresponding time-series

TS_cell = cell(params.num_comps, params.num_test);
FC_pred_allcomps = zeros(params.num_rois, params.num_rois, params.num_comps, params.num_test);
for idx_comp = 1 : params.num_comps

    [FC_pred, ~] = testing_version3( sCall(:, :, params.test_idx), fCall(:, :, params.test_idx), tMKL_cell{1, idx_comp}.pi, params); 
    FC_pred_allcomps(:, :, idx_comp, :) = FC_pred;
    
    for idx_subj = 1 : params.num_test
    
        ts = get_eig_decomp(FC_pred(:, :, idx_subj));
        TS_cell{idx_comp, idx_subj} = ts;
        
    end
    
end

%% Generate Latent Time Series for Each Subject

TS_final = cell(1, params.num_test);

for idx_subj = 1 : params.num_test
    
    TS_subj = [];
    
    for idx_comp = 1 : params.num_comps

        TS_cell{idx_comp, idx_subj} = repmat(TS_cell{idx_comp, idx_subj}, [round(100 * train_struct.ss_distrib(idx_comp)), 1]);
        TS_subj = [TS_subj; TS_cell{idx_comp, idx_subj}];

    end
    
    TS_final{1, idx_subj} = TS_subj;
    FC_pred_grand_avg{1, idx_subj} = corrcoef(TS_final{1, idx_subj});
    
    if ~isnan(FC_pred_grand_avg{1, idx_subj})
    
        c = corrcoef(fCall(:, :, params.test_idx(idx_subj)), FC_pred_grand_avg{1, idx_subj}); % change
        corr_grand_avg(1, idx_subj) = c(1, 2);
    
    end
    
end

end
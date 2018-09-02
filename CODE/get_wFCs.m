function [wFCs] = get_wFCs(sCall, TS, params)
% get SCs and ground truth wFCs for all subjects
sCall_window = zeros(params.num_rois, params.num_rois, params.num_win, params.num_subj);
fCall_window = zeros(params.num_rois, params.num_rois, params.num_win, params.num_subj);

for idx_sub = 1 : params.num_subj
    
    for idx_win = 0 : params.num_win - 1
        
        idx_st = idx_win * params.stride + 1;
        idx_en = idx_win * params.stride + params.omega;
        wTS = taper_window(TS(:, idx_st : idx_en, idx_sub), params.omega, params.num_rois);
        
        if params.corr_type == 1
            
            % use pearson correlation
            fCall_window(:, :, idx_win+1, idx_sub) = corrcoef(wTS');
            
        else
            
            % use partial correlation
            fCall_window(:, :, idx_win+1, idx_sub) = partialcorr(wTS');
            
        end
        
        sCall_window(:, :, idx_win+1, idx_sub) = sCall(:, :, idx_sub);
        
    end
    
end

wFCs = struct;
wFCs.sCall_window = sCall_window;
wFCs.fCall_window = fCall_window;

end
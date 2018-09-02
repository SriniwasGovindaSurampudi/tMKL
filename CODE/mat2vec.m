function [X] = mat2vec(fCall_window)
% vectorize wFCs by considering their upper triangular elements.

% create mask
[num_rois, ~, num_win, num_subj] = size(fCall_window);
mask_ut = triu(ones(num_rois));

% vectorize wFCs
wFCs = reshape(fCall_window, [num_rois, num_rois, num_win * num_subj]);
X = zeros(num_win * num_subj, num_rois * (num_rois - 1) / 2);
for idx_win = 1 : num_win * num_subj
    
    wFC = wFCs(:, : , idx_win);
    X(idx_win, :) = wFC(mask_ut==0)';
    
end

end


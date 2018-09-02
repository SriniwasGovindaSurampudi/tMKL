function [ FC_pred, corr ] = testing_version3( sCall, fCall, pi, params )

if numel(size(sCall)) == 4
    sCall = reshape(sCall, [params.num_rois, params.num_rois, params.num_win * params.num_test]);
    fCall = reshape(fCall, [params.num_rois, params.num_rois, params.num_win * params.num_test]);
end

% variables
FC_pred = zeros(params.num_rois, params.num_rois, size(sCall, 3));
corr = zeros(1, params.num_test);
error = zeros(1, params.num_test);
% for each sample
for s = 1 : size(sCall, 3) % total number of samples.
    
    % pre-process
    [MapC, inds] = pre_process(sCall(:,:,s), fCall(:,:,s));
    
    % thresholding SC
    MapC = (MapC > params.epsilon * max(MapC(:))) .* MapC;
    
    % set of heat kernels
    if (~exist( 'exp_values', 'var'))
        K = Kernels_version3(MapC, params.num_scls, params.idx_lam);
    else 
        K = Kernels_version3(MapC, params.num_scls, params.idx_lam, params.exp_values);
    end
    
%     FC_pred = zeros(params.num_rois, params.num_rois);
    for i = 1 : params.num_scls
        fc_pred = K(:, 1 + (i - 1) * params.num_rois : (i) * params.num_rois) * pi(1 + (i - 1) * params.num_rois : (i) * params.num_rois, :);
        fc_pred = (fc_pred + fc_pred') / 2;
        FC_pred(:, :, s) = FC_pred(:, :, s) + fc_pred;
%         FC_pred = FC_pred + fc_pred;
    end
    
    % correlation
    c = corrcoef((FC_pred(:, :, s) .* inds), (fc_range(fCall(:, :, s), '') .* inds));
%     c = corrcoef((FC_pred .* inds), (fc_range(fCall(:, :, s), '') .* inds));
    corr(1,s) = c(1,2);
    % mse
%     error(1, s) = sqrt(sum(sum((FC_pred(:, :, s) .* inds - fc_range(fCall(:, :, s), '') .* inds).^(2)))) / (params.num_rois * params.num_rois);
end

end


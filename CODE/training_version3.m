function [ pi ] = training_version3(sCall, fCall, params, soft_assigns_comp)

if numel(size(sCall)) == 4
    sCall = reshape(sCall, [params.num_rois, params.num_rois, params.num_win * params.num_train]);
    fCall = reshape(fCall, [params.num_rois, params.num_rois, params.num_win * params.num_train]);
end

%% Initializating Variables
S = size(fCall,3); % number of samples
pi = zeros(params.num_scls * params.num_rois, params.num_rois);
Psi = zeros(S * params.num_rois, params.num_scls * params.num_rois);
Phi = zeros(S * params.num_rois, params.num_rois);

%% Form Input for Training
for s = 1 : S % l == sc-fc index this index will be same for state_belonging vector.
    % pre-processing
    [MapC, inds] = pre_process(sCall(:,:,s), fCall(:,:,s));
    
    % thresholding SC
    MapC = (MapC > params.epsilon * max(MapC(:))) .* MapC;
    
    % set of heat kernels
    if (~exist( 'exp_values', 'var'))
        K = Kernels_version3(MapC, params.num_scls, params.idx_lam);
    else
        K = Kernels_version3(MapC, params.num_scls, params.idx_lam, params.exp_values);
    end
    
    % Psi and Phi formationPsi((s - 1) * params.num_rois + 1 : s * params.num_rois, :) = K ;
    Psi((s - 1) * params.num_rois + 1 : s * params.num_rois, :) = K .* soft_assigns_comp(s);
%     disp(s)
    Phi((s - 1) * params.num_rois + 1 : s * params.num_rois, :) = fc_range(fCall(:,:,s), ' ') .* inds .* soft_assigns_comp(s);
end

%% Training MKL

parfor j = 1 : params.num_rois
    % lasso
    [x, fitinfo] = lasso(Psi, squeeze(Phi(:, j)), 'Alpha', 0.001);
    [~, idx_min] = min(fitinfo.MSE);
    pi(:, j) = x(:, idx_min);
    disp(j);
end

end


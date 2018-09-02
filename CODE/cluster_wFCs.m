function [GMModel] = cluster_wFCs(fCall_window, params)

% vectorize wFCs
[X] = mat2vec(fCall_window);

% discover spectral embedding manifold and learn GMM over it
cv_type = 'full';
num_init = 100;
init_params = 'random';

gmm_params = struct;
gmm_params.cv_type = cv_type;
gmm_params.num_init = num_init;
gmm_params.init_params = init_params;
gmm_params.num_comps = params.num_comps;

[GMModel] = gmm_wFCs(gmm_params, X);

end
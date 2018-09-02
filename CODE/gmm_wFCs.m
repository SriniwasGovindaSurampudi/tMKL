function [GMModel] = gmm_wFCs(gmm_params, X)

cv_type = gmm_params.cv_type;
num_init = gmm_params.num_init;
init_params = gmm_params.init_params;
num_comps = gmm_params.num_comps;

save('mat_params.mat', 'num_comps', 'cv_type', 'num_init', 'init_params', 'X');
! python3 gmm_wFCs_new.py
load('gmm_params.mat');

[~, hard_assigns] = max(soft_assigns, [], 2);
GMModel = struct;
GMModel.cluster_centers = cluster_centers;
GMModel.cluster_weights = cluster_weights;
GMModel.cluster_covmats = cluster_covmats;
GMModel.embedding_data = embedding_data;
GMModel.affinity_matrix = affinity_matrix;

GMModel.hard_assigns = hard_assigns;
GMModel.soft_assigns = soft_assigns;

! rm gmm_params.mat mat_params.mat

end
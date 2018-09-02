%% Load Necessary Data
data_file_path = '../INPUT_MATS/data.mat';
load(data_file_path); 

%% Model Parameters

num_rois = size(TS, 1); % total number of regions of interest (ROIs)
num_tps  = size(TS, 2); % number of time points
num_subj = size(TS, 3); % number of subjects
omega = 22; % sliding window size
stride = 5; % stride of sliding window
num_win = size(1 : stride : num_tps - omega + 1, 2); % number of windows per subject
num_comps = 12; % for Clustering
corr_type = 1; % 1-> pearson correlation 2-> partial correlation
perm_subj = randperm(4);
train_idx = perm_subj(1:2); % training indices
test_idx = perm_subj(3:4); % testing indices
num_train = size(train_idx, 2); % number of train subjects
num_test = size(test_idx, 2); % number of test subjects

% hyper-parameters for MKL
num_scls = 16; 
epsilon = 0.0; 
dim_redn = 0; 
idx_lam = ceil(num_rois * 1 / 40);
exp_values = linspace(0.01, 0.95, num_scls);

%% Save Model Parameters

params = struct;
params.data_file_path = data_file_path;
params.num_rois = num_rois;
params.num_tps = num_tps;
params.num_subj = num_subj;
params.train_idx = train_idx;
params.test_idx = test_idx;
params.num_train = num_train;
params.num_test = num_test;
params.omega = omega;
params.stride = stride;
params.num_win = num_win;
params.corr_type = corr_type;
params.num_comps = num_comps;
params.num_scls = num_scls;
params.exp_values = exp_values;
params.epsilon = epsilon;
params.idx_lam = idx_lam;
params.fstring = strcat('_w',num2str(params.omega),'_s',num2str(params.stride),'_K',num2str(params.num_comps));
save('../INTER_MATS/modelparams.mat','params');

%% Load Model Parameters

% load('../INTER_MATS/modelparams.mat','params');

%% Prepare Training and Testing Structures
% wFCs generation
% vectorize wFCs
% projection to manifold
% GMM - assign wFCs to states
% transition matrix and steady state distribution

disp('Prepare Training Structure');
get_train_struct(params);

%% tMKL Model
% learn state-specific MKL models

disp('tMKL Model');
run_tMKL(params);

%% Post Model Analysis
% evaluate model performance on testing data

disp(['Post Model Analysis']);
results = struct;
[results.FC_pred_grand_avg, results.corr_grand_avg] = grand_average_prediction(params);
save(strcat('../OUTPUT_MATS/results', params.fstring, '.mat'), 'results');

disp(['grand average correlation:     ', num2str(results.corr_grand_avg)]);

function [trans_mat, ss_distrib] = get_trans_mat_and_ss_distrib(hard_assigns, params)

%% create transition matrix

hard_assigns_subj = reshape(hard_assigns, [params.num_win, params.num_train])';
trans_mat = zeros(params.num_comps);

for idx_subj = 1 : params.num_train
    
    for idx_win = 1 : params.num_win - 1
        
        from_state = hard_assigns_subj(idx_subj, idx_win);
        to_state = hard_assigns_subj(idx_subj, idx_win + 1);
        trans_mat(to_state, from_state) = trans_mat(to_state, from_state) + 1;
        
    end
    
end

% normalize each column of transition matrix

col_sum = sum(trans_mat, 1);

for i = find(col_sum==0)
    trans_mat(:, i) = zeros(params.num_comps, 1);
    trans_mat(i, i) = 1;
end

trans_mat = trans_mat ./ sum(trans_mat, 1);
epss = 1e-5;
for idx_comp = 1 : params.num_comps
    
    if trans_mat(idx_comp, idx_comp) == 1
        trans_mat(:, idx_comp) = trans_mat(:, idx_comp) + epss;
        trans_mat(idx_comp, idx_comp) = trans_mat(idx_comp, idx_comp) - params.num_comps * epss;
    end
    
end


%% compute steady state distribution

% [U, Lam] = eig(trans_mat);
% Lam = diag(Lam);
% [~, idx_principal] = max(Lam);
% ss_distrib = U(:, idx_principal);
% ss_distrib = ss_distrib ./ sum(ss_distrib);

[ss_distrib, ~] = eigs(trans_mat, 1, 'largestabs');
ss_distrib = ss_distrib ./ sum(ss_distrib);

end

%% Extras
% save(strcat('INTER_MATS/steady_state_dist_w',num2str(omega),'_s',num2str(stride),'_K',num2str(num_comps),'.mat'), 'steady_state_dist');
%{
for i=1:nstates
    summ = 0;
    % 	if transition_matrix(i,i) == 1
    for j=1:nstates
        if transition_matrix(i,j) == 0
            transition_matrix(i,j) = transition_matrix(i,j) + epss;
            summ = summ + epss;
        end
    end
    % 		transition_matrix(i,i) = transition_matrix(i,i) - nstates*epss;
    transition_matrix(i,i) = transition_matrix(i,i) - summ;
    % 	end
end
%}
% load(strcat('INTER_MATS/wFCs_w',num2str(omega),'_s',num2str(stride),'_train.mat'));
%{
num_win_train = cumsum(num_win_train);
[~, state_seq] = max(soft_assignments_train);
disp(state_seq);
transition_matrix = zeros(num_comps, num_comps);
nstates = num_comps;
cnt = 1;

for i = 1 : size(soft_assignments_train, 2) - 1

    if i == num_win_train(cnt) % reached end of subject's state sequence
        
        cnt = cnt + 1;
        continue;
        
    end
    
    from = state_seq(i);
    to = state_seq(i + 1);
    transition_matrix(from, to) = transition_matrix(from, to) + 1; 
    
end
%}

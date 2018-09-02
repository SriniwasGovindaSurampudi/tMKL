function [ K ] = Kernels_version3( W, num_scls, idx_lam, exp_values )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% scale set selection
if (~exist( 'exp_values', 'var'))
    exp_values = linspace(0.01, 0.95, num_scls);
end

% variables
n = size(W,1);
K = zeros(n, num_scls * n);

% normalized laplacian, eigen decompsition
[ L, U, lambda ] = laplacian( W );

scls = - log(exp_values) / lambda(round(idx_lam), 1);

% computing heat kernels
for i = 1 : num_scls
    K(:, (i - 1) * n + 1 : i * n) = expm(-L * scls(i));
end
end


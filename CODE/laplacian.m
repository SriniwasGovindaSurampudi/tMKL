function [ L, U, lambda ] = laplacian( W )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% normalized laplacian, eigen decompsition
D = diag(sum(W + eps) + eps);
L = (D - W);
L = D^(-0.5) * L * D^(-0.5);
[U,lambda] = eig(L);
lambda = sort(diag(lambda));
end


function [ MapC, inds ] = pre_process( SC,FC, e_sc, e_fc )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ~exist('e_sc', 'var')
    e_sc = 0.01;
end
if ~exist('e_fc', 'var')
    e_fc = 0.1;
end

% SC pre-processing
nzs = nonzeros(SC);
MapC =((SC > e_sc * std(nzs))) .* SC;
% NormMean = mean(nonzeros(MapC));
% MapC = MapC/NormMean; % Normalize struct matrix
clear NormMean;

% FC pre-processing
inds = (abs(FC) > e_fc * max(abs(FC(:))));
%inds(1:n+1:end) = 0;
end


function [ FC ] = fc_range( FC, type )
% this function scales FC in different ranges
switch (type)
    case 'absolute' 
        FC = abs(FC);
    case 'normalized'
        FC = (FC - min(FC(:))) / (max(FC(:)) - min(FC(:)));
    otherwise
        FC = FC;
end
end
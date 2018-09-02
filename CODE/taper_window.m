function [TS_tapered] = taper_window(TS, omega, num_rois)

% create window
win = ones(1, omega);

% create gaussian filter - tapering taken from [Allen et al.2014]
sigma_gauss = 3;
len_gauss = 6 * sigma_gauss + 1;
x = linspace(-len_gauss / 2, len_gauss / 2, len_gauss);
gauss = exp(-x .^ 2 / (2 * sigma_gauss ^ 2));
gauss = gauss / sum (gauss);

% rect window with gaussian filter
win = imfilter(win, gauss);
win = repmat(win, [num_rois, 1]);

TS_tapered = TS .* win;

end

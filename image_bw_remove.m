function J = image_bw_remove(I)
% image_bw_remove is an alternative equivalent to J = bwmorph(I,'remove')
% from the image processing toolbox. It can be used to get at once every
% boundaries in the image.
%
%%% Author : nicolas.douillet9 (at) gmail.com, 2022-2025.
%
%
%%% Inputs
%
% - I : binary image.
%
%%% Output
%
% J : binary image.


strel = [1 1 1; 1 0 1; 1 1 1]; % structuring element for n8 neighborhood
J = xor(I,conv2(1-I,strel,'same'));
J = 1 - J;  


end % image_bw_remove
function J = close_image(I, se, r)
%
%%% Author : nicolas.douillet (at) free.fr, 2022-2024.
%
%
%%% Inputs
%
% - I : binary image.
%
% - se : structuring element. Binary square matrix.
%
% - r : radius. Positive integer.
%
%
%%% Output
%
% J : binary image.


% I image dilatation 
D = dilate_image(I, se, r);

% II image erosion
J = erode_image(D, se, r);


end % close_image
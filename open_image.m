function J = open_image(I, se, r)
%
% Author and support : nicolas.douillet (at) free.fr, 2022.
%
%
% Inputs
%
% - I : binary image.
%
% - se : structuring element. Binary square matrix.
%
% - r : radius. Positive integer.
%
%
% Output
%
% J : binary image.


% I image erosion
E = erode_image(I, se, r);

% II image dilatation
J = dilate_image(E, se, r);


end % open_image
function E = erode_image(I, se, r)
%
%%% Author : nicolas.douillet9 (at) gmail.com, 2022-2025.
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


if strcmp(se,'disk')
    
    strel = [0 1 0; 1 0 1; 0 1 0];
    
elseif strcmp(se,'square')
    
    strel = [1 1 1; 1 0 1; 1 1 1];
    
end

E = I;

for k = 1:r

  E = 1 - conv2(1-E,strel,'same');

end


end % erode_image
function D = dilate_image(I, se, r)
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


if strcmp(se,'disk')
    
    strel = [0 1 0; 1 0 1; 0 1 0];
    
elseif strcmp(se,'square')
    
    strel = [1 1 1; 1 0 1; 1 1 1];
    
end

D = I;

for k = 1:r
    
  D = conv2(D,strel,'same');
  
end


end % dilate_image
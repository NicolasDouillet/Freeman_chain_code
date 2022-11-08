function [bound_img, X0, Code, bound_coord] = Freeman_chain_code(I, option_display)
% Freeman_chain_code : function to extract the contour of a given shape using
% Freeman chain code. For binary images only.
%
% Author & support : nicolas.douillet (at) free.fr, 2005-2022.
%
% 
% Reference
% 
% Freeman H, Computer Processing of Line-Drawing Images,
% ACM Computing Surveys, Vol. 6, No.1, 1974, pp57-97.
%
%
% Inputs
%
%
% - I : binary (0/1) image where 0 pixels correspond to the black
%       background, and 1 pixels correspond to the object(s) / shape(s) to
%       segment.
% 
% - option_display : either logical, true/false or numeric 1/0.
%
%
% Outputs
%
%
% - bound_img : binary (0/1) image of the input image boundaries. size(bound_img) = size(I).
%
% - X0 : cell array of integer vectors of double, the boundaries initial pixels coordinates.
%
% - Code : cell array of integer vectors of double, the boundaries Freeman coding vectors.
%
% - bound_coord : cell array of integer vectors of double, the boundaries pixels coordinates.
%
%
% Current known limitations
%
% - Only extract the shapes outer boundaries;
% - Do not work on 'inverted' binary image (white background);
% - Do not work on images with shape(s) "touching" one of the image boundaries.


% Copy the image for final display
J = I;

% Freeman code directions definition
% In a n8 pixel neighborhood
move_index = [1, 0,-1,-1,-1,0,1,1;  % X / horizontal move
             -1,-1,-1, 0, 1,1,1,0]; % Y / vertical move
              
% Initializations
bound_img = zeros(size(I));         % boundary image
bound_coord = {};                   % boundary coordinates cell array of vectors
Code = {};                          % boundary code cell array of vectors
X0 = [];

prv_dir = @(d)mod(d-2,8) + 1;       % previous direction
opp_dir = @(d)mod(d+2,8) + 1;       % opposite direction - 1

% Look for first white pixel
S = size(I);
f = find(I,1,'first');
s = 1; % shape index number


while f % ~isempty(f)
    
    [row_idx0,col_idx0] = ind2sub(S,f);
    X0 = cat(2,X0,[row_idx0;col_idx0]);
        
    bound_img(row_idx0,col_idx0) = 1; % 1st point definition
    
    row_idx1 = row_idx0;
    col_idx1 = col_idx0;
    
    dir = 8;                          % sweep starting direction    
    dir0 = opp_dir(dir);
    
    % 2nd point detection
    I(row_idx0,col_idx0) = 0;         % to enter the loop
    
    
    while ~I(row_idx1,col_idx1)
        
        dir0 = prv_dir(dir0);
        row_idx1 = row_idx0 + move_index(2,dir0); % 2nd point coordinates
        col_idx1 = col_idx0 + move_index(1,dir0); % from index matrix
        
    end
    
    Code_s(1,1) = dir0;
    
    I(row_idx0,col_idx0) = 1;         % reset pixel initial value
    bound_img(row_idx1,col_idx1) = 1; % update boundary image
    dir = dir0;                       % update direction
    
    % Coding other contour points
    row_idx2 = row_idx1; % 2nd temporary values
    col_idx2 = col_idx1;
    i = 2;
    
    while row_idx2 ~= row_idx0 || col_idx2 ~= col_idx0
        
        dir0 = opp_dir(dir);
        I(row_idx2,col_idx2) = 0; % to enter the loop
        
        while ~I(row_idx1,col_idx1)
            
            dir0 = prv_dir(dir0);
            
            row_idx1 = row_idx2 + move_index(2,dir0); % next point coordinates
            col_idx1 = col_idx2 + move_index(1,dir0); % from index matrix
            
        end
        
        Code_s(1,i) = dir0;
        dir = dir0;
        bound_img(row_idx2,col_idx2) = 1;
        
        I(row_idx2,col_idx2) = 1; % reset pixel initial value
        row_idx2 = row_idx1;
        col_idx2 = col_idx1;
        
        i = i + 1;
        
    end
        
    bound_coord_s = repmat([col_idx0;row_idx0],[1, numel(Code_s)]);
    bound_coord_s = circshift(bound_coord_s + cumsum(move_index(:,Code_s(1:end)),2),1,2);        
        
    I = shut_off_binary_shape_from_its_contour(I,bound_coord_s');    
    
    bound_coord(s) = {bound_coord_s};
    clear bound_coord_s;
    
    Code(s) = {Code_s};
    clear Code_s;
    
    f = find(I,1,'first');
    s = s + 1;
    
end % Freeman_chain_code


% Freeman contour display
if option_display
    
    figure;
    subplot(121);
    imshow(J);
    title('Source image');
    subplot(122);
    imshow(bound_img);
    title('Freeman coded image contour');
    
end


end % Freeman_chain_code


% shut_off_binary_shape_from_its_contour subfunction
function [I_out] = shut_off_binary_shape_from_its_contour(I_in, bound_coord)

I_out = I_in;

% By rows processing
row_min_idx = min(bound_coord(:,2));
row_max_idx = max(bound_coord(:,2));

bound_coord = sortrows(bound_coord);

for i = row_min_idx:row_max_idx
    
    row_bin_idx = bound_coord(:,2) == i;
    row_segments_col_idx = bound_coord(row_bin_idx,1);        
    
    % "Shut off" the row segments                  
    I_out(i,row_segments_col_idx(1):row_segments_col_idx(end)) = 0;    
        
end


end % shut_down_shape_from_contour
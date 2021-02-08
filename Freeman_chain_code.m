function [Code, row_idx0, col_idx0] = Freeman_chain_code(I, option_display)
%% Freeman : function to extract the contour of a given shape using Freeman
% chain code. For binary images only.
%
% Author & support : nicolas.douillet (at) free.fr, 2005-2021.


[H,W] = size(I);

%% Source image display
if option_display
    
    subplot(121);
    imshow(I);
    title('Source image');
    
end


%% Look for first white pixel
[row_idx0,col_idx0] = find(I,1,'first');

%% Freeman code directions definition
Indice = [-1,-1,-1,0,1,1,1,0;  % Y move
          1,0,-1,-1,-1,0,1,1]; % X move

%% Initializations
row_idx1 = row_idx0;
col_idx1 = col_idx0;
Contour = zeros(H,W);    % contour initialization
Contour(row_idx1,col_idx1) = 1;      % 1st point definition
dir = 8;                 % sweep starting direction
Code(1,1) = dir;         % code vector
dir0 = mod(dir+3-1,8) + 1; % opposite direction -1


%% 2nd point detection
I(row_idx0,col_idx0) = 0; % to enter the loop but must set back I to 255 after

while ~I(row_idx1,col_idx1)
    
    row_idx1 = row_idx0 + Indice(1,dir0); % 2nd point coordinates
    col_idx1 = col_idx0 + Indice(2,dir0); % from index matrix
    
    if dir0 ~= 1
        
        dir0 = dir0 - 1; % direction definition
        
    else
        
        dir0 = 8;
        
    end
    
end

I(row_idx0,col_idx0) = 1; % set back true value of initial point
Contour(row_idx1,col_idx1) = 1;
dir = dir0; % update dir

%% Coding other contour points
row_idx2 = row_idx1; % 2nd temporary value
col_idx2 = col_idx1;
i = 2;

while row_idx2 ~= row_idx0 || col_idx2 ~= col_idx0
    
    dir0 = mod(dir+3-1,8) + 1;
    I(row_idx2,col_idx2) = 0; % to enter the loop but must set back I to 1 after
    
    while ~I(row_idx1,col_idx1)
        
        if dir0 ~= 1
            
            dir0 = dir0 - 1; % direction definition
            
        else
            
            dir0 = 8;
            
        end
        
        row_idx1 = row_idx2 + Indice(1,dir0);  % next point coordinates
        col_idx1 = col_idx2 + Indice(2,dir0);  % from index matrix
        
    end
    
    dir = dir0;
    Contour(row_idx2,col_idx2) = 1;
    Code(1,i) = dir0;
    i = i + 1;
    row_idx2 = row_idx1;
    col_idx2 = col_idx1;
    I(row_idx2,col_idx2) = 1; % set back true value of initial point
    
end


%% Freeman contour display
if option_display
    
    subplot(122);
    imshow(Contour);
    title('Freeman coded image contour');
    
end


end % Freeman_chain_code
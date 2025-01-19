% Freeman_chain_code use examples
%
%%% Author : nicolas.douillet9 (at) gmail.com, 2005-2025.


img_name = {'overcleaned_bin_rice.png','bw_art.png','cropped_clouds.png','bw_coins.png','concave_shape.png',...
            'gear.png','complex_gear.png','v_letter.png','matrice.png','disks_cloud.png'};

fid = 3; 
I = imread(string(img_name(fid))); % Choose your image number between 1 and 10 here


% Example I : how to execute Freeman_chain_code
[bound_img,X0,Code,bound_coord,invert_img] = Freeman_chain_code(I,true);


% Example II : how to rebuild the boundary image from the boundary coordinates vector
bound_img2 = zeros(size(I));

for k = 1:numel(bound_coord)
    
    bound_coord_k = cell2mat(bound_coord(k));
    idx = sub2ind(size(I),bound_coord_k(2,:),bound_coord_k(1,:));
    bound_img2(idx) = 1;
    
end

if invert_img    
    bound_img2 = ~bound_img2;    
end
        
isequal(bound_img,bound_img2) % check equals 1 / logical true -> ok


% Example III : shape boundary retrieving by its index
first_shape_segmented_img = repmat(bound_img,[1 1 3]);
shp_idx = 1; % shp_idx < number of shapes in your image
idx = sub2ind(size(first_shape_segmented_img),bound_coord{shp_idx}(2,:),bound_coord{shp_idx}(1,:),3*ones(size(bound_coord{shp_idx}(1,:))));
idx2 = sub2ind(size(I),bound_coord{shp_idx}(2,:),bound_coord{shp_idx}(1,:));

first_shape_img = zeros(size(I));
first_shape_segmented_img(idx) = 0;
first_shape_img(idx2) = 1;

if invert_img    
    first_shape_segmented_img(idx) = 1;
    first_shape_img = ~first_shape_img;    
end


figure;
% image(first_shape_img);
image(first_shape_segmented_img);
title(['Shape #',num2str(shp_idx),' (indexing order)']);
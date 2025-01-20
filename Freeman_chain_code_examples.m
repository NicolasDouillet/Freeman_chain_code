% Freeman_chain_code use examples
%
%%% Author : nicolas.douillet9 (at) gmail.com, 2005-2025.


img_name = {'overcleaned_bin_rice.png','bw_art.png','cropped_clouds.png','bw_coins.png','concave_shape.png',...
            'gear.png','complex_gear.png','v_letter.png','matrice.png','disks_cloud.png'};

fid = 3; 
I = imread(string(img_name(fid))); % Choose your image number between 1 and 10 here


% Example I : how to execute Freeman_chain_code
[bound_img,X0,freeman_code,bound_coord,invert_img] = Freeman_chain_code(I,true);

nb_shapes = numel(freeman_code);
fprintf('%d shapes detected in this image\n',nb_shapes);

% Example II : how to rebuild the boundary image from the boundary coordinates vector
bound_img2 = zeros(size(I));

for k = 1:numel(bound_coord)
    
    bound_coord_k = cell2mat(bound_coord(k));
    id = sub2ind(size(I),bound_coord_k(2,:),bound_coord_k(1,:));
    bound_img2(id) = 1;
    
end

if invert_img    
    bound_img2 = ~bound_img2;    
end
        
% fprintf('Is rebuild contour equal to origin contour ? => %d\n',isequal(bound_img,bound_img2)) % check equals 1 / logical true -> ok


% Example III : shapes labelling
shapes_segmented_img = repmat(bound_img,[1 1 3]);

colorarray = [0 1 1;  % cyan
              1 0 1;  % magenta
              1 1 0;  % yellow
              0 1 0;  % green
              1 0 0;  % red
              0 0 1;  % blue
              1 1 1]; % white
          
colorarray = permute(colorarray,[1 3 2]);          


for shp_id = 1:nb_shapes % shp_id < number of shapes in your image
    
    color_id = 1 + mod(shp_id-1,size(colorarray,1));
    pix_color = find(colorarray(color_id,1,:) == 0);
    
    switch numel(pix_color)        
            
        case 1
            
            id = sub2ind(size(shapes_segmented_img),bound_coord{shp_id}(2,:),bound_coord{shp_id}(1,:),pix_color*ones(size(bound_coord{shp_id}(1,:))));
            shapes_segmented_img(id) = 0;
            
        case 2
            
            id1 = sub2ind(size(shapes_segmented_img),bound_coord{shp_id}(2,:),bound_coord{shp_id}(1,:),pix_color(1)*ones(size(bound_coord{shp_id}(1,:))));
            id2 = sub2ind(size(shapes_segmented_img),bound_coord{shp_id}(2,:),bound_coord{shp_id}(1,:),pix_color(2)*ones(size(bound_coord{shp_id}(1,:))));
            
            shapes_segmented_img(id1) = 0;
            shapes_segmented_img(id2) = 0;
            
        otherwise % case 0 | white color
            
    end                                
    
end

if invert_img
    
    shapes_segmented_img(id) = 1;
    first_shape_img = ~first_shape_img;
    
end


figure;
image(shapes_segmented_img);
axis equal, axis off;
title([num2str(nb_shapes),' shapes detected and labelled'],'FontSize',16);
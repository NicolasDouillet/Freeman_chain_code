% Freeman_chain_code use examples

% I = imread('nuages.jpg');
I = imread('coins.png');
% I = imread('Forme4.JPG');
% I = imread('roue1_6_2.jpg');
% I = imread('ruedabin.PNG');
% I = imread('spirale1.jpg');
% I = imread('spirale2.jpg');
% I = imread('Spirale3.jpg');
% I = imread('nimp4.jpg');
% I = imread('etoile2.jpg');
% I = imread('v_letter.png');

if size(I,3) > 1
    
    I = rgb2gray(I);
    
end
    
I = imbinarize(I);


% Example I : how to execute Freeman_chain_code
[bound_img,X0,Code,bound_coord] = Freeman_chain_code(I,true);


% Example II : how to rebuild the boundary image from the boundary coordinates vector
bound_img2 = zeros(size(I));  

for k = 1:numel(bound_coord)
    
    bound_coord_k = cell2mat(bound_coord(k));
    idx = sub2ind(size(I),bound_coord_k(2,:),bound_coord_k(1,:));
    bound_img2(idx) = 1;
    
end

isequal(bound_img,bound_img2) % check -> ok


% Example III : shape boundary retrieving by its index
first_shape_img = zeros(size(I));
first_shape_segmented_img = repmat(bound_img,[1 1 3]);
shp_idx = 1;
idx = sub2ind(size(first_shape_segmented_img),bound_coord{shp_idx}(2,:),bound_coord{shp_idx}(1,:),2*ones(size(bound_coord{shp_idx}(1,:))));
first_shape_segmented_img(idx) = 0;

idx2 = sub2ind(size(I),bound_coord{shp_idx}(2,:),bound_coord{shp_idx}(1,:));
first_shape_img(idx2) = 1;


figure;
% imshow(first_shape_img);
imshow(first_shape_segmented_img);
title(['Shape #',num2str(shp_idx),' in order of indexing']);
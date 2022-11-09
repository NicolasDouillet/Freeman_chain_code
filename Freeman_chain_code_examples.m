% Freeman_chain_code use examples

img_name = {'coins.png','Forme4.JPG','roue1_6_2.jpg','ruedabin.PNG','spirale1.jpg','spirale2.jpg','Spirale3.jpg','nimp4.jpg','etoile2.jpg','v_letter.png'};


I = imread(string(img_name(1)));

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

isequal(bound_img,bound_img2) % check equals 1 / logical true -> ok


% Example III : shape boundary retrieving by its index
first_shape_img = zeros(size(I));
first_shape_segmented_img = repmat(bound_img,[1 1 3]);
shp_idx = 1; % /_!_\ shp_idx < number of shapes in your image /_!_\
idx = sub2ind(size(first_shape_segmented_img),bound_coord{shp_idx}(2,:),bound_coord{shp_idx}(1,:),3*ones(size(bound_coord{shp_idx}(1,:))));
first_shape_segmented_img(idx) = 0;

idx2 = sub2ind(size(I),bound_coord{shp_idx}(2,:),bound_coord{shp_idx}(1,:));
first_shape_img(idx2) = 1;


figure;
% imshow(first_shape_img);
imshow(first_shape_segmented_img);
title(['Shape #',num2str(shp_idx),' in order of indexing']);
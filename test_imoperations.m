% test imoperations

clear all, close all, clc;


img_name = {'overcleaned_bin_rice.png','bw_art.png','cropped_clouds.png','bw_coins.png','concave_shape.png',...
            'gear.png','complex_gear.png','v_letter.png','matrice.png','disks_cloud.png'};

I = imread(string(img_name(1))); % Choose your image number between 1 and 10 here


% image_bw_remove test
figure;
subplot(121);
imshow(I);
title('Binary source image');
J = image_bw_remove(I);
subplot(122);
imshow(J);
title('Boundary image');

% dilate_image test
figure;
subplot(121);
imshow(I);
title('Binary source image');
J = dilate_image(I,'disk',2);
subplot(122);
imshow(J);
title('Dilated image');

% erode_image test
figure;
subplot(121);
imshow(I);
title('Binary source image');
S = erode_image(I,'square',1);
subplot(122);
imshow(S);
title('Eroded image');

% open_image test
figure;
subplot(121);
imshow(I);
title('Binary source image');
J = open_image(I,'disk',1);
subplot(122);
imshow(J);
title('Image opening');

% open_image test
figure;
subplot(121);
imshow(I);
title('Binary source image');
J = close_image(I,'disk',1);
subplot(122);
imshow(J);
title('Image closure');
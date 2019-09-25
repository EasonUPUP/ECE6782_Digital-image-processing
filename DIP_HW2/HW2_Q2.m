Pic=imread('funny.png');              
BinaryPic=im2bw(Pic,0.99);                       %set a threshold
subplot(3,1,2),imshow(BinaryPic)                 %show the image
title('binary image')


InversePic=~BinaryPic;                           %inverse picture

subplot(3,1,1),imshow(InversePic);               %show the image
title('Inverse image')

se = strel('disk',6);                            % test several times
ThirdPic=imclose(BinaryPic,se);
subplot(3,1,3),imshow(ThirdPic)                  %show the image
title('Third image')
grayImage=rgb2gray(rgbImage);
imshow(grayImage);
i=1;j=1;

for i=1:500
    for j=1:500
        grayImage(i,j)=0;
        j=j+1;
    end
    i=i+1;
end

imshow(grayImage);
    
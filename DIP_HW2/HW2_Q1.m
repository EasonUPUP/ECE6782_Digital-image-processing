%First. read the image
Pic=imread('homosapiens.png');              
subplot(3,2,1),imshow(Pic)                 %show the image
title('gray image')


%Second. Plot the histogram
[m,n]=size(Pic);                           %get the size of picture
HG=zeros(1,256);                           %set the matrix of histogram
for k=0:255     
    HG(k+1)=length(find(Pic==k))/(m*n);    %find the density of each level
end
subplot(3,2,2),bar(0:255,HG,'b')           %write the histogram
title('Original histogram')
xlabel('Value of pixels')
ylabel('Density of pixels')

%Histogram equalization manually
S=zeros(1,256);
NewPic=zeros(1,256);
for i=1:256     
    for j=1:i          
        S(i)=HG(j)+S(i);                 %leave space for equalization
        NewPic(i)=round(S(i)*256);
    end
end

PE=Pic;
for i=0:255     
    PE(find(Pic==i))=NewPic(i+1);              %New image
end
subplot(3,2,3),imshow(PE)                      
title('Picture after equlization')

for i=1:256     
    GPeq(i)=sum(HG(find(NewPic==i)));          %find the density
end

subplot(3,2,4),bar(0:255,GPeq,'b')              %Write the Equlization histogram
title('Equlization histogram')
xlabel('Value of pixels')
ylabel('Density of pixels')


%--------------------------------Part 2-------------------------------
FSCS=imadjust(Pic,[0,0.4],[0.0,1.0]);
subplot(3,2,5)
imshow(FSCS)
title('FSCS image')

for k=0:255     
    HG(k+1)=length(find(FSCS==k))/(m*n);    %find the density of each level
end
subplot(3,2,6),bar(0:255,HG,'b')           %write the histogram
title('FSCS histogram')
xlabel('Value of pixels')
ylabel('Density of pixels')

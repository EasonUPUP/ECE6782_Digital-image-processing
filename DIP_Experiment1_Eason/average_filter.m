clear all;
close all;
videoRead = VideoReader('Calcium500frames.avi'); %????
nFrameRead = videoRead.NumberOfFrames;  %???????
% vidHeightRead = videoRead.Height;       %??????
% vidWidthRead = videoRead.width;         %??????
for i = 1 : nFrameRead;   %?????????????
   
    strtemp = strcat('F_new',int2str(i),'.','jpg');    
    F = read(videoRead,i);
    Y = F(:,:,1);                      
    Cb = F(:,:,2);
    Cr = F(:,:,3);
 
    H = fspecial('average',[3 3]); % ??????
    H = fspecial('gaussian',[3 3],0.5); % ??????
    F_Y=imfilter(Y,H,'replicate');
    F_Cb=imfilter(Cb,H,'replicate');
    F_Cr=imfilter(Cr,H,'replicate');  
    
    F_new = cat(3,F_Y,F_Cb,F_Cr);      %?????????? cat??
    imwrite(F_new,strtemp,'JPG');       % ????????????
end

myobj = VideoWriter('result.avi');     % ????????
writerObj.FrameRate =30;               % ???????
open(myobj);                           % ??????
for i = 1:nFrameRead;                  % ???????????
    fname = strcat('F_new',num2str(i),'.jpg');
    frame = imread(fname);
    writeVideo(myobj,frame);           
end
close(myobj);
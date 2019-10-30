video = VideoReader('Calcium500frames.avi');
tfStake(512,512,500)= 0;
Image = read(video);

for a=1:500
   Frame(:,:,a)=double(rgb2gray(Image(:,:,:,a)));
end

for a=1:500
   Frame(:,:,a)=imgaussfilt3(Frame(:,:,a),3);
end


% I50=double(rgb2gray(Image(:,:,:,50)));
% I100=double(rgb2gray(Image(:,:,:,100)));


%----------------------dF_F0=dF/F=(F-F0)/FO--------------------------------
F0 = 50;
dF_F0=zeros(512,512,500);
for i=1:500
    for m=1:512
        for n=1:512
            if(Frame(m,n,i)>F0)
                dF_F0(m,n,i)=Frame(m,n,i);
            else
                dF_F0(m,n,i)=0;
            end
        end
    end
end

imshow(dF_F0(:,:,50));

%------------------------Mean----------------------------------------------
% meanImg = mean(Frame, 3);
% imshow(meanImg,[]);   %the mean image of the whole video.

%Fire_time=count_fire();

FinalImg(512,512)=0;
get_neuron(dF_F0);








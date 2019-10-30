%------------------------Wavelet filter denoise----------------------------
after_wavelet_denoise=zeros(512,512,500);
for i=1:500
   after_wavelet_denoise(:,:,i)=wavelet(Frame(:,:,i)); 
end
subplot(2,2,1);imshow(double(Frame(:,:,50)),[]);title("Originai Frame50");
subplot(2,2,2);imshow(after_wavelet_denoise(:,:,50),[]);title("Wavelet Frame50");
subplot(2,2,3);imshow(double(Frame(:,:,100)),[]);title("Originai Frame100");
subplot(2,2,4);imshow(after_wavelet_denoise(:,:,100),[]);title("Wavelet Frame100");


%-----------wiener2 2-D adaptive noise-removal filtering-------------------
after_wiener2_denoise=zeros(512,512,500);
for i=1:500
   after_wiener2_denoise(:,:,i)=wiener2(double(Frame(:,:,i)),[10 10]);
end
subplot(2,2,1);imshow(double(Frame(:,:,50)),[]);title("Originai Frame50");
subplot(2,2,2);imshow(after_wiener2_denoise(:,:,50),[]);title("Wiener Frame50");
subplot(2,2,3);imshow(double(Frame(:,:,100)),[]);title("Originai Frame100");
subplot(2,2,4);imshow(after_wiener2_denoise(:,:,100),[]);title("Wiener Frame100");


%------------------------Both filter denoise-------------------------------
after_wavelet_denoise=zeros(512,512,500);
for i=1:500
   after_wavelet_denoise(:,:,i)=wavelet(double(Frame(:,:,i))); 
end

after_wiener2_denoise=zeros(512,512,500);
for i=1:500
    after_wiener2_denoise(:,:,i)=wiener2(after_wavelet_denoise(:,:,i),[10 10]);
end
subplot(2,2,1);imshow(double(Frame(:,:,50)),[]);title("Originai Frame50");
subplot(2,2,2);imshow(after_wiener2_denoise(:,:,50),[]);title("Both Frame50");
subplot(2,2,3);imshow(double(Frame(:,:,100)),[]);title("Originai Frame100");
subplot(2,2,4);imshow(after_wiener2_denoise(:,:,100),[]);title("Both Frame100");

%------------------------Gaussian filter denoise-------------------------------
subplot(2,2,1);imshow(I50,[]);title("Originai Frame50");
subplot(2,2,2);imshow(imgaussfilt3(I50,3),[]);title("mgaussfilt3 Frame50");
subplot(2,2,3);imshow(I100,[]);title("Originai Frame100");
subplot(2,2,4);imshow(imgaussfilt3(I100,3),[]);title("mgaussfilt3 Frame100");


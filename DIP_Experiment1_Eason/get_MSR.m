after_wavelet_denoise=zeros(512,512);
after_imgaussfilt3_denoise=zeros(512,512);
after_wiener2_denoise=zeros(512,512);
after_both_denoise=zeros(512,512);

after_wavelet_denoise=wavelet(I); 
after_wiener2_denoise=wiener2(I,[10 10]);
after_imgaussfilt3_denoise=imgaussfilt3(I,3);
after_both_denoise=wiener2(after_wiener2_denoise,[10 10]);

MSE_after_wavelet_denoise=mse(after_wavelet_denoise-I)
MSE_after_wiener2_denoise=mse(after_wiener2_denoise-I)
MSE_after_imgaussfilt3_denoise=mse(after_imgaussfilt3_denoise-I)
MSE_after_both_denoise=mse(after_both_denoise-I)
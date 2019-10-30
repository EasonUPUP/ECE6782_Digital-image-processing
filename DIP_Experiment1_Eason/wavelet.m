function after_wavelet_denoise=wavelet(X)

    %subplot(1,3,1);imshow(X,[]);
    %xlabel('Original image');

    %twice wavelet
    [c,s] = wavedec2(X,2,'coif3');
    n = [1,2];
    p = [10.12,23.28];

    nc = wthcoef2('h',c,s,n,p,'s');
    nc = wthcoef2('v',nc,s,n,p,'s');
    nc = wthcoef2('d',nc,s,n,p,'s');

    X1 = waverec2(nc,s,'coif3');
    %subplot(1,3,2);imshow(X1,[]);
    %xlabel('(b)first time');

    xx = wthcoef2('v',nc,s,n,p,'s');
    after_wavelet_denoise = waverec2(xx,s,'coif3');
    %subplot(1,3,3);imshow(X2,[]);
    %xlabel('after wavelet denoise');

end
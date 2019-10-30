function FinalImg=get_neuron(dF_F0)

    FinalImg(512,512)=0;

    for m=1:512
        for n=1:512
            FinalImg(m,n)=max(dF_F0(m,n,:));
        end
    end

    subplot(1,2,1);imshow(FinalImg,[]); title("Final Image 1");

    F0 = 100;
    for m=1:512
        for n=1:512
            if(FinalImg(m,n)>F0)
               FinalImg(m,n)=Frame(m,n);
            else
               FinalImg(m,n)=0;
            end
        end
    end

    subplot(1,2,2);imshow(FinalImg,[]); title("Final Image 2");

end
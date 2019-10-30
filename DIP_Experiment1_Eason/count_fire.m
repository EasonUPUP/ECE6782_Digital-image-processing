    delta=0.9;
    Fire_time=0;
    Hist_fire_time=zeros(505,505);
    Frame_fire_time=zeros(1,505);
    
    for i=1:500
                if(dF_F0(381,150,i) > (175*delta)) 
                    Fire_time=Fire_time+1;
                end

                if(Frame(347,195,i) > (178*delta))
                    Fire_time=Fire_time+1;
                end

                if(Frame(308,224,i) > (218*delta))
                    Fire_time=Fire_time+1;
                end

                if(Frame(346,279,i) > (117*delta))
                    Fire_time=Fire_time+1;
                end

                if(Frame(291,236,i) > (201*delta))
                    Fire_time=Fire_time+1;
                end

                if(Frame(234,414,i) > (191*delta))
                    Fire_time=Fire_time+1;
                end

                if(Frame(181,490,i) > (199*delta))
                    Fire_time=Fire_time+1;
                end

                if(Frame(281,451,i) > (220 *delta))
                    Fire_time=Fire_time+1;
                end

                if(Frame(274,464,i) > (183 *delta))
                    Fire_time=Fire_time+1;
                end

                if(Frame(249,498,i) > (190*delta))
                    Fire_time=Fire_time+1;
                end
                
                Frame_fire_time(i+1) = Fire_time-Frame_fire_time(i);
                Hist_fire_time()=Frame_fire_time(i+1);
                Frame_fire_time=0;
    end




         
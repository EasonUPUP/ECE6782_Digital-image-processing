%read the video
obj.reader = vision.VideoFileReader('Girl_Converted.mov'); 
% aviobj = avifile('t2.avi');

%GMM algo
I1 = imread('pic\1.png');
fr_bw =I1;
[height,width] = size(fr_bw);           
fg = zeros(height, width);             
bg_bw = zeros(height, width);
row = height;  
col = width; 
Hu=cell(1000,1);

%----------GMM model part-------%
nFrames=1;                             
C = 3;                                  % Number of GMM model
M = 3;                                  % background model number 
D = 2.5;                                % threshold of bias
alpha = 0.01;                           % rate of learning
thresh = 0.25;                          % threshold
sd_init = 15;                           % inilizate var
w = zeros(height,width,C);              
mean = zeros(height,width,C);           
sd = zeros(height,width,C);             % standard deviation
u_diff = zeros(height,width,C);         % distdance
p = alpha/(1/C);                        % update mean and standard deviation
rank = zeros(1,C);                      % Priority of each Gaussian distribution (w / sd)

pixel_depth = 8;                        
pixel_range = 2^pixel_depth -1;         % [0,255]

for i=1:height
    for j=1:width
        for k=1:C
            mean(i,j,k) = rand*pixel_range;     % Mean of the k-th Gaussian distribution
            w(i,j,k) = 1/C;                     % Weight of the k-th Gaussian distribution
            sd(i,j,k) = sd_init;                % Standard deviation of the k-th Gaussian distribution
            
        end
    end
end

  while ~isDone(obj.reader)
    frame = obj.reader.step(); 
    I2=rgb2gray(frame);
    I3=I2*256;
    fr_bw =uint8(I3);       
    % Calculate the absolute distance between the new pixel and the mean of the m-th Gaussian model
    for m=1:C
        u_diff(:,:,m) = abs(double(fr_bw) - double(mean(:,:,m)));
    end
     
    % Update the parameters of the Gaussian model
    for i=1:height
        for j=1:width
            match = 0;                                       % match label
            for k=1:C                       
                if (abs(u_diff(i,j,k)) <= D*sd(i,j,k))       % Pixel matches the k-th Gaussian model
                    
                    match = 1;                               % matched
                    
                    % Update weight, mean, standard deviation, p
                    w(i,j,k) = (1-alpha)*w(i,j,k) + alpha;
                    p = alpha/w(i,j,k);                  
                    mean(i,j,k) = (1-p)*mean(i,j,k) + p*double(fr_bw(i,j));
                    sd(i,j,k) =   sqrt((1-p)*(sd(i,j,k)^2) + p*((double(fr_bw(i,j)) - mean(i,j,k)))^2);
                else                                         % Pixels do not match the k-th Gaussian model
                    w(i,j,k) = (1-alpha)*w(i,j,k);           % decrease weight
                    
                end
            end
            
                  
            bg_bw(i,j)=0;
            for k=1:C
                bg_bw(i,j) = bg_bw(i,j)+ mean(i,j,k)*w(i,j,k);
            end
            
            % Pixel values ??do not match any of the Gaussian models, then a new model is created
            if (match == 0)
                [min_w, min_w_index] = min(w(i,j,:));      
                mean(i,j,min_w_index) = double(fr_bw(i,j));
                sd(i,j,min_w_index) = sd_init;             
             end

            rank = w(i,j,:)./sd(i,j,:);                    
            rank_ind = [1:1:C];    %Priority index
           
            
            % foreground
            
            fg(i,j) = 0;
            while ((match == 0)&&(k<=M))
           
                    if (abs(u_diff(i,j,rank_ind(k))) <= D*sd(i,j,rank_ind(k)))% Pixels match the k-th Gaussian model
                        fg(i,j) = 0;      %background-->black
           
                    else
                        fg(i,j) = 255;    %foreground-->white 
                    end
                k = k+1;
            end
        end
    end
    
        FG=uint8(fg);
%     figure(c)
%     imshow(FG);


%%%%Projection
     if(nFrames>1)
            I2=FG;
            [N Hd] = L2;   
            %N is the order of the filter (the .m function of the filter plus the output N),
            %and L2 is the selected low-pass filter (changing the filter only modifies L2)
            
            image1=I2;
            image2=zeros(row,round(N/2));
            
            I= [image1 image2];
            
            % vertical projection
            for y=1:col+round(N/2)
                S(y)=sum(I(:,y));
            end
            output=filter(Hd,S);  %LPF
            DataFilter=output(1,round(N/2):col+round(N/2));   
            
            IndMin=find(diff(sign(diff(DataFilter)))>0)+1;    
            
            % draw the Rectangle
            sThreshold=800000; 
            yThreshold = 1500; 
            C1=numel(IndMin);  
            pic=cell(C1,1); 
            
             for i=1:C1-1
                pic{i}=imcrop(I,[IndMin(i),1,IndMin(i+1)-IndMin(i),row]);
                numVal= sum(sum(pic{i}));
            if numVal>sThreshold
                 leftEdge = IndMin(i); 
                 wd = IndMin(i+1)-IndMin(i); 
             else
                  continue;
            end
             
            
           % Horizontal projection
                [m n]=size(pic{i});
                for x=1:m
                    A(x)=sum(I(x,:));
                end
                
                [x0,y0]=find(A>yThreshold);       
                topEdge = min(y0); 
                hg = max(y0) -  min(y0);  
                
                cenx = leftEdge + wd/2;
                ceny = topEdge + hg/2;  
                
                cenx1 =  round(cenx);
                ceny1 =  round(ceny);
             end
                touying=[leftEdge topEdge wd hg];
                rect=touying;  
                %
%%%%%%% Tracking part
                      
                  temp=imcrop(frame,rect);
                   [a,b,c]=size(temp); 
                    y(1)=a/2;
                    y(2)=b/2;
    %                 tic_x=rect(1)+rect(3)/2;
    %                 tic_y=rect(2)+rect(4)/2;
                    m_wei=zeros(a,b);
                    h=y(1)^2+y(2)^2 ;

                    for i=1:a
                        for j=1:b
                            dist=(i-y(1))^2+(-y(2))^2;
                            m_wei(i,j)=1-dist/h; % epanechnikov profile
                        end
                    end
                    C3=1/sum(sum(m_wei));%nor
                
                
                %hist1=C*wei_hist(temp,m_wei,a,b);%target model
                hist1=zeros(1,a*b);
                for i=1:a
                    for j=1:b   
                       
                        q_r=fix(double(temp(i,j,1))/16);     
                        q_g=fix(double(temp(i,j,2))/16);
                        q_b=fix(double(temp(i,j,3))/16);
                        q_temp=q_r*256+q_g*16+q_b;            
                        % Set the proportion of red, green and blue components of each pixel
                        hist1(q_temp+1)= hist1(q_temp+1)+m_wei(i,j);    
                    end
                end
                hist1=hist1*C3;
                rect(3)=ceil(rect(3));
                rect(4)=ceil(rect(4));
                
                
                Hu{nFrames,1}=hist1;         
                
                if(nFrames>2)            %Tracking starts from the third frame
                Im = frame;  
                num=0;
                Y=[2,2];
                Hu_temp= Hu{nFrames-1,1} %Target characteristics of the previous frame
         %%%%%%% Mean shift
            while((Y(1)^2+Y(2)^2>0.5)&num<20)   %Iteration condition
                num=num+1;
               temp1=imcrop(Im,rect); 
               
               %hist2=C*wei_hist(temp1,m_wei,a,b);%target candidates pu                                                                                                                                                                                                                                                                                                                                                                                                                          
               hist2=zeros(1,a*b);
               for i=1:a
                 for j=1:b
                q_r=fix(double(temp1(i,j,1))/16);
                q_g=fix(double(temp1(i,j,2))/16);
                q_b=fix(double(temp1(i,j,3))/16);
                q_temp1(i,j)=q_r*256+q_g*16+q_b;
                hist2(q_temp1(i,j)+1)= hist2(q_temp1(i,j)+1)+m_wei(i,j);
                 end
               end
               hist2=hist2*C3; 
               w1=zeros(1,a*b);
               for i=1:a*b
                   if(hist2(i)~=0)
                      w1(i)=sqrt(Hu_temp(i)/hist2(i));      
                   else
                   w1(i)=0;
                   end
               end

                
                sum_w=0;
                xw=[0,0];
               for i=1:a;
                   for j=1:b
                       sum_w=sum_w+w1(uint32(q_temp1(i,j))+1);            
                       xw=xw+w1(uint32(q_temp1(i,j))+1)*[i-y(1)-0.5,j-y(2)-0.5];                    
                   end
               end
               Y=xw/sum_w;
                  %update predict point
                   rect(1)=rect(1)+Y(2);
                   rect(2)=rect(2)+Y(1);
            end
                   v1=rect(1);
                   v2=rect(2);
                   v3=rect(3);
                   v4=rect(4);
                tic_x=rect(1)+rect(3)/2;    %predict point
                tic_y=rect(2)+rect(4)/2;
%      % compare
                if(1)
                    mubiao=touying;
                end
                %% 
                %%result
                figure(2);
                imshow(frame);              
                hold on
                plot([v1,v1+v3],[v2,v2],[v1,v1],[v2,v2+v4],[v1,v1+v3],[v2+v4,v2+v4],[v1+v3,v1+v3],[v2,v2+v4],'LineWidth',2,'Color','r')
                plot(tic_x,tic_y, 'm-.s','MarkerSize',5, 'LineWidth', 1)    % retangle
                text(3, 20, sprintf('%d frame', nFrames), 'FontWeight', 'Bold', 'Color', 'r');
                text(3, 80, sprintf('(%d, %d)', tic_x, tic_y), 'FontWeight', 'Bold', 'Color', 'r');
                hold off
                end               
                figure(1);
                imshow(frame);              
                hold on
                rectangle('Position',[leftEdge topEdge wd hg], 'EdgeColor', 'r', 'LineWidth', 4); %???????????
                plot(cenx1,ceny1,'LineWidth',3,'Color','b');
                text(leftEdge, topEdge-11, sprintf('01'), 'FontWeight', 'Bold', 'Color', 'r');
                text(3, 20, sprintf('%d frame', nFrames), 'FontWeight', 'Bold', 'Color', 'r');
                text(3, 80, sprintf('(%d, %d)', cenx1, ceny1), 'FontWeight', 'Bold', 'Color', 'r');
                hold off
%                 F=getframe(gcf); 
%                 imwrite(F.cdata,strcat('pic\',num2str(c),'.png'),'png')
%                 str = ['pic\', num2str(c) '.png'];
%                 picdata = imread(str);
%                 aviobj=addframe(aviobj, picdata); 
                 
            end 
            nFrames=nFrames+1;
    end
% aviobj=close(aviobj);
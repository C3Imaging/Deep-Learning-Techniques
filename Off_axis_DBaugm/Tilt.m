
function [tilt_image,tilt_mask,tilt_whole_mask]=Tilt(image,mask,whole_mask)


%choose direction of tilt & random variables for tilt transformation

%%
equation = rand;

if equation<=0.5
    a = (rand * (0.45 - 0.15))+0.15;
    b = (rand * (0.45 - 0.15))+0.15;
    c =(rand* (1-0.9))+0.9;
    d =(rand* (0.1-0))+0;
else
    a =(rand* (0.1-0))+0;
    b=(rand* (0.1-0))+0;
    c =(rand* (0.9-0.55))+0.55;
    d = (rand * (0.45 - 0.15))+0.15;
end

tilt = [a, b ; c, d ; 1 1 ; 0 1];

Orig_image=image;
empty=ones(120,160);
udata1 = [0 1];  vdata1 = [0 1];
udata2 = [0 1];  vdata2 = [0 1];
udata3 = [0 1];  vdata3 = [0 1];
udata4 = [0 1];  vdata4 = [0 1];
%%

% define tilt transformation

tform = maketform('projective',[ 0 0;  1  0;  1  1; 0 1],...
                                tilt);
                         
% tilt the original image 

[tilted,xdata1,ydata1] = imtransform(Orig_image, tform, 'nearest', ...
                              'udata', udata1,...
                              'vdata', vdata1,...
                              'size', size(Orig_image),...
                              'fill', 1);
                          
% tilt an empty image so that you know the empty pixels

[tilt_empty,xdata2,ydata2] = imtransform(empty, tform, 'nearest', ...
                             'udata', udata2,...
                             'vdata', vdata2,...
                             'size', size(Orig_image),...
                             'fill', 0);
% tilt the mask 
                         
[tilt_mask,xdata3,ydata3] = imtransform(mask, tform, 'nearest', ...
                                 'udata', udata3,...
                                 'vdata', vdata3,...
                                 'size', size(mask),...
                                 'fill', 0);   
% tilt the whole_mask 
                         
[tilt_whole_mask,xdata4,ydata4] = imtransform(whole_mask, tform, 'nearest', ...
                                 'udata', udata4,...
                                 'vdata', vdata4,...
                                 'size', size(whole_mask),...
                                 'fill', 0);   
tilt_interp_row=uint8(tilted);
tilt_interp_col=uint8(tilted);
%%


% interpolate the empty values of the tilt image
%(the empty values are known from the: tilt_empty)
 
% interpolation based on rows

for i=1:120
    for j=1:159
        if tilt_empty(i,j)==0 && tilt_empty(i,j+1)==1
            for k=1:j
            tilt_interp_row(i,k)= tilt_interp_row(i,j+1);
            end
        end
        if tilt_empty(i,j)==1 && tilt_empty(i,j+1)==0
            for l=j+1:160
                tilt_interp_row(i,l)= tilt_interp_row(i,j);
            end
        end
    end
end


%interpolation based on columns

for j=1:160
    for i=1:119
        if tilt_empty(i,j)==0 && tilt_empty(i+1,j)==1
            for k=1:i
                tilt_interp_col(k,j)= tilt_interp_col(i+1,j);
            end
        end
        if tilt_empty(i,j)==1 && tilt_empty(i+1,j)==0
            for l=i+1:120
                tilt_interp_col(l,j)= tilt_interp_col(i,j);
            end
        end
    end
end

% average the interpolate tilted images (rows,columns)

tilt_interp_row=double(tilt_interp_row);
tilt_interp_col=double(tilt_interp_col);
tilt_image=(tilt_interp_row+tilt_interp_col)/2;
tilt_image=uint8(tilt_image);

% apply gaussian filter to smooth the edges

filter_gauss = fspecial('gaussian',3,2);

%%

% tilt image

tilt_image = roifilt2(filter_gauss,tilt_image,~(tilt_empty>0));


%tilt mask

tilt_mask=uint8(tilt_mask);

% tilt whole mask
tilt_whole_mask=uint8(tilt_whole_mask);


end
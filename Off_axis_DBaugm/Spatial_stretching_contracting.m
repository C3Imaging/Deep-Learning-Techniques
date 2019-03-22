 function [warped_image,warped_mask,warped_whole_mask]= Spatial_stretching_contracting(image,mask,whole_mask)

% Spatial stetching/contracting (warping)  for an image  [120,160]

%%

%define the variables for the equations

x_col = 1:160;
x_row = 1:120;
equation = rand;
col = (rand * 15)+2;
row = (rand * 15)+2;
expansion_col=5;
expansion_row=5;


%choose direction of stretching/contracting (up+left/ up+right/down+left /down+right)

 if equation >= 0 && equation<.25 
     y_col = ((1/col-col)/159)*(x_col-1)+col;
     y_row = ((1/row-row)/119)*(x_row-1)+row;
 elseif equation >= .25 && equation <.5
     y_col= ((col-1/col)/159)* (x_col-1)+ (1/col);
     y_row= ((row-1/row)/119)* (x_row-1)+ (1/row);
 elseif equation >= .5 && equation <.75
     y_col = ((1/col-col)/159)*(x_col-1)+col;
     y_row= ((row-1/row)/119)* (x_row-1)+ (1/row);
 else 
      y_col= ((col-1/col)/159)* (x_col-1)+ (1/col);
      y_row = ((1/row-row)/119)*(x_row-1)+row;
 end
 
 %%
 
% stretch the columns of the image

ImWarped_col(:,1) = image(:,1);
whereWeAre_col = 1;
for column =  2:160
    whereWeAre_col = whereWeAre_col + y_col(column);
    ImWarped_col(:,floor(whereWeAre_col * expansion_col)) = image(:,column);
end

empty_columns = (sum(ImWarped_col)==0);

% find the position of the empty columns of the image

col=size(empty_columns);
length_empty_col=col(2);
j=1;
interp_col=ImWarped_col;
for i=1:length_empty_col-1
  if empty_columns(i)== 1 && empty_columns(i+1)==0
      change_points_col(j) = i+1;
      j=j+1;
  end
end

% interpolate the empty columns of the image

b_col=size(change_points_col);
length_change_col=b_col(2);
start_point=1 ;
for k=1:length_change_col 
    end_point=change_points_col(k);
    for i=start_point+1:end_point-1
        valueL= ImWarped_col(:,start_point)*(1/(i-start_point));
        valueR= ImWarped_col(:,end_point) * (1/(end_point-i));
        valueD= (1/(i-start_point)) + (1/(end_point-i));
        value_col= (valueL + valueR)/ valueD;
        interp_col(:,i)=value_col;
    end
   start_point=end_point;
end

% image: after spatial stretch/contracting of the columns 

image_warped_col=imresize(interp_col,[120,160]);

%%

% stretch rows of the image

ImWarped_row(1,:) = image_warped_col(1,:);
whereWeAre_row = 1;
for row =  2:120
    whereWeAre_row = whereWeAre_row + y_row(row);
    ImWarped_row(floor(whereWeAre_row * expansion_row),:) = image_warped_col(row,:);
end
empty_rows = (sum(ImWarped_row,2)==0);

% find empty rows of the image

row=size(empty_rows);
length_empty_row=row(1);
j=1;
interp_row=ImWarped_row;
for i=1:length_empty_row
  if empty_rows(i)== 1 && empty_rows(i+1)==0
      change_points_row(j) = i+1;
      j=j+1;
  end
end

% interpolate the empty rows of the image

b_row=size(change_points_row);
length_change_row=b_row(2);
start_point=1;
for k=1:length_change_row 
    end_point=change_points_row(k);
    for i=start_point+1:end_point-1
        valueL= ImWarped_row(start_point,:)*(1/(i-start_point));
        valueR= ImWarped_row(end_point,:) * (1/(end_point-i));
        valueD= (1/(i-start_point)) + (1/(end_point-i));
        value_row= (valueL + valueR)/ valueD;
        interp_row(i,:)=value_row;
    end
   start_point=end_point;
end

% image: after spatial stretch/contracting of the columns + rows 

interp_row=uint8(interp_row);

image_warped_rows=imresize(interp_row,[120,160]);

%%

% Final spatial stretched/contracted image

warped_image= image_warped_rows;

%%

% Spatial stretching/contracting for the Mask


% stretch the columns of the mask

ImWarped_col_mask(:,1) = mask(:,1);
whereWeAre_col_mask = 1;
for column =  2:160
    whereWeAre_col_mask = whereWeAre_col_mask + y_col(column);
    ImWarped_col_mask(:,floor(whereWeAre_col_mask * expansion_col)) = mask(:,column);
end

% interpolate the empty columns of the mask

b_col=size(change_points_col);
length_change_col=b_col(2);
start_point=1 ;
interp_col_mask=double(ImWarped_col_mask);

for k=1:length_change_col-1
    end_point=change_points_col(k);
    for i=start_point+1:end_point-1
        valueL= interp_col_mask(:,start_point)*(1/(i-start_point));
        valueR= interp_col_mask(:,end_point) * (1/(end_point-i));
        valueD= (1/(i-start_point)) + (1/(end_point-i));
        value= (valueL + valueR)/ valueD;
        interp_col_mask(:,i)=value;
    end
   start_point=end_point;
end

%mask: after spatial stretch/contracting of the columns 

interp_col_mask=uint8(interp_col_mask);
warped_col_mask=imresize(interp_col_mask,[120,160]);

%%

% stretch the rows of the mask

ImWarped_row_mask(1,:) = warped_col_mask(1,:);
whereWeAre_row_mask = 1;
for row =  2:120
    whereWeAre_row_mask = whereWeAre_row_mask + y_row(row);
    ImWarped_row_mask(floor(whereWeAre_row_mask * expansion_row),:) = warped_col_mask(row,:);
end


%interpolate the empty rows of the mask

interp_row_mask=double(ImWarped_row_mask);
b_row=size(change_points_row);
length_change_row=b_row(2);
start_point=1;

for k=1:length_change_row
    end_point=change_points_row(k);
    for i=start_point+1:end_point-1
        valueL= interp_row_mask(start_point,:)*(1/(i-start_point));
        valueR= interp_row_mask(end_point,:) * (1/(end_point-i));
        valueD= (1/(i-start_point)) + (1/(end_point-i));
        value= (valueL + valueR)/ valueD;
        interp_row_mask(i,:)=value;
    end
   start_point=end_point;
   
end

% mask: after spatial stretch/contracting of the columns + rows 

interp_row_mask=uint8(interp_row_mask);
warped_row_mask=imresize(interp_row_mask,[120,160]);
%%

% Final spatial stretched/contracted mask

warped_mask=warped_row_mask;

%%

%Spatial stretching/contracting for the WholeMask

%stretch the columns of the WholeMask

ImWarped_col_whole_mask(:,1) = whole_mask(:,1);
whereWeAre_col_whole_mask = 1;
for column =  2:160
    whereWeAre_col_whole_mask = whereWeAre_col_whole_mask + y_col(column);
    ImWarped_col_whole_mask(:,floor(whereWeAre_col_whole_mask * expansion_col)) = whole_mask(:,column);
end

% interpolate the empty columns of the whole mask

b_col=size(change_points_col);
length_change_col=b_col(2);
start_point=1 ;
interp_col_whole_mask=double(ImWarped_col_whole_mask);

for k=1:length_change_col-1
    
    end_point=change_points_col(k);
    for i=start_point+1:end_point-1
        valueL= interp_col_whole_mask(:,start_point)*(1/(i-start_point));
        valueR= interp_col_whole_mask(:,end_point) * (1/(end_point-i));
        valueD= (1/(i-start_point)) + (1/(end_point-i));
        value= (valueL + valueR)/ valueD;
        interp_col_whole_mask(:,i)=value;
    end
   
   start_point=end_point;
   
end

% Whole Mask: after spatial stretch/contracting of the columns

interp_col_whole_mask=uint8(interp_col_whole_mask);
warped_col_whole_mask=imresize(interp_col_whole_mask,[120,160]);

%%

% stretch the rows of the Whole Mask

ImWarped_row_whole_mask(1,:) = warped_col_whole_mask(1,:);
whereWeAre_row_whole_mask = 1;
for row =  2:120
    whereWeAre_row_whole_mask = whereWeAre_row_whole_mask + y_row(row);
    ImWarped_row_whole_mask(floor(whereWeAre_row_whole_mask * expansion_row),:) = warped_col_whole_mask(row,:);
end


%interpolate the empty rows of the Whole Mask

interp_row_whole_mask=double(ImWarped_row_whole_mask);
b_row=size(change_points_row);
length_change_row=b_row(2);
start_point=1;

for k=1:length_change_row
    
    end_point=change_points_row(k);
    for i=start_point+1:end_point-1
        valueL= interp_row_whole_mask(start_point,:)*(1/(i-start_point));
        valueR= interp_row_whole_mask(end_point,:) * (1/(end_point-i));
        valueD= (1/(i-start_point)) + (1/(end_point-i));
        value= (valueL + valueR)/ valueD;
        interp_row_whole_mask(i,:)=value;
    end
   
   start_point=end_point;
   
end


% whole mask: after spatial stretch/contracting of the columns + rows 
interp_row_whole_mask=uint8(interp_row_whole_mask);
warped_row_whole_mask=imresize(interp_row_whole_mask,[120,160]);


%% 

% Final spatial stretched/contracted WholeMask

warped_whole_mask=warped_row_whole_mask;

 end
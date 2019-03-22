clc
clear all;
close all;

load 'database including Images, Mask and WholeMask'

% dimensions : [120x160]

Distorted_Images=uint8(zeros(length(Images),120,160));
Distored_Mask=uint8(zeros(length(Mask),120,160));
Distorted_Whole_Mask=uint8(zeros(length(WholeMask),120,160));

for imNum = 1:size(Distorted_Images , 1)
    
image = squeeze(Images(imNum,:,:));
mask  = squeeze(Mask(imNum,:,:));
whole_mask = squeeze(WholeMask(imNum,:,:));
 
% Spatial stetching/contracting define the variables for the equations

[warped_image,warped_mask,warped_whole_mask]= Spatial_stretching_contracting(image,mask,whole_mask);

% Tilt 

[warped_tilt_image,warped_tilt_mask,warped_tilt_whole_mask]= Tilt(warped_image,warped_mask,warped_whole_mask);
 
Distorted_Images(imNum,:,:)=warped_tilt_image;
Distored_Mask(imNum,:,:)=warped_tilt_mask;
Distorted_Whole_Mask(imNum,:,:)=warped_tilt_whole_mask;

end
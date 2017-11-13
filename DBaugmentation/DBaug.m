%Database expansion
%Images are in a [sampleNumber,96,128] tensor named "ImageTensor"
%Iris Mask are in a [sampleNumber,96,128] tensor named "MaskTensor"
%Whole Iris Mask are in a [sampleNumber,96,128] tensor named "MaskWholeTensor"
%Augmented samples are in " ImageTensorShadowed"

clc
clear all
close all

load 'database including ImageTensor, MaskTensor and MaskWholeTensor'


ImageTensorShadowed = uint8(zeros(size(ImageTensor)));
for imNum = 1:size(ImageTensor , 1)
    x = linspace(0,1,256);
    y = tanh(3*(x-.5 + (rand-.5)*.6));
    y = (y-min(y))/(max(y)-min(y));
   
    
    yin = tanh(3*(x-.5 - (rand)*.8));
    yin = (yin-min(yin))/(max(yin)-min(yin));
    
    x = x*255;
    y = y*255;
    yin = yin*255;
    image = squeeze(ImageTensor(imNum , : , :));
    maskWhole = squeeze(MaskWholeTensor(imNum , : , :));
    
    imIrisWhole = image(maskWhole);
    imNonIrisWhole = image(~maskWhole);
    
    irisT = yin(imIrisWhole+1);
    nonIrisT = y(imNonIrisWhole+1);
    

    x2 = linspace(0,1,128);
    y2 = tanh(2*(sign(randn)*(x2-.5 + (rand-.5)*.6)));
    y2 = (y2-min(y2))/(max(y2)-min(y2));
    y2 = y2+.1*(rand);
    imageTemp = uint8(zeros(96,128));
    imageTemp(~maskWhole) = nonIrisT;
    imageTemp(maskWhole) = irisT;
    for ii = 1 : 128
        imageTemp(: , ii) = imageTemp(: , ii)*y2(ii);
    end
    
    h = fspecial('motion' , 5+rand*5 , rand*2*pi);
    imageTemp2 = imfilter(imageTemp,h,'replicate');
    ImageTensorShadowed(imNum , : , :) = imageTemp2;
    if mod(imNum,100)==0
        imNum
    end
end


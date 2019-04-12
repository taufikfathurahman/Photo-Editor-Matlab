function edit(handles)
global image;
global brightness;
global brightnessIndex;
global contrast;
global contrastIndex;
global resolution;
global resolutionIndex;
global rotation;
global rotationIndex;
global resize;
global resizeIndex;
global flippedH;
global flippedV;
global isCropped;
global croppedImage;
global colorType;
global indexedY;
global indexedMap;
global imageTransformsIndex;
global imageTransforms;
global isMapped;
global width;
global height;
global whIndex;


editImage = image;

%crop
if isCropped == 1
    editImage = croppedImage;
end

if resize(resizeIndex) > 0
    editImage = imresize(editImage ,resize(resizeIndex)/100);
else
    editImage = imresize(editImage, 0.001);
end

editImage = imresize(editImage, [height(whIndex) width(whIndex)]);

%transformation functions

for i = 1:imageTransformsIndex
   u = imageTransforms(i);
   switch u
        case 8 %rgb2gray
            editImage = rgb2gray(editImage);
            colorType = 'grayscale';
        case 9 %gray2rgb
            editImage= gray2rgb(editImage);
            colorType = 'truecolor'; 
   end
end
set(handles.image_type_txt, 'string', colorType);

%flip
if flippedH == 1
    editImage = imrotate(editImage , 180);
end
if flippedV == 1
    editImage = flipdim(editImage, 2);
end
axes(handles.axes2);
imshow(editImage)

%brightness
editImage = imadd(editImage, brightness(brightnessIndex)*25);

%contrast
if contrast(contrastIndex) > 0
    editImage = immultiply(editImage, contrast(contrastIndex)*2.55);
elseif contrast(contrastIndex) < 0
    editImage = imdivide(editImage, -1*contrast(contrastIndex)*2.55);
end

%rotation
editImage = imrotate(editImage, rotation(rotationIndex)*-1);

axes(handles.axes2);
imshow(editImage)

% color mappping
x = strcmp(colorType, 'grayscale');
if x == 1 && isMapped == 1
    s = get(handles.color_map_menu,'Value');
    axes(handles.axes2);
    s = s-1;
    switch s 
        case 1 
            colormap hsv;
        case 2
            colormap hot;
        case 3 
            colormap gray ;
        case 4
            colormap bone;
        case 5 
            colormap copper;
        case 6
            colormap pink;
        case 7 
            colormap white;
        case 8
            colormap flag;
        case 9 
            colormap lines;
        case 10
            colormap colorcube;
        case 11 
            colormap vga;
        case 12
            colormap jet;
        case 13
            colormap prism;
        case 14 
            colormap cool;
        case 15
            colormap autumn;
        case 16 
            colormap spring;
        case 17
            colormap winter;
        case 18
            colormap summer;
    end
end
end
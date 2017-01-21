function  crop_boxes(boxes, image, name)
% Crop boxes out of image and save in crops folder

nboxes = size(boxes,1);
mkdir crops
for i = 1:nboxes
   
    crop = image(boxes(i,2):boxes(i,2) + boxes(i,4) - 1 ,boxes(i,1) : boxes(i,1) + boxes(i,3) - 1,:);
    fname = strcat('crops/',name,'_',num2str(i),'.png');
    imwrite(crop,fname);
end

end


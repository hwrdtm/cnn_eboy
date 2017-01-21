% data generation

data_dir = '/';

% change this
collection = 'test 2.png';
% collection = 'test_img.png';

im = imread(fullfile(data_dir,collection),'BackgroundColor','none');

% imshow(im);

% save('test.png','im');
% imwrite(im,'test.png');

object = identifyObject(im)
% imshow(im(:,:,:));

%% Reconstruct object

% Pad image

% Default x padding 
x_pad = min(object(:,1)) - 1;
% Default y padding
y_pad = min(object(:,2)) - 1;

% Apply same padding to other side, ie max. x / y position
% Do this by initiating white matrix / canvas (255 pixel values)
max_x = max(object(:,1));
max_y = max(object(:,2));

reconstruction = ones(max_y + y_pad, max_x + x_pad, 3);
reconstruction = reconstruction * 255;

% Paint
for row = 1:size(object,1)
   pixel = object(row,:);

   reconstruction(pixel(2),pixel(1),1) = pixel(3);
   reconstruction(pixel(2),pixel(1),2) = pixel(4);
   reconstruction(pixel(2),pixel(1),3) = pixel(5);
end

% IMPORTANT: Convert to uint8 array to imshow properly
reconstruction = uint8(reconstruction);

% Show image
imshow(reconstruction);

% Note: you can imagine the data construction step over the 
% pixoramas to be painting the 'object' over a pre-populated
% background.





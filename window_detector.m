%
% Princeton University, COS 429, Fall 2016
%
% find_faces_single_scale.m
%   Find 36x36 faces in an image
%
% Inputs:
%   img: an image
%   net: cnn to perform classification of patches
%   stride: how far to move between locations at which the detector is run
%   thresh: probability threshold for calling a detection a face
%   windowsize: [width, height]
%   nms: equal 1 to perform non maximum suppression
% Outputs:
%   outimg: copy of img with face locations marked
%   probmap: probability map of face detections
%

function [outimg, bbox, score, probmap] = window_detector(img, net, stride, thresh, windowsize, nms)


bbox = zeros(100,4);
score = zeros(100,1);
height = size(img,1);
width = size(img,2);
probmap = zeros(height, width);

w_window = windowsize(1);
h_window = windowsize(2);

stride_default = stride;
count = 1;

mean_net = net.meta.dataMean;
input_size = net.meta.inputSize;

% Loop over windowsize x windowsize windows, advancing by stride
for i = 1:stride:(height)
    for j = 1:stride:(width)
        
        % Handle indexing out of bounds
        if i > height - h_window + 1
            i = height - h_window + 1;
        end
        
        if j > width - w_window + 1
            j = width - w_window + 1;
        end
        
        % Crop out a windowsize x windowsize window starting at (i,j)
        crop = img(i: i - 1 + h_window,j:j - 1 + w_window,:);
        
        % Normalize crop
        if any(size(crop) ~= input_size)
            crop = imresize(crop,input_size(1:2));
        end
        crop = crop - mean_net;
        crop = crop * 256;
        
        % Compute score using classifier
        res = vl_simplenn(net, crop);
        loss = squeeze(gather(res(end).x));
        probability = loss(1);
        % Mark detection probability in probmap
        probmap(i:i - 1 + h_window,j:j -1 + w_window) = probability;
        
        % if close to face reduce stride otherwise reset stride
        if probability > 0.9*thresh
            stride = 1;  
        else
            stride = stride_default;
        end
        
        % If probability of a face is below thresh, continue
        if probability < thresh
            continue;
        end
        
        % Store valid box
        bbox(count,2:-1:1) = [i, j];
        score(count) = probability;
        count = count + 1;
       
    end
end

bbox( all(~bbox,2), : ) = [];                 % remove zero rows
score( all(~score,2), : ) = [];
bbox(:,3:4) = repmat(windowsize,count-1,1);     % Set width and height of boxes

% Perform nms
if nms == 1
[selectedBbox,selectedScore] = selectStrongestBbox(bbox,score,'OverlapThreshold',0.2);
else
   selectedBbox = bbox;
   selectedScore = score;
end

 % Draw box on image
 outimg = insertObjectAnnotation(img,'rectangle',selectedBbox,cellstr(num2str(selectedScore,'%0.2f')),'Color', 'red','TextBoxOpacity',0.1,'FontSize',12,'LineWidth',2);
end





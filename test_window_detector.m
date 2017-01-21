% Test window_detector

imdb = load('matlab/imdb.mat');
net = load('matlab/log_ludov2_1/net-epoch-19.mat');
net = net.net;

% Change last layer to softmax
net.layers{end}.type = 'softmax';

% Ensure net stores imdb mean
net.meta.dataMean = imdb.meta.dataMean;


img = imread('pixorama/test_detection/MCK-Korea2020-13t.png');
img = im2single(img);

stride = 3;
thresh = 0.5;
nms = 1;
windowsize = [30, 50];
[outimg, bbox, score, probmap] = window_detector(img, net, stride, thresh, windowsize, nms);
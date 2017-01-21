function ludo(varargin)

% First attempt: default options, best result early stop epoch 19

% Load imdb file
imdb = load('imdb.mat');

%imdb = load('MatConvNet/data/cifar/imdb.mat');

% Load neural net
net = eboy_nn_init_v2();


% Set training parameters
trainOpts.batchSize = 100 ;
trainOpts.numEpochs = 60 ;
trainOpts.continue = true ;
trainOpts.gpus = [] ;
%trainOpts.learningRate = 0.001 ;
trainOpts.expDir = 'log_ludov2_1/' ;
trainOpts = vl_argparse(trainOpts, varargin);

% Call training function in MatConvNet
[net,info] = cnn_train(net, imdb, @getBatch, trainOpts) ;

% Save imdb mean in net
net.meta.dataMean = imdb.meta.dataMean;

% Save the result for later use
save('log_ludov2_1/eboy_nn.mat', '-struct', 'net') ;

% -------------------------------------------------------------------------
% Part 4.4: visualize the learned filters
% -------------------------------------------------------------------------

% figure(2) ; clf ; colormap gray ;
% vl_imarraysc(squeeze(net.layers{1}.weights{1}),'spacing',2)
% axis equal ; title('filters in the first layer') ;

% -------------------------------------------------------------------------
% Part 4.5: apply the model
% -------------------------------------------------------------------------

% % Load the CNN learned before
net = load('log/eboy_nn.mat') ;
% %net = load('data/chars-experiment/charscnn-jit.mat') ;
% 
% % Load the sentence
% [im,cmap] = imread('data/sentence-lato.png') ;
% if isempty(cmap)
%   im = im2single(im) ;
% else
%   im = im2single(ind2gray(p,cmap)) ;
% end
% im = 256 * (im - net.imageMean) ;

% % Apply the CNN to the larger image
% res = vl_simplenn(net, im) ;
% 
% % Visualize the results
% figure(3) ; clf ;
% decodeCharacters(net, imdb, im, res) ;

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
im = 256 * im;
%im = reshape(im, 50, 30, 3, []);
labels = imdb.images.label(1,batch);
end

end
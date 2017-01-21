% Feed forward
function [labels_set, pred] = test_feed_forward()
imdb = load('imdb.mat');
net = load('log/net-epoch-15.mat');
net = net.net;

% Change last layer to softmax
net.layers{end}.type = 'softmax';
batch = find(imdb.images.set==1);
[ims, labels]= getBatch(imdb, batch);
labels = squeeze(labels);

% Get result for first n images 
n = 10;
labels_set = labels(1:n);
res = vl_simplenn(net, ims(:,:,:,1:10));
softmax_res = squeeze(vl_nnsoftmax(res(end-1).x));

for i=1:size(softmax_res,2)
  [~,pred(i)] = max(softmax_res(:,i));
  true_score(i) = softmax_res(labels(i),i);
end


function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
im = im * 256;
labels = imdb.images.label(1,batch) ;
end

end

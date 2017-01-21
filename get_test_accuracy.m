% Return accuracy for test set
function accuracy = get_test_accuracy(imdb, net)

% Change last layer to softmax
net.layers{end}.type = 'softmax';

% Retrieve test images
batch = find(imdb.images.set == 3);
[ims, labels]= getBatch(imdb, batch);

% Get result for test images
res = vl_simplenn(net, ims);
scores = squeeze(res(end).x);

% Predict labels
[~,prediction] = max(scores,[],1);

% Calculate accuracy
correct = nnz(prediction == labels);
accuracy = correct / size(labels,2) * 100;

function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
im = im * 256;
labels = imdb.images.label(1,batch) ;
end

end
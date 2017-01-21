% load path

% Files start from index 4 and onwards
people_patches_dir = '../pixorama/patches_people/';
npeople_patches_dir = '../pixorama/patches_not_people/';
people_patches_folder = dir('../pixorama/patches_people/');
npeople_patches_folder = dir('../pixorama/patches_not_people/');

num_people = size(people_patches_folder,1) - 3;
num_not_people = size(npeople_patches_folder,1) - 3;

[pp_trainInd, pp_valInd, pp_testInd] = dividerand(num_people,0.7,0.15,0.15);
[npp_trainInd, npp_valInd, npp_testInd] = dividerand(num_not_people,0.7,0.15,0.15);

%% Training Data

% Create data struct
train_data = [];

for i = 1:size(pp_trainInd')    
    % File name
    fname = people_patches_folder(3 + pp_trainInd(i)).name;
    fpath = strcat(people_patches_dir,fname);
    
    im = imread(fpath);
    im = im2single(im);
    
    train_data = cat(4,train_data,im);
end


for i = 1:size(npp_trainInd')
    % Random index
    %ind = randi([1 size(npp_trainInd',1)],1);
    
    % File name
    fname = npeople_patches_folder(3 + npp_trainInd(i)).name;
    fpath = strcat(npeople_patches_dir,fname);
    
    im = imread(fpath);
    im = im2single(im);
   
    train_data = cat(4,train_data,im);
end

% Randomize
indices = randperm(size(train_data,4));
train_data = train_data(:,:,:,indices);
train_labels = [ones(1,size(pp_trainInd',1)) 2*ones(1,size(npp_trainInd',1))];
train_labels = train_labels(indices);

%% Testing Data

% Create data struct
test_data = [];

for i = 1:size(pp_testInd')   
    
    % File name
    fname = people_patches_folder(3 + pp_testInd(i)).name;
    fpath = strcat(people_patches_dir,fname);
    
    im = imread(fpath);
    im = im2single(im);
    
    test_data = cat(4,test_data,im);
end

for i = 1:size(npp_testInd')
    % Random index
    %ind = randi([1 size(npp_testInd',1)],1);
    
    % File name
    fname = npeople_patches_folder(3 + npp_testInd(i)).name;
    fpath = strcat(npeople_patches_dir,fname);
    
    im = imread(fpath);
    im = im2single(im);
    
    test_data = cat(4,test_data,im);
end

% Randomize
indices = randperm(size(test_data,4));
test_data = test_data(:,:,:,indices);
test_labels = [ones(1,size(pp_testInd',1)) 2*ones(1,size(npp_testInd',1))];
test_labels = test_labels(indices);

%% Validation data

% Create data struct
val_data = [];

for i = 1:size(pp_valInd')   
    
    % File name
    fname = people_patches_folder(3 + pp_valInd(i)).name;
    fpath = strcat(people_patches_dir,fname);
    
    im = imread(fpath);
    im = im2single(im);
    
    val_data = cat(4,val_data,im);
end

for i = 1:size(npp_valInd')
    % Random index
    %ind = randi([1 size(npp_testInd',1)],1);
    
    % File name
    fname = npeople_patches_folder(3 + npp_valInd(i)).name;
    fpath = strcat(npeople_patches_dir,fname);
    
    im = imread(fpath);
    im = im2single(im);
    
    val_data = cat(4,val_data,im);
end



% Randomize
indices = randperm(size(val_data,4));
val_data = val_data(:,:,:,indices);
val_labels = [ones(1,size(pp_valInd',1)) 2*ones(1,size(npp_valInd',1))];
val_labels = val_labels(indices);


%% Concatenate
data = [];
data = cat(4,data,train_data, val_data, test_data);

labels = [train_labels, val_labels, test_labels];
%labels = single(labels);

set = [ones(1,size(train_data,4)), 2*ones(1,size(val_data,4)), 3*ones(1,size(test_data,4))];
set = int8(set);


%% Create imdb struct
imdb.images.data = data;
imdb.images.label = labels;
imdb.images.set = set;
imdb.meta.sets = cellstr({'train', 'val', 'test'});
imdb.meta.classes = cellstr({'people', 'non_people'}).';
imdb.meta.dataMean = mean(train_data,4);

% Normalize data
imdb.images.data = imdb.images.data - repmat(imdb.meta.dataMean,1,1,1,size(imdb.images.data,4));
save matlab/imdb.mat -struct imdb

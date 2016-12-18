function [Data, Labels, Metadata] = GetData(Params)
%GETDATA Loads the data and subsets it if required
% Loads the data and subsets it if required
% returns only images from classes Params.ClassIndices

%Metadata will be used later for reports
    
Categories = GetAllCategories(Params.ROOT_DIR);
Categories = Categories(Params.ClassIndices);
Metadata.Categories = Categories;

%cats = {dirs(idxs).name};
%showHist(ROOT_DIR, cats_train, 'cats_train')
%showHist(ROOT_DIR, cats_valid, 'cats_valid')
%showHist(ROOT_DIR, cats_test, 'cats_test')

% O(n_total) - we go over the cats subdirs twice
% first time for prealloc
% second time for image extraction
n_cats = length(Categories);
n_total = 0;

%% estimate number of files
for classIndex=1:n_cats %O(n_total)
    cat = Categories{classIndex};
    files = GetFiles(cat);
    n_total = n_total+length(files);
end

%% pre-allocate
TrialNum = 0;
Data = zeros(Params.S, Params.S, n_total);
Labels = nan(1, n_total);
Metadata.Filenames = cell(1, n_total);

for i=1:n_cats 
    classIndex = Params.ClassIndices(i);
    cat = Categories{i};
    
    files = GetFiles(cat);
    
    n = length(files);
    
    fprintf('Reading [#%d]%s %d files ...\n', classIndex, cat, n);
    
    for i_file=1:n
        filename = fullfile(Params.ROOT_DIR, cat, files(i_file).name);
        [img] = imread(filename);
        if (length(size(img)) == 3)
            img = rgb2gray(img);
        end
        
        %imshow(img);
        
        resized = imresize(img, [Params.S Params.S]);
        %imshow(resized);
        
        TrialNum = TrialNum+1;
        Data(:,:,TrialNum) = resized;
        
        %Note that our labels are 1:M, later we'll convert them to class indices
        Labels(TrialNum) = i;
        
        Metadata.Filenames{TrialNum} = filename;
    end
end
  
    function [fis] = GetFiles(d)
        fis = dir(fullfile(Params.ROOT_DIR, d));
        
        fis = fis(~[fis.isdir]);        
        
    end
end

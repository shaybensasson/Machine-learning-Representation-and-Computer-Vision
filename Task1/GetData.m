function [Data, Labels] = GetData(Params)
%GETDATA Loads the data and subsets it if required
% Loads the data and subsets it if required
% returns only images from classes Params.ClassIndices
    
cats = GetAllCategories(Params.ROOT_DIR);
cats = cats(Params.ClassIndices);

%cats = {dirs(idxs).name};
%showHist(ROOT_DIR, cats_train, 'cats_train')
%showHist(ROOT_DIR, cats_valid, 'cats_valid')
%showHist(ROOT_DIR, cats_test, 'cats_test')

% O(n_total) - we go over the cats subdirs twice
% first time for prealloc
% second time for image extraction
n_cats = length(cats);
n_total = 0;
for i_cat=1:length(n_cats) %O(n_total)
    cat = cats{i_cat};
    fis = GetFiles(cat);
    n_total = n_total+length(fis);
end

N = 0;
Data = zeros(Params.S, Params.S, n_total);
Labels = nan(1, n_total);

for i_cat=1:n_cats 
    cat = cats{i_cat};
    fis = GetFiles(cat);
    fprintf('Reading [#%d]%s %d files ...\n', i_cat, cat, length(fis));
    
    for j=1:length(fis)
        filename = fullfile(Params.ROOT_DIR, cat, fis(j).name);
        [img] = imread(filename);
        if (length(size(img)) == 3)
            img = rgb2gray(img);
        end
        
        %imshow(img);
        
        resized = imresize(img, [Params.S Params.S]);
        %imshow(resized);
        
        N = N+1;
        Data(:,:,N) = resized;
        Labels(N) = i_cat;
    end
end
  
    function [fis] = GetFiles(d)
        fis = dir(fullfile(Params.ROOT_DIR, d));
        fis = fis(~[fis.isdir]);
    end
end

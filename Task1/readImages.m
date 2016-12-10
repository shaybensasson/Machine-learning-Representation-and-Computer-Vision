function [ X, y ] = readImages(Params, cats )
%READIMAGES Summary of this function goes here
%   Detailed explanation goes here
%TODO: commment
% O(n_total)
    if (nargin == 0) %DEMO
        Params.ROOT_DIR = '.\101_ObjectCategories\';
        Params.S = 200;
        cats = {'snoopy'};
        
    end
    
    n_total = 0;
    for i_cat=1:length(cats) %O(n_total)
        cat = cats{i_cat};
        fis = getFiles(cat);
        n_total = n_total+length(fis);
    end
    
    N = 0;
    X = zeros(Params.S, Params.S, n_total);
    y = nan(1, n_total);
    n_files = length(cats);
    
    for i_cat=1:n_files %O(n_total)
        cat = cats{i_cat};
        fis = getFiles(cat);
        fprintf('Reading [#%d]%s %d files ...\n', i_cat, cat, length(fis));
                    
        for j=1:length(fis)
            filename = fullfile(fis(j).folder, fis(j).name);
            [img] = imread(filename);
            if (length(size(img)) == 3)
                img = rgb2gray(img);
            end
            
            %imshow(img);
            
            resized = imresize(img, [Params.S Params.S]);
            %imshow(resized);
            
            N = N+1;
            X(:,:,N) = resized;
            y(N) = i_cat;
        end
    end
    
    function [fis] = getFiles(d)
        fis = dir(fullfile(Params.ROOT_DIR, d));
        fis = fis(~[fis.isdir]);
    end

end


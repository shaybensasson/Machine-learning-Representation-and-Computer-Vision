function [Data, Labels] = GetData(Params)
%GETDATA Loads the data and subsets it if required
% Loads the data and subsets it if required
% returns only images from classes Params.ClassIndices

%Metadata will be used later for reports
    
load(Params.ROOT_DIR);

% O(n_total) - we go over the cats subdirs twice
% first time for prealloc
% second time for image extraction
n_total = length(Labels);

%% pre-allocate
TrialNum = 0;
Data = zeros(Params.S(1), Params.S(2), Params.S(3), n_total, 'single');

fprintf('Reading [#%d] image files ...\n', n_total);
for i=1:n_total 

    % resize image
    resized = imresize(single(cell2mat(Images(i))), [Params.S(1) Params.S(2)]); %resize to SxS pixels



    % standartize image
    for j = 1:Params.S(3)
        CMean = mean2(resized(:,:,j));
        CStd = std2(resized(:,:,j));
        resized(:,:,j) = (resized(:,:,j)-CMean)/CStd;
    end
    %imshow(resized);
    % get inside DATA    
    Data(:,:,:,i) = resized;
end


end

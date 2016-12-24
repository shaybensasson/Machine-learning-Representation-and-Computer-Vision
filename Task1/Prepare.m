function [DataRep] = Prepare(Data, Params)
%PREPARE Computes the representation function resulting feature space vectors
%   Transform the example image into the input form of the classifier
%   HOG:
%     Create HOG representation from the images and turn into vectors
%   SIFT:
%     Extracting SIFTS of different scales for each image

if Params.IsHOG
    Params = Params.HOG;
    
    % loop over all exampals
    fprintf('Preprocessing data (convert to HOG, Vectorize) ...\n');
    
    for IndImg = 1:size(Data,3)
        % turn into HOG represntation
        TempHog = vl_hog(single(...
                squeeze(Data(:,:,IndImg))), ...
            Params.CellSize, 'numOrientations', Params.numOrientations);
        
        %size(TempHog)
        
        % Vectorize
         if IndImg == 1
            DataRep = zeros(size(Data,3), length(TempHog(:)));
        end
        DataRep(IndImg,:) = double(TempHog(:));
    end
else
    fprintf('Preprocessing data (extracting SIFTS) ...\n');
    Params = Params.SIFT;
    
    stride = Params.Stride;
    n_features = Params.ScaleFeatures;
    n_scales = length(Params.Scales);
    
    fprintf('SIFT paramters: ...\n');
    disp(struct2table(Params));
    
    N_IMAGES = size(Data,3);
    
    DataRep = zeros(N_IMAGES, n_scales*n_features, Params.FeatureVectorDim);
    for idxImage=1:N_IMAGES
        img = Data(:,:,idxImage);
        
        if (~mod(idxImage, 10))
            fprintf('%d/%d: Extracting SIFT features ...\n', idxImage, N_IMAGES);
        end
        
        for idxScale=1:n_scales
            scale = Params.Scales(idxScale);
            
            %vl_sift(img, scale, Params.Stride);
            [~, desc] = vl_dsift(single(img), ...
                'size', scale, ...
                'step', stride, ...
                'floatdescriptors', ...
                'fast');
            
            idxs = randperm(size(desc, 2), n_features);
            
            %idxs = 1:n_features;
            features = desc(:,idxs);
            features = normc(features); %normalize vectors
            
            sub = ((idxScale-1)*n_features)+1:((idxScale)*n_features);
            DataRep(idxImage, sub, :) = features';
        end
    end
end
end


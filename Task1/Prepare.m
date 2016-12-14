function [DataRep] = Prepare(Data, Params)
%PREPARE Compute the representation function
%   Transform the example image into the input form of the classifier
%TODO: more
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
                        
        sub = ((idxScale-1)*n_features)+1:((idxScale)*n_features);
        DataRep(idxImage, sub, :) = features';
    end
end

end


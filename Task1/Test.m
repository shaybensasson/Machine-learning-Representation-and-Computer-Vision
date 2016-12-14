function [Results] = Test(Model, Data)
%Test Tests the classified model
%   Detailed explanation goes here
    K = Model.K;
    [N_IMAGES, N_SIFTS, SIFT_DIM] = size(Data);    
    AllFeatures = reshape(Data, N_IMAGES*N_SIFTS, SIFT_DIM);
    
    fprintf('Assigning representatives to test SIFT extracted vectors ...\n');
    DistFromCentroids = vl_alldist(double(AllFeatures'), Model.Representatives); %dimsXsamples
    [~, AllAssignments] = min(DistFromCentroids'); %#ok<UDIM> %get closest centroid
    
    AllAssignments = reshape(AllAssignments, N_IMAGES, N_SIFTS, 1);
    
    fprintf('Creating BoW Histogram for each test image ...\n');
    %for each image prepare features to classify
    % make a histogram of clustered word counts for each image. These are the final features.
    Features = zeros(N_IMAGES, K);
    for idxImage=1:N_IMAGES
        Ass = AllAssignments(idxImage,:,:); %only current image assignments
        Features(idxImage, :) = histcounts(Ass,K);
    end
    
    fprintf('Predicting using SVC ...\n');
    [ Results.Predicted, Results.ClassScoreMatrix ] = MClassSVM_Predict(Features, Model.MClassSVM);
end


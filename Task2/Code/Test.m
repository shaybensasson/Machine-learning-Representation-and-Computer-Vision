function [Results] = Test(Model, Data, Params)
%TEST Tests the classified model
%   HOG:
%       for each of the sampals we predict the class using one-vs-all
%       binary classifier using the HOG representation of the image% 
%   SIFT:
%       We assign a trained centroids to each of the SIFTS extracted from 
%       the test images, so later we build histogram for each image 
%       that will act as features that the already trained binary
%       classifiers could predict on
%
%   returns Results:
%      .Predicted: The index of the maximum (most confident) binary 
%               classifier for each test observation
%      .ClassScoreMatrix: All the scores for of all binary classifiers for
%               each test observation

if Params.Model == 'HOG'
    % loop over all exampals
    fprintf('Testing model...\n');
    
    N = size(Data, 1);
    M = length(Model.Classifiers);
    ClassScoreMatrix = zeros(N, M);
    for idxClass=1:M
        %predict using binary classifiers
        
        cls = Model.Classifiers{idxClass};
        ClassScoreMatrix(:, idxClass) = fwd(cls, Data); %NxD
        
        %figure;
        %histogram(ClassScoreMatrix(:, idxClass));
        %title(sprintf('%d', idxClass));
        fprintf('%d/%d ', idxClass, M);
        
    end
    
    fprintf('\n');
    
    %ArgMax on columns
    [~,Predicted] = max(ClassScoreMatrix'); %#ok<UDIM>
    
    Results.Predicted = Predicted';
    Results.ClassScoreMatrix = ClassScoreMatrix;
else
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
end


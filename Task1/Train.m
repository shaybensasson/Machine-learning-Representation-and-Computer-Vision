function [Model] = Train(Data, Labels, Params)
%TRAIN Trains the classifier
%   Detailed explanation goes here

    K = Params.Kmeans.K;
    Model.K = K;
    
    [N_IMAGES, N_SIFTS, SIFT_DIM] = size(Data);
    
    %load('Cache/Kmeans.mat');
    
    fprintf('Fitting Kmeans (K=%d) ...\n', K);
    %tic;
    AllFeatures = reshape(Data, N_IMAGES*N_SIFTS, SIFT_DIM);
    [Centers, AllAssignments, Cost] = vl_kmeans(AllFeatures', K); %dimsXsamples
    %toc %113-144 secs
    %save('Cache/Kmeans.mat', 'Centers', 'AllAssignments', 'Cost')
    
    Model.Representatives = Centers;
        
    AllAssignments = reshape(AllAssignments, N_IMAGES, N_SIFTS);
    
    fprintf('Creating BoW Histogram for each train image ...\n');
    %for each image prepare features to classify
    % make a histogram of clustered word counts for each image. These are the final features.
    Features = zeros(N_IMAGES, K);
    for idxImage=1:N_IMAGES
        Ass = reshape(AllAssignments(idxImage,:,:), N_SIFTS, 1); %only current image assignments
        Features(idxImage, :) = histcounts(Ass,K);
    end
    
    fprintf('Training SVC ...\n');
    Model.MClassSVM = MClassSVM_Train(Features, Labels, Params);
    
end


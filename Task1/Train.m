function [Model] = Train(Data, Labels, Params)
%TRAIN Trains the classifier
if isfield(Params, 'HOG')
    Params = Params.HOG
    %Turn data to numeric vectors
    X = Data;
    Y = Labels';

    SizeSampleVec = size(X,1); 
    tutor = Params.tutor;
    KernelType = Params.KernelType;
    switch KernelType
        case 1
            kernel=linear;
        case 2
            kernel=polynomial(2);
        case 3
            kernel=polynomial(3);
        case 4
            kernel=rbf(0.5);
        case 5
            kernel=rbf(2);
    end

    fprintf(1,'training support vector machine on the HOG...\n');
    NumCatag = length(unique(Y));
    Model.Classifiers = cell(NumCatag,1);

    for IndCatag=1:NumCatag
        %train binary classifier in one-versus-all method
        fprintf('%d/%d ', IndCatag, NumCatag);
        BinaryClasses = double(2*(Y==IndCatag)-1); %0,1 to -1,1 column vector

        %figure;
        %histogram(BinaryClasses);
        %title(sprintf('%d', idxClass));
        Model.Classifiers{IndCatag} = train(svc, tutor, X, BinaryClasses, Params.C, kernel);
    end    
    
else
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
end


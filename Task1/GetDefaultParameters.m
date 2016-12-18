function [Params] = GetDefaultParameters()

    %Returns a struct contain the default experiment parameters
    Params = struct();
    
    Params.Rseed = 2016;
    rng(Params.Rseed);
    
    if isunix
        Params.Data.ROOT_DIR = '.\101_ObjectCategories\';
    else
        Params.Data.ROOT_DIR = '..\101_ObjectCategories\';
    end
    Params.Data.S = 100; %200; Dimension of images after preproc
    if isunix
        Params.Cache.CachePath = '.\Cache';
    else
        Params.Cache.CachePath = '..\Cache';
    end
    
    Params.Cache.UseCacheForGetData = true;
    Params.Cache.CacheForGetData = sprintf('%s\GetData.mat', Params.Cache.CachePath);
    
    Params.Cache.UseCacheForTrainPrepare = true;
    Params.Cache.CacheForTrainPrepare = sprintf('%s\TrainPrepare.mat', Params.Cache.CachePath);
    
    Params.Cache.UseCacheForTrain = true;
    Params.Cache.CacheForTrain = sprintf('%s\Train.mat', Params.Cache.CachePath);
    
    Params.Cache.UseCacheForTestPrepare = true;
    Params.Cache.CacheForTestPrepare = sprintf('%s\TestPrepare.mat', Params.Cache.CachePath);
    
    
    Params.Split.Ratio = 0.20; %test or valdation set proportion
    
    %see http://vision.cse.psu.edu/seminars/talks/2009/random_tff/bosch07a.pdf
    
    Params.Prepare.isHOG = true; % model is SIFT or HOG
    if Params.Prepare.isHOG
        Params.Prepare.HOG.CellSize = 8;
        Params.Prepare.HOG.numOrientations = 21;
    else
        Params.Prepare.SIFT.FeatureVectorDim = 128; %result feature vector dim
        Params.Prepare.SIFT.Scales = [4,8,12,16]; %in pixels
        Params.Prepare.SIFT.Stride = 1; %in pixels
        Params.Prepare.SIFT.ScaleFeatures = 25; %how many features to sample from each scale?
    end
        
    %OVERALL SIFTS SHOULD BE AT LEAST 100K
    %ScaleFeatures*length(Scales)*length(TrainingImages)
    if Params.Prepare.isHOG
        Params.Trian.model = 'HOG';        
        Params.Train.HOG.KernelType = 2; % karnel type (1 -linear, 2 - Polynomial(2), 3 - Polynomial(3), 4 - RBF(0.5), 5 - RBF(2))
        Params.Train.HOG.tutor = smosvctutor;
        Params.Train.HOG.C = 1.0;
    else
        Params.Trian.model = 'SVM';        
        Params.Train.Kmeans.K = 100;
        Params.Train.SVM.C = 0.1; %1
        Params.Train.SVM.Kernel = polynomial(2); %linear
        Params.Train.SVM.Tutor = smosvctutor; %param required for SVM
    end    

    if Params.Prepare.isHOG
        Params.Test.model = 'HOG';        
    else
        Params.Test.model = 'SVM';        
    end
    
    Params.Summary = struct();
    
    Params.Report.ROOT_DIR = 'Results\';
    
    
    Params.IsHyperParamOptimization = false;
    
    

end
function [Params] = GetDefaultParameters()
    %Returns a struct contain the default experiment parameters
    Params = struct();
    
    Params.Rseed = 2016;
    rng(Params.Rseed);
    
    Params.Data.ROOT_DIR = './101_ObjectCategories/';
    Params.Data.S = 100; %Dimension of images after preproc
    
    Params.Cache.CachePath = './Cache';
    Params.Cache.UseCacheForGetData = true;
    Params.Cache.CacheForGetData = sprintf('%s/GetData.mat', Params.Cache.CachePath);
    
    Params.Cache.UseCacheForTrainPrepare = true;
    Params.Cache.CacheForTrainPrepare = sprintf('%s/TrainPrepare.mat', Params.Cache.CachePath);
    
    Params.Cache.UseCacheForTrain = true;
    Params.Cache.CacheForTrain = sprintf('%s/Train.mat', Params.Cache.CachePath);
    
    Params.Cache.UseCacheForTestPrepare = true;
    Params.Cache.CacheForTestPrepare = sprintf('%s/TestPrepare.mat', Params.Cache.CachePath);
    
    
    Params.Split.Ratio = 0.20; %test or valdation set proportion
    
    %see http://vision.cse.psu.edu/seminars/talks/2009/random_tff/bosch07a.pdf
    Params.Prepare.SIFT.FeatureVectorDim = 128; %result feature vector dim
    Params.Prepare.SIFT.Scales = [4,8,12,16]; %in pixels
    Params.Prepare.SIFT.Stride = 1; %in pixels
    Params.Prepare.SIFT.ScaleFeatures = 25; %how many features to sample from each scale?
        
    %OVERALL SIFTS SHOULD BE AT LEAST 100K
    %ScaleFeatures*length(Scales)*length(TrainingImages)
    
    Params.Train.Kmeans.K = 100;
    Params.Train.SVM.C = 0.1; %1
    Params.Train.SVM.Kernel = polynomial(2); %linear
    Params.Train.SVM.Tutor = smosvctutor; %param required for SVM
        
    Params.Summary = struct();
    
    Params.Report.ROOT_DIR = 'Results/';
    
    
    Params.IsHyperParamOptimization = false;
    
    

end
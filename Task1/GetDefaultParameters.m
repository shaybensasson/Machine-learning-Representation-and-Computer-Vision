function [Params] = GetDefaultParameters()
    %Returns a struct contain the default experiment parameters
    Params = struct();
    
    Params.Rseed = 2016;
    rng(Params.Rseed);
    
    Params.Data.ROOT_DIR = './101_ObjectCategories/';
    Params.Data.S = 100; %Dimension of images after preproc
    
    CachePath = './Cache';
    Params.Cache.UseCacheForGetData = true;
    Params.Cache.CacheForGetData = sprintf('%s/GetData.mat', CachePath);
    
    Params.Cache.UseCacheForTrainPrepare = true;
    Params.Cache.CacheForTrainPrepare = sprintf('%s/TrainPrepare.mat', CachePath);
    
    Params.Cache.UseCacheForTrain = true;
    Params.Cache.CacheForTrain = sprintf('%s/Train.mat', CachePath);
    
    Params.Cache.UseCacheForTestPrepare = true;
    Params.Cache.CacheForTestPrepare = sprintf('%s/TestPrepare.mat', CachePath);
    
    
    Params.Split.Ratio = 0.85; %Train/test ratio
    
    %see http://vision.cse.psu.edu/seminars/talks/2009/random_tff/bosch07a.pdf
    Params.Prepare.SIFT.FeatureVectorDim = 128; %result feature vector dim
    Params.Prepare.SIFT.Scales = [4,8,12,16]; %in pixels
    Params.Prepare.SIFT.Stride = 1; %in pixels
    Params.Prepare.SIFT.ScaleFeatures = 25; %how many features to sample from each scale?
    
    Params.Train.Kmeans.K = 500;
    Params.Train.SVM.C = 1;
    Params.Train.SVM.Kernel = linear;
    Params.Train.SVM.Tutor = smosvctutor; %param required for SVM
        
    Params.Summary = struct();
    
    Params.Report.ROOT_DIR = 'Results/';
    
    %TODO:
    

end
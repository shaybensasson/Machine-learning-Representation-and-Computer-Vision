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

Params.Prepare.IsHOG = true; % model is SIFT or HOG
%IMPORTANT: CACHE DIR MUST BE PURGED WHEN CHANGING BETWEEN SIFT AND HOG

if Params.Prepare.IsHOG
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

% common kernel types according to examples provided:
%   (1 -linear, 2 - polynomial(2), 3 - polynomial(3), 4 - rbf(0.5), 5 - rbf(2))
Params.Train.SVM.C = 0.1;
Params.Train.SVM.kernel = polynomial(2); 
Params.Train.SVM.tutor = smosvctutor; %param required for SVM
    
if Params.Prepare.IsHOG
    Params.Train.Model = 'HOG';
else
    Params.Train.Model = 'SVM';
    Params.Train.Kmeans.K = 100;
end

if Params.Prepare.IsHOG
    Params.Test.Model = 'HOG';
else
    Params.Test.Model = 'SVM';
end

Params.Summary = struct();

Params.Report.ROOT_DIR = 'Results\';

%When we are hyper param optimizing we won't like heavy trace or ui reports
Params.IsHyperParamOptimization = false;

end

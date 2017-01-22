function [Params] = GetDefaultParameters()
%Returns a struct contain the default experiment parameters

Params = struct();

Params.Rseed = 2016;
rng(Params.Rseed);

Params.Data.ROOT_DIR = '../PeppersData/PeppersData.mat';
%Params.Data.ROOT_DIR = '../101_ObjectCategories/'; %Gidon - matlab 2014

Params.Data.S = [224, 224, 3] ; %200; Dimension of images after preproc

Params.Cache.CachePath = './Cache/';
%Params.Cache.CachePath = '../Cache/'; %Gidon - matlab 2014

Params.Cache.UseCache = true; %Use persistent mat files or not

Params.Cache.UseCacheForGetData = Params.Cache.UseCache && true;
Params.Cache.CacheForGetData = sprintf('%s/GetData.mat', Params.Cache.CachePath);

Params.Cache.UseCacheForTrainPrepare = Params.Cache.UseCache && false;
Params.Cache.CacheForTrainPrepare = sprintf('%s/TrainPrepare.mat', Params.Cache.CachePath);

Params.Cache.UseCacheForTrain = Params.Cache.UseCache && false;
Params.Cache.CacheForTrain = sprintf('%s/Train.mat', Params.Cache.CachePath);

Params.Cache.UseCacheForTestPrepare = Params.Cache.UseCache && false;
Params.Cache.CacheForTestPrepare = sprintf('%s/TestPrepare.mat', Params.Cache.CachePath);


Params.Split.Ratio = 0.25; %test or valdation set proportion

%see http://vision.cse.psu.edu/seminars/talks/2009/random_tff/bosch07a.pdf

%%
Params.Prepare.NetName = 'imagenet-caffe-alex.mat';
Params.Prepare.UnusedLayers = 20:21;
Params.Prepare.ExtraLayer = true;

% Data augmentation parameters
Params.Prepare.AugFact = 1;
Params.Prepare.DataAugment.Rot = 5;
Params.Prepare.DataAugment.Shif= 10;
Params.Prepare.DataAugment.Nois= 0.001;
Params.Prepare.DataAugment.Flip= 1;

%TODO: Params.Prepare = 
%TODO: Params.Prepare

%%
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

Params.Report.ROOT_DIR = 'Results/';

%When we are hyper param optimizing we won't like heavy trace or ui reports
Params.IsHyperParamOptimization = false;

end
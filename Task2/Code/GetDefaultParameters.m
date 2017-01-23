function [Params] = GetDefaultParameters()
%Returns a struct contain the default experiment parameters

Params = struct();

Params.Rseed = 2016;
rng(Params.Rseed);

Params.Data.DATA_MAT_FILE_PATH = '../PeppersData/PeppersData.mat';

Params.Data.S = [224, 224, 3] ; %Dimension of images after preproc

Params.Cache.CachePath = './Cache/';
%Params.Cache.CachePath = '../Cache/'; %Gidon - matlab 2014

Params.Cache.UseCache = true; %Use persistent mat files or not

Params.Cache.UseCacheForGetData = Params.Cache.UseCache && true;
Params.Cache.CacheForGetData = sprintf('%s/GetData.mat', Params.Cache.CachePath);

Params.Cache.UseCacheForTrainPrepare = Params.Cache.UseCache && true;
Params.Cache.CacheForTrainPrepare = sprintf('%s/TrainPrepare.mat', Params.Cache.CachePath);

Params.Cache.UseCacheForTrain = Params.Cache.UseCache && true;
Params.Cache.CacheForTrain = sprintf('%s/Train.mat', Params.Cache.CachePath);

Params.Cache.UseCacheForTestPrepare = Params.Cache.UseCache && true;
Params.Cache.CacheForTestPrepare = sprintf('%s/TestPrepare.mat', Params.Cache.CachePath);


Params.Split.Ratio = 0.25; %test or valdation set proportion

%% Prepare() Params
Params.Prepare.ExtraLayer = true; %Determines whether to combines AlexNet two last FCs or use only the last one

% Data augmentation parameters
Params.Prepare.AugFact = 1;
Params.Prepare.DataAugment.Rot = 5;
Params.Prepare.DataAugment.Shif= 10;
Params.Prepare.DataAugment.Nois= 0.001;
Params.Prepare.DataAugment.Flip= 1;

%%
%IMPORTANT: CACHE DIR MUST BE PURGED WHEN CHANGING BETWEEN SIFT AND HOG

% common kernel types according to examples provided:
%   (1 -linear, 2 - polynomial(2), 3 - polynomial(3), 4 - rbf(0.5), 5 - rbf(2))
Params.Train.SVM.C = 0.1;
Params.Train.SVM.kernel = polynomial(2);
Params.Train.SVM.tutor = smosvctutor; %param required for SVM

Params.Test = struct();

Params.Summary = struct();

Params.Report.ROOT_DIR = 'Results/';

%When we are hyper param optimizing we won't like heavy trace or ui reports
Params.IsHyperParamOptimization = false;

end
clc; clear; close all;
%% includes
addpath('Helpers');
%addpath('svm_v0.56');
addpath('AngliaSVM');
run ../matconvnet-1.0-beta17/matlab/vl_setupnn


%% Prepare Cross experiment Parameters
Params = GetDefaultParameters();

rng(Params.Rseed); % Seed the random number generator

Params.Experiment = 'Exp_00';

CacheParams = Params.Cache;
if (~CacheParams.UseCache)
    fprintf('NOTICE: UseCache IS DISABLED.\n');
end

%create cache dir if missing
if (~exist(CacheParams.CachePath, 'dir'))
    mkdir(CacheParams.CachePath);
end
    
%% Get data and split it
tTotal = tic;

if (IsGetDataCacheValid(Params.Data, CacheParams))
    fprintf('Loading Cache for GetData ...\n');
    load(CacheParams.CacheForGetData, 'Data', 'Labels', 'Metadata');
else
    [ Data, Labels, Metadata ] = GetData(Params.Data); 
    save(CacheParams.CacheForGetData, 'Data', 'Labels', 'Metadata', 'Params');
end

[ TrainData, TestData , TrainLabels, TestLabels, ~, TestIndices] = ...
    TrainTestSplit(Data, Labels, Params.Split);
clearvars Data Labels 
%% prepare and train
if CacheParams.UseCacheForTrainPrepare && ...
        exist(CacheParams.CacheForTrainPrepare, 'file')
    fprintf('Loading Cache for TrainPrepare ...\n');
    load(CacheParams.CacheForTrainPrepare);
else
    IsTrain = true;
    [TrainDataRep, TrainLabels] = Prepare(TrainData, IsTrain, TrainLabels, Params.Prepare);
    save(CacheParams.CacheForTrainPrepare, 'TrainDataRep');
end
clearvars TrainData 

%%
if CacheParams.UseCacheForTrain && ...
        exist(CacheParams.CacheForTrain, 'file')
    fprintf('Loading Cache for Train ...\n');
    load(CacheParams.CacheForTrain);
else
    Model = Train(TrainDataRep, TrainLabels, Params.Train);
    save(CacheParams.CacheForTrain, 'Model');
end

%% prepare and predict
if CacheParams.UseCacheForTestPrepare && ...
        exist(CacheParams.CacheForTestPrepare, 'file')
    fprintf('Loading Cache for TestPrepare ...\n');
    load(CacheParams.CacheForTestPrepare);
else
    IsTrain = false;
    [TestDataRep, TestLabels] = Prepare(TestData, IsTrain, TestLabels, Params.Prepare);
    save(CacheParams.CacheForTestPrepare, 'TestDataRep');
end

%NOTE: RESULTS.PREDICTED ARE VARYING BETWEEN ITERATIONS THOUGH WE USED SEED
%THIS IS DUE TO RANDOMNESS IN Kmeans PREDICT/fwd cpp code
%One could seed the c stdlib rand inside SmoTutor::SmoTutor() ctor
% to get consistent results
Results = Test(Model, TestDataRep, Params.Test);

%% Calc stats and report results

%Compute the results statistics and return them as fields of Summary
Summary = Evaluate(Results, TestLabels, Params.Summary);

fprintf('The experiment took %.2f seconds.\n', toc(tTotal));

%Draws the results figures, reports results to the screen and persists 
ReportResults(Summary, TestLabels, TestIndices, Metadata, Params);






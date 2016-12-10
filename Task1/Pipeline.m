clc; clear; close all;
%% includes
addpath('Helpers');
%addpath('svm_v0.56');
addpath('AngliaSVM');

addpath('vlfeat-0.9.20/toolbox');
vl_setup();
%%
ClassIndices = 1:10;

Params = GetDefaultParameters();
Params.Data.ClassIndices = ClassIndices;

rng(Params.Rseed);     % Seed the random number generator

%ClassIndices = GetRandomCatsPermutation(Params);
Params.Experiment = 'Exp_00';

CacheParams = Params.Cache;
    
%% Cross experiment pipeline
if (IsGetDataCacheValid(Params.Data, CacheParams))
    fprintf('Loading Cache for GetData ...\n');
    load(CacheParams.CacheForGetData, 'Data', 'Labels');
else
    [ Data, Labels ] = GetData(Params.Data); 
    save(CacheParams.CacheForGetData, 'Data', 'Labels', 'Params');
end

[ TrainData, TestData , TrainLabels, TestLabels ] = TrainTestSplit(Data, Labels, Params.Split);

%%
if CacheParams.UseCacheForTrainPrepare && ...
        exist(CacheParams.CacheForTrainPrepare, 'file')
    fprintf('Loading Cache for TrainPrepare ...\n');
    load(CacheParams.CacheForTrainPrepare);
else
    [TrainDataRep] = Prepare(TrainData, Params.Prepare);
    save(CacheParams.CacheForTrainPrepare, 'TrainDataRep');
end

if CacheParams.UseCacheForTrain && ...
        exist(CacheParams.CacheForTrain, 'file')
    fprintf('Loading Cache for Train ...\n');
    load(CacheParams.CacheForTrain);
else
    Model = Train(TrainDataRep, TrainLabels, Params.Train);
    save(CacheParams.CacheForTrain, 'Model');
end

%%
if CacheParams.UseCacheForTestPrepare && ...
        exist(CacheParams.CacheForTestPrepare, 'file')
    fprintf('Loading Cache for TestPrepare ...\n');
    load(CacheParams.CacheForTestPrepare);
else
    [TestDataRep] = Prepare(TestData, Params.Prepare);
    save(CacheParams.CacheForTestPrepare, 'TestDataRep');
end

Results = Test(Model, TestDataRep);

Summary = Evaluate(Results, TestLabels, Params.Summary);
ReportResults(Summary, Params);






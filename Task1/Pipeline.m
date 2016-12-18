clc; clear; close all;
%% includes
addpath('Helpers');
%---addpath('svm_v0.56');
%addpath('AngliaSVM');
%addpath('vlfeat-0.9.20/toolbox');
%vl_setup();

fprintf(1,'Loading HOG  tool...\n');
run('C:\Users\Gidon\Google Drive\matlab\CaltechProj\vlfeat2-19\vlfeat\toolbox\vl_setup')
fprintf(1,'Loading SVM tool...\n');
run('C:\Users\Gidon\Google Drive\matlab\CaltechProj\AngliaSVM\compilemex')
addpath('C:\Users\Gidon\Google Drive\matlab\CaltechProj\AngliaSVM\')

%%
ClassIndices = 1:10;
%ClassIndices = 11:20;

Params = GetDefaultParameters();

rng(Params.Rseed);     % Seed the random number generator
vl_twister('STATE', Params.Rseed); %Seed the random number generator of KMEANS, EXTEREMLY IMPORTANT!

%ClassIndices = GetRandomCatsPermutation(Params);
Params.Data.ClassIndices = ClassIndices;
Params.Experiment = 'Exp_00';

CacheParams = Params.Cache;
    
%% Cross experiment pipeline
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

%TODO: RESULTS.PREDICTED ARE VARYING BETWEEN ITERATIONS THOUGH WE USED SEED
%THIS IS DUE TO RANDOMNESS IN Kmeans PREDICT/fwd cpp code
Results = Test(Model, TestDataRep, Params.Test); % Gidon 18-12 - i added another parametr to the function: [Params]

Summary = Evaluate(Results, TestLabels, Params.Summary);

fprintf('The experiment took %.2f seconds.\n', toc(tTotal));

%% 
ReportResults(Summary, TestLabels, TestIndices, Metadata, Params);





